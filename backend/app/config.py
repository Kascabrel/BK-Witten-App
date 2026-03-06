"""Application configuration.

Values are read from environment variables (populated via .env in development).
Copy `.env.example` to `.env` and fill in the real values before running.
"""

import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    # Flask core
    SECRET_KEY: str = os.getenv("SECRET_KEY", "dev-secret-key")
    DEBUG: bool = os.getenv("FLASK_ENV", "development") == "development"

    # SQLAlchemy
    SQLALCHEMY_DATABASE_URI: str = os.getenv(
        "DATABASE_URL", "sqlite:///bkwitten.db"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS: bool = False

    # Flask-JWT-Extended
    JWT_SECRET_KEY: str = os.getenv("JWT_SECRET_KEY", "dev-jwt-secret")
    JWT_ACCESS_TOKEN_EXPIRES: int = 3600  # 1 hour

    # CORS – restrict to specific origins in production
    # (comma-separated list in CORS_ORIGINS env variable)
    CORS_ORIGINS: str = os.getenv("CORS_ORIGINS", "*")

    # WebUntis – filled in by the user via .env
    WEBUNTIS_SERVER: str = os.getenv("WEBUNTIS_SERVER", "schule.webuntis.com")
    WEBUNTIS_SCHOOL: str = os.getenv("WEBUNTIS_SCHOOL", "BK-Witten")
