use dotenv::dotenv;
use tracing::info;
use tracing_subscriber;
use actix_web::{App, HttpServer, web};
use db::connect_to_db;

mod db;
mod handlers;
mod routes;
mod auth;
mod errors;
mod models;

#[actix_web::main]
async fn main() -> std::io::Result<()> {

    dotenv().ok(); 

    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::INFO) 
        .init();

    info!("🚀 Server starting on http://127.0.0.1:8080");

    let pool = connect_to_db().await.map_err(|e| {
        eprintln!("❌ Database connection failed: {:?}", e);
        std::io::Error::new(std::io::ErrorKind::Other, e.to_string()) // Convert AppError to std::io::Error
    })?;

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone())) // ✅ Share DB pool across app
            .configure(routes::config)
    })
    .workers(16)
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}

