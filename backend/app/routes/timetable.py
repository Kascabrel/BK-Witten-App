"""Timetable routes — proxy to the WebUntis API.

GET /api/timetable/week?date=YYYY-MM-DD&klasse=KLASSENNAME
    Return the timetable for a school class for the week containing the
    given date (defaults to the current week).

Requires a valid JWT in the ``Authorization: Bearer <token>`` header.
"""

from datetime import date, datetime, timedelta
from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import jwt_required, get_jwt_identity
import webuntis.session as webuntis
import webuntis.errors as webuntis_errors

timetable_bp = Blueprint("timetable", __name__)


def _monday_of_week(ref: date) -> date:
    """Return the Monday of the ISO week that contains *ref*."""
    return ref - timedelta(days=ref.weekday())


@timetable_bp.route("/week", methods=["GET"])
@jwt_required()
def get_week_timetable():
    """Return the timetable for one calendar week.

    Query parameters:
        date     (str, optional): ISO date string ``YYYY-MM-DD``.
                                  Defaults to today.
        password (str, required): WebUntis password (re-sent to fetch live
                                  data, because the JWT only carries the
                                  username).
        klasse   (str, optional): School class name (e.g. ``"IT21A"``).
                                  When omitted the first class returned by
                                  WebUntis is used.

    Returns:
        200: JSON ``{ days: [...], lessons: [...] }`` matching the
             structure already consumed by the Flutter ``StudentplanPage``.
        400: Invalid date format or missing password.
        401: Missing JWT or bad WebUntis credentials.
        502: WebUntis server unreachable.
    """
    identity: str = get_jwt_identity()

    # Parse optional date parameter
    date_str: str = request.args.get("date", "")
    try:
        ref_date: date = (
            datetime.strptime(date_str, "%Y-%m-%d").date()
            if date_str
            else date.today()
        )
    except ValueError:
        return jsonify({"error": "Ungültiges Datumsformat (erwartet YYYY-MM-DD)"}), 400

    monday: date = _monday_of_week(ref_date)
    friday: date = monday + timedelta(days=4)

    # WebUntis credentials – the password must be re-sent from the client
    password: str = request.args.get("password", "")
    klasse_name: str = request.args.get("klasse", "")

    if not password:
        return jsonify({"error": "Passwort erforderlich"}), 400

    server: str = current_app.config["WEBUNTIS_SERVER"]
    school: str = current_app.config["WEBUNTIS_SCHOOL"]

    day_names = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"]

    try:
        session = webuntis.Session(
            username=identity,
            password=password,
            server=server,
            school=school,
            useragent="BKWittenApp/1.0",
        )
        session.login()

        # Resolve the klasse object
        klassen = session.klassen()
        if klasse_name:
            matches = klassen.filter(name=klasse_name)
            if not matches:
                session.logout()
                return jsonify({"error": f"Klasse '{klasse_name}' nicht gefunden"}), 404
            klasse = matches[0]
        else:
            if not klassen:
                session.logout()
                return jsonify({"error": "Keine Klassen gefunden"}), 404
            klasse = klassen[0]

        lessons_raw = session.timetable(klasse=klasse, start=monday, end=friday)
        session.logout()

        # Build the same JSON structure the Flutter app expects
        lessons_out = []
        for lesson in lessons_raw:
            lesson_date: date = lesson.start.date()
            weekday_idx: int = lesson_date.weekday()
            if weekday_idx > 4:
                continue  # skip weekends

            subject: str = (
                ", ".join(s.long_name for s in lesson.subjects)
                if lesson.subjects
                else "—"
            )
            teacher: str = (
                ", ".join(
                    f"{t.fore_name} {t.long_name}".strip()
                    for t in lesson.teachers
                )
                if lesson.teachers
                else "—"
            )
            room: str = (
                ", ".join(r.long_name for r in lesson.rooms)
                if lesson.rooms
                else "—"
            )

            lessons_out.append(
                {
                    "day": day_names[weekday_idx],
                    "subject": subject,
                    "teacher": teacher,
                    "room": room,
                    "start": lesson.start.strftime("%H:%M"),
                    "end": lesson.end.strftime("%H:%M"),
                }
            )

        return jsonify({"days": day_names, "lessons": lessons_out}), 200

    except webuntis_errors.BadCredentialsError:
        return jsonify({"error": "Ungültige Anmeldedaten"}), 401
    except webuntis_errors.NotLoggedInError:
        return jsonify({"error": "Anmeldung fehlgeschlagen"}), 401
    except Exception as exc:
        current_app.logger.error("WebUntis timetable error: %s", exc)
        return jsonify({"error": "Stundenplan konnte nicht geladen werden"}), 502
