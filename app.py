from flask import Flask, render_template, redirect, url_for, session, request, flash
from flask_login import LoginManager, login_user, login_required, logout_user
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from datetime import timedelta
from models import db, User
from auth import auth_bp

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://medcore:medcorepassword@127.0.0.1:3306/medcore_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['REMEMBER_COOKIE_DURATION'] = timedelta(days=7)

db.init_app(app)
migrate = Migrate(app, db)
app.secret_key = 'mysecretkey'

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'auth.login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Blueprints
app.register_blueprint(auth_bp)

print(app.url_map)


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/test-db')
def test_db():
    try:
        db.session.execute(text('SELECT 1'))
        return 'Database connection successful!', 200
    except Exception as e:
        return f'Error connecting to the database: {str(e)}', 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
