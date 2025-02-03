use actix_web::{post, web, HttpResponse};
use actix_web_validator::Json;
use serde::{Deserialize, Serialize};
use sqlx::PgPool;
use tracing::{instrument, info};

use crate::auth::jwt::{create_jwt_token,
    create_recovery_jwt_token,
    send_recovery_email};
use crate::auth::password::{ verify_password, RecoveryRequest };
use crate::auth::queries::{
    create_new_user, 
    query_password_hash, 
    query_user_claims, 
    user_exists
};
use crate::errors::AppError;
use crate::models::user::{ NewUser, RegisterRequest };




/// Request format for login
#[derive(Debug, Serialize, Deserialize)]
pub struct LoginRequest {
    pub username: String,
    pub password: String,
}

/// Response format for login
#[derive(Debug, Serialize, Deserialize)]
pub struct LoginResponse {
    pub token: String,
}


#[post("/register")]
#[instrument]
async fn register(
    user: Json<RegisterRequest>,
    pool: web::Data<PgPool>
) -> Result<HttpResponse, AppError> {

    // ✅ Convert RegisterRequest -> User (hashes password inside `try_from`)
    let new_user = NewUser::try_from(user.into_inner())?;

    // ✅ Insert new user into DB
    create_new_user(&new_user, pool.get_ref()).await?;

    Ok(HttpResponse::Created().json("User registered successfully"))
}

/// Receives a login request and returns a JWT token if the password matches
#[post("/login")]
#[instrument(skip(pool, user))]
async fn login(user: web::Json<LoginRequest>, pool: web::Data<PgPool>) -> Result<HttpResponse, AppError> {
    info!("🔵 Received login request for username: {}", user.username);

    let password_hash: String = query_password_hash(user.username.as_str(), pool.get_ref()).await?;
    
    if verify_password(&user.password, &password_hash).unwrap_or(false) {
        // Fetch user details from database
        let user_data = query_user_claims(user.username.as_str(), pool.get_ref()).await?;

        let token = create_jwt_token(
            user_data.sub,
            user_data.roles,
            user_data.clinics_id,
        ).map_err(AppError::JWTError)?;

        Ok(HttpResponse::Ok().json(LoginResponse { token }))
    } else {
        info!("🚨 Password mismatch for user: {}", user.username);
        Err(AppError::InvalidCredentials)
    }
}

#[post("/recover-password")]
async fn recover_password(request: web::Json<RecoveryRequest>, pool: web::Data<PgPool>) -> Result<HttpResponse, AppError> {

    let recovery_message: &str = "Se esse email existir, você receberá um email com instruções para redefinir sua senha.";

    // The ? operator unwraps the result and so the function can be compared to an Option
    if let Some(user_id) = user_exists(&request.email, pool.get_ref()).await? {
        let token = create_recovery_jwt_token(&request.email, user_id, pool.get_ref()).await?;

        // TODO 
        send_recovery_email(&request.email, &token);
        
    }

    // Take a look on how the if let would be without the ? operator (it unwraps the result):
    //     if let Ok(Some(user_id)) = user_exists(email, pool.get_ref()).await {
    // let token = create_recovery_jwt_token(email, user_id, pool.get_ref()).await?;
    // send_recovery_email(email, &token);
    // HttpResponse::Ok().json(recovery_message);
    // }

    Ok(HttpResponse::Ok().json(recovery_message))
}
    

