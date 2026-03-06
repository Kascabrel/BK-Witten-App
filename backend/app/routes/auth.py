"""Authentication routes using WebUntis as the identity provider.

POST /api/auth/login   – Authenticate against WebUntis, return JWT.
POST /api/auth/logout  – Invalidate the current session (client-side).
GET  /api/auth/me      – Return the current user's profile (from JWT).
"""

from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import (
    create_access_token,
    get_jwt_identity,
    jwt_required,
)
import webuntis.session as webuntis
import webuntis.errors as webuntis_errors

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/login", methods=["POST"])
def login():
    """Authenticate a user via WebUntis credentials.

    Request body (JSON):
        username (str): WebUntis username.
        password (str): WebUntis password.

    Returns:
        200: JSON with ``access_token``, ``username``, and ``display_name``.
        400: Missing fields.
        401: Invalid credentials.
        502: Cannot reach WebUntis server.
    """
    data = request.get_json(silent=True) or {}
    username: str = data.get("username", "").strip()
    password: str = data.get("password", "")

    if not username or not password:
        return jsonify({"error": "username and password are required"}), 400

    server: str = current_app.config["WEBUNTIS_SERVER"]
    school: str = current_app.config["WEBUNTIS_SCHOOL"]

    try:
        session = webuntis.Session(
            username=username,
            password=password,
            server=server,
            school=school,
            useragent="BKWittenApp/1.0",
        )
        session.login()
        session.logout()

        # The webuntis package does not expose a display-name endpoint in v0.1.x,
        # so we use the username as the display name.
        display_name: str = username

        # Issue a JWT containing the WebUntis username as identity
        access_token: str = create_access_token(
            identity=username,
            additional_claims={"display_name": display_name},
        )
        return jsonify(
            {
                "access_token": access_token,
                "username": username,
                "display_name": display_name,
            }
        ), 200

    except webuntis_errors.BadCredentialsError:
        return jsonify({"error": "Ungültige Anmeldedaten"}), 401
    except webuntis_errors.NotLoggedInError:
        return jsonify({"error": "Anmeldung fehlgeschlagen"}), 401
    except Exception as exc:
        current_app.logger.error("WebUntis login error: %s", exc)
        return jsonify({"error": "WebUntis-Server nicht erreichbar"}), 502


@auth_bp.route("/logout", methods=["POST"])
@jwt_required()
def logout():
    """Logout endpoint (client-side JWT invalidation).

    The JWT is stateless; the client simply discards the token.
    A server-side blocklist can be added here if needed.

    Returns:
        200: Logout confirmation message.
    """
    return jsonify({"message": "Erfolgreich abgemeldet"}), 200


@auth_bp.route("/me", methods=["GET"])
@jwt_required()
def me():
    """Return the profile of the currently authenticated user.

    Returns:
        200: JSON with ``username`` and ``display_name``.
        401: Missing or invalid JWT.
    """
    from flask_jwt_extended import get_jwt

    identity: str = get_jwt_identity()
    claims: dict = get_jwt()
    return jsonify(
        {
            "username": identity,
            "display_name": claims.get("display_name", identity),
        }
    ), 200
