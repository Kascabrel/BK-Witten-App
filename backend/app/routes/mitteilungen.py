"""Mitteilungen (announcements) CRUD routes.

GET    /api/mitteilungen/          – List all Mitteilungen (newest first).
POST   /api/mitteilungen/          – Create a new Mitteilung.
GET    /api/mitteilungen/<id>      – Get a single Mitteilung.
PUT    /api/mitteilungen/<id>      – Update a Mitteilung (author only).
DELETE /api/mitteilungen/<id>      – Delete a Mitteilung (author only).

All routes require a valid JWT.
"""

from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity

from .. import db
from ..models import Mitteilung

mitteilungen_bp = Blueprint("mitteilungen", __name__)


@mitteilungen_bp.route("/", methods=["GET"])
@jwt_required()
def list_mitteilungen():
    """Return all Mitteilungen ordered by creation date (newest first).

    Returns:
        200: JSON array of Mitteilung objects.
    """
    items = Mitteilung.query.order_by(Mitteilung.created_at.desc()).all()
    return jsonify([m.to_dict() for m in items]), 200


@mitteilungen_bp.route("/", methods=["POST"])
@jwt_required()
def create_mitteilung():
    """Create a new Mitteilung.

    Request body (JSON):
        title   (str): Short headline (max 200 chars).
        content (str): Full announcement text.

    Returns:
        201: The newly created Mitteilung object.
        400: Missing or invalid fields.
    """
    data = request.get_json(silent=True) or {}
    title: str = data.get("title", "").strip()
    content: str = data.get("content", "").strip()

    if not title or not content:
        return jsonify({"error": "title und content sind erforderlich"}), 400
    if len(title) > 200:
        return jsonify({"error": "title ist zu lang (max 200 Zeichen)"}), 400

    author: str = get_jwt_identity()
    mitteilung = Mitteilung(title=title, content=content, author=author)
    db.session.add(mitteilung)
    db.session.commit()

    return jsonify(mitteilung.to_dict()), 201


@mitteilungen_bp.route("/<int:mitteilung_id>", methods=["GET"])
@jwt_required()
def get_mitteilung(mitteilung_id: int):
    """Return a single Mitteilung by its ID.

    Returns:
        200: Mitteilung object.
        404: Not found.
    """
    mitteilung = db.session.get(Mitteilung, mitteilung_id)
    if mitteilung is None:
        return jsonify({"error": "Mitteilung nicht gefunden"}), 404
    return jsonify(mitteilung.to_dict()), 200


@mitteilungen_bp.route("/<int:mitteilung_id>", methods=["PUT"])
@jwt_required()
def update_mitteilung(mitteilung_id: int):
    """Update an existing Mitteilung.

    Only the original author may update a Mitteilung.

    Request body (JSON):
        title   (str, optional): New title.
        content (str, optional): New content.

    Returns:
        200: Updated Mitteilung object.
        400: Invalid fields.
        403: Current user is not the author.
        404: Not found.
    """
    mitteilung = db.session.get(Mitteilung, mitteilung_id)
    if mitteilung is None:
        return jsonify({"error": "Mitteilung nicht gefunden"}), 404

    current_user: str = get_jwt_identity()
    if mitteilung.author != current_user:
        return jsonify({"error": "Keine Berechtigung"}), 403

    data = request.get_json(silent=True) or {}
    new_title: str = data.get("title", mitteilung.title).strip()
    new_content: str = data.get("content", mitteilung.content).strip()

    if not new_title or not new_content:
        return jsonify({"error": "title und content dürfen nicht leer sein"}), 400
    if len(new_title) > 200:
        return jsonify({"error": "title ist zu lang (max 200 Zeichen)"}), 400

    mitteilung.title = new_title
    mitteilung.content = new_content
    db.session.commit()

    return jsonify(mitteilung.to_dict()), 200


@mitteilungen_bp.route("/<int:mitteilung_id>", methods=["DELETE"])
@jwt_required()
def delete_mitteilung(mitteilung_id: int):
    """Delete a Mitteilung.

    Only the original author may delete a Mitteilung.

    Returns:
        200: Deletion confirmation.
        403: Current user is not the author.
        404: Not found.
    """
    mitteilung = db.session.get(Mitteilung, mitteilung_id)
    if mitteilung is None:
        return jsonify({"error": "Mitteilung nicht gefunden"}), 404

    current_user: str = get_jwt_identity()
    if mitteilung.author != current_user:
        return jsonify({"error": "Keine Berechtigung"}), 403

    db.session.delete(mitteilung)
    db.session.commit()

    return jsonify({"message": "Mitteilung gelöscht"}), 200
