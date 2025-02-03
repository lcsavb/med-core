use std::env;

use sqlx::postgres::{PgPool, PgPoolOptions};

use crate::errors::AppError;



pub async fn connect_to_db() -> Result<PgPool, AppError> {
    let database_url = env::var("DATABASE_URL").map_err(|_| AppError::ConfigError)?;

    let max_conn = env::var("MAX_DB_CONNECTIONS")
        .map_err(|_| AppError::ConfigError)?
        .parse::<u32>()
        .map_err(|_| AppError::ConfigError)?;

    let pool = PgPoolOptions::new()
        .max_connections(max_conn)
        .acquire_timeout(std::time::Duration::from_secs(10))
        .connect(&database_url)
        .await?;

    eprintln!("✅ Connected to PostgreSQL (Max connections: {})", max_conn);
    Ok(pool)
}
