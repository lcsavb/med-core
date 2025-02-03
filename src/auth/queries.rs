use sqlx::PgPool;
use uuid::Uuid;

use crate::errors::AppError;
use crate::models::user:: { NewUser, Claim }; // Import the User type from the models module

pub async fn query_password_hash(username: &str, pool: &PgPool) -> Result<String, AppError> {
    let result = sqlx::query_scalar::<_, String>(
        "SELECT password_hash FROM users WHERE username = $1"
    )
    .bind(username)  // ✅ Use .bind() for parameters
    .fetch_optional(pool)
    .await?;

    match result {
        Some(hash) => Ok(hash),
        None => Err(AppError::InvalidCredentials), // ✅ Prevents user enumeration
    }
}


pub async fn create_new_user(user: &NewUser, pool: &PgPool) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO users (username, name, email, phone, password_hash, status, created_at, roles)
         VALUES ($1, $2, $3, $4, $5, $6::status_enum, $7, $8::jsonb)" // ✅ `::jsonb` works fine here
    )
    .bind(&user.username)
    .bind(&user.name)
    .bind(&user.email)
    .bind(&user.phone)
    .bind(&user.password_hash)
    .bind(&user.status.to_string().to_lowercase())
    .bind(&user.created_at)
    .bind(serde_json::to_value(&user.roles).unwrap()) // ✅ Proper JSON handling
    .execute(pool)
    .await
    .map_err(|e| AppError::DatabaseError(e.to_string()))?;

    Ok(())
}

pub async fn user_exists(email: &str, pool: &PgPool) -> Result<Option<Uuid>, AppError> {
    let query_result = sqlx::query_scalar!(
        "SELECT id FROM users WHERE email = $1",
        email
    )
    .fetch_optional(pool)
    .await?;

    Ok(query_result)
}

pub async fn query_user_claims(username: &str, pool: &PgPool) -> Result<Claim, AppError> {

    let row = sqlx::query!(
        "
        SELECT 
            u.id AS user_id, 
            u.username AS sub, 
            u.roles AS roles,  
            COALESCE(ARRAY_REMOVE(ARRAY_AGG(c.id), NULL), ARRAY[]::UUID[]) AS clinics_id
        FROM users u
        LEFT JOIN clinics c ON u.id = c.user_id
        WHERE u.username = $1
        GROUP BY u.id, u.username, u.roles;
        ",
        username
    )
    .fetch_one(pool)
    .await?;


    let roles: Vec<String> = serde_json::from_value(row.roles)
    .map_err(|e| {
        AppError::SerializationError(e.to_string()) 
    })?;


    let claim = Claim {
        sub: row.user_id,
        exp: 0, // Example expiration time
        email: "".to_string(),
        clinics_id: row.clinics_id.unwrap_or_default(),
        roles: roles,
    };


    Ok(claim)
}


