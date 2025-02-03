use std::env;
use chrono::Utc; 

use actix_web::{dev::ServiceRequest, Error, HttpMessage};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use jsonwebtoken::{encode, decode, Header, Validation, EncodingKey, DecodingKey, Algorithm};
use sqlx::PgPool;
use uuid::Uuid;

use crate::models::user::Claim;
use crate::errors::AppError;


/// Load JWT secret key from the environment
fn get_secret_key() -> String {
    env::var("JWT_SECRET_KEY").unwrap_or_else(|_| "secretkey".to_string())
}


fn token_expiration(time: i64) -> i64 {
    Utc::now()
    .checked_add_signed(chrono::Duration::minutes(time)) // ✅ Correct method
    .map(|t| t.timestamp()) // Convert to Unix timestamp safely
    .unwrap_or_else(|| Utc::now().timestamp()) // Fallback: current timestamp
}

fn encode_token(claims: Claim) -> Result<String, jsonwebtoken::errors::Error> {
    let secret = get_secret_key();
    encode(
        &Header { alg: Algorithm::HS256, ..Default::default() }, // ✅ Explicitly set HS256
        &claims,
        &EncodingKey::from_secret(secret.as_ref())
    )
}

pub fn create_jwt_token(user_id: Uuid, roles: Vec<String>, clinics_id: Vec<Uuid>) -> Result<String, jsonwebtoken::errors::Error> {
    let expiration = token_expiration(24*60); 

    let claims = Claim {
        sub: user_id,
        exp: expiration,
        email: "".to_string(),
        clinics_id,
        roles
    };

    encode_token(claims)
}

pub async fn create_recovery_jwt_token(email: &str, user_id: Uuid, pool: &PgPool) -> Result<String, AppError>{
    let expiration = token_expiration(15); // 15 minutes
    
    let claims = Claim {
        sub: user_id,
        exp: expiration,
        email: email.to_string(),
        roles: vec![],
        clinics_id: vec![],
    };

    let recovery_token = encode_token(claims).map_err(AppError::JWTError)?;

    // TODO a general update query which will accept dinamic values
    sqlx::query!(
        "UPDATE users SET recovery_token = $1 WHERE id = $2",
        recovery_token,
        user_id
    )
    .execute(pool)
    .await?;



    Ok(recovery_token)
}

pub fn send_recovery_email(email: &str, recovery_token: &str) -> () {
    // Send email with recovery token
    println!("Sending recovery email to: {} with token: {}", email, recovery_token);
}



/// Validate JWT token
pub fn validate_token(token: &str) -> Result<Claim, jsonwebtoken::errors::Error> {
    let decoded = decode::<Claim>(
        token,
        &DecodingKey::from_secret(get_secret_key().as_bytes()),
        &Validation::default(),
    )?;
    Ok(decoded.claims)
}

pub async fn validator(req: ServiceRequest, credentials: BearerAuth) -> Result<ServiceRequest, (Error, ServiceRequest)> {

    if credentials.token().is_empty() {
        eprintln!("🚨 Authentication failed: Missing token"); // ✅ Debugging log
        return Err((actix_web::error::ErrorUnauthorized("Missing token"), req));
    }


    match validate_token(credentials.token()) {
        Ok(claims) => {
            req.extensions_mut().insert(claims); // ✅ Store claims inside request
            Ok(req)
        }
        Err(err) => {
            eprintln!("🚨 Authentication failed: {:?}", err); // ✅ Debugging log
            Err((actix_web::error::ErrorUnauthorized("Invalid or missing token"), req))
        }
    }
}