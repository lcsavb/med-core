use actix_web::web;
use argon2::{Argon2, PasswordHasher, PasswordVerifier, password_hash::{SaltString, rand_core::OsRng, PasswordHash}};
use serde::{Serialize, Deserialize};
use validator::Validate;

use crate::errors::AppError;

pub fn hash_it(password: &str) -> Result<String, AppError> {
    let salt = SaltString::generate(&mut OsRng); // Generate a random salt
    let argon2 = Argon2::default();

    let hashed_password = argon2.hash_password(password.as_bytes(), &salt)
        .map_err(|_| AppError::InternalError)?;

    let hashed_password_str = hashed_password.to_string();

    Ok(hashed_password_str)
}

pub fn verify_password(typed_password: &str, hash: &str) -> Result<bool, AppError> {
    let parsed_hash = PasswordHash::new(hash)
        .map_err(|_| AppError::InternalError)?;

    Argon2::default().verify_password(typed_password.as_bytes(), &parsed_hash)
        .map_err(|_| AppError::InvalidCredentials)?;

    Ok(true)
}

#[derive(Debug, Serialize, Deserialize, Validate)]
pub struct RecoveryRequest {
    #[validate(email(message = "Invalid email"))]
    pub email: String,
}

impl TryFrom<web::Json<RecoveryRequest>> for RecoveryRequest {
    type Error = AppError;

    fn try_from(request: web::Json<RecoveryRequest>) -> Result<Self, Self::Error> {
        Ok(request.into_inner())
    }
}