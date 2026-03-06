"""Flask application factory."""

from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

db = SQLAlchemy()
jwt = JWTManager()
migrate = Migrate()


def create_app() -> Flask:
    """Create and configure the Flask application.

    Returns:
        A fully configured Flask application instance.
    """
    app = Flask(__name__)

    # Load configuration
    from .config import Config
    app.config.from_object(Config)

    # Allow requests from the Flutter web app and local dev server.
    # Set CORS_ORIGINS in .env for production (comma-separated list of origins).
    cors_origins = app.config.get("CORS_ORIGINS", "*")
    CORS(app, resources={r"/api/*": {"origins": cors_origins}})

    # Initialise extensions
    db.init_app(app)
    jwt.init_app(app)
    migrate.init_app(app, db)

    # Register blueprints
    from .routes.auth import auth_bp
    from .routes.timetable import timetable_bp
    from .routes.mitteilungen import mitteilungen_bp

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(timetable_bp, url_prefix="/api/timetable")
    app.register_blueprint(mitteilungen_bp, url_prefix="/api/mitteilungen")

    # Create tables on first run (for SQLite / dev)
    with app.app_context():
        db.create_all()

    return app
