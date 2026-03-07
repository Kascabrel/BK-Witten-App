from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import (
    create_access_token,
    get_jwt_identity,
    jwt_required,
)
import webuntis
import webuntis.errors as webuntis_errors

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.get_json(silent=True) or {}
    username = data.get("username", "").strip()
    password = data.get("password", "")

    if not username or not password:
        return jsonify({"error": "username and password are required"}), 400

    server = current_app.config["WEBUNTIS_SERVER"]
    school = current_app.config["WEBUNTIS_SCHOOL"]

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

        display_name = username

        access_token = create_access_token(
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
        current_app.logger.error(f"WebUntis login error: {exc}")
        return jsonify({"error": "WebUntis-Server nicht erreichbar"}), 502


@auth_bp.route("/logout", methods=["POST"])
@jwt_required()
def logout():
    return jsonify({"message": "Erfolgreich abgemeldet"}), 200


@auth_bp.route("/me", methods=["GET"])
@jwt_required()
def me():
    from flask_jwt_extended import get_jwt

    identity = get_jwt_identity()
    claims = get_jwt()

    return jsonify(
        {
            "username": identity,
            "display_name": claims.get("display_name", identity),
        }
    ), 200
