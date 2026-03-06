# BK-Witten App – Backend

Flask REST API that serves as a backend for the BK-Witten Flutter application.
It integrates with **WebUntis** for authentication and timetable data, and
provides a simple CRUD API for school announcements (*Mitteilungen*).

---

## Requirements

- Python ≥ 3.11
- A WebUntis school account (server + school name)

---

## Quick-start

```bash
# 1. Create and activate a virtual environment
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Configure environment variables
cp .env.example .env
# Edit .env and fill in your WebUntis server, school name, and secret keys

# 4. Start the development server
python run.py
```

The API will be available at `http://localhost:5000`.

---

## API Reference

### Authentication (`/api/auth`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | Login with WebUntis credentials → returns JWT |
| POST | `/api/auth/logout` | Logout (client discards token) |
| GET  | `/api/auth/me` | Return current user profile |

**Login request body:**
```json
{ "username": "max.mustermann", "password": "geheim" }
```

**Login response:**
```json
{
  "access_token": "<JWT>",
  "username": "max.mustermann",
  "display_name": "Max Mustermann"
}
```

---

### Timetable (`/api/timetable`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/timetable/week` | Get timetable for a given week |

**Query parameters:**

| Param | Required | Description |
|-------|----------|-------------|
| `date` | No | ISO date (`YYYY-MM-DD`), defaults to today |
| `password` | Yes | WebUntis password (re-sent to fetch live data) |

**Response:** JSON object compatible with the Flutter `StudentplanPage`:
```json
{
  "days": ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"],
  "lessons": [
    {
      "day": "Montag",
      "subject": "Mathematik",
      "teacher": "Max Müller",
      "room": "A201",
      "start": "08:00",
      "end": "09:30"
    }
  ]
}
```

---

### Mitteilungen (`/api/mitteilungen`)

All endpoints require `Authorization: Bearer <token>` header.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET    | `/api/mitteilungen/` | List all announcements |
| POST   | `/api/mitteilungen/` | Create a new announcement |
| GET    | `/api/mitteilungen/<id>` | Get a single announcement |
| PUT    | `/api/mitteilungen/<id>` | Update an announcement (author only) |
| DELETE | `/api/mitteilungen/<id>` | Delete an announcement (author only) |

**Create / Update request body:**
```json
{ "title": "Wichtige Info", "content": "Bitte beachten..." }
```

---

## Project Structure

```
backend/
├── app/
│   ├── __init__.py          # Flask application factory
│   ├── config.py            # Environment-based configuration
│   ├── models.py            # SQLAlchemy models
│   └── routes/
│       ├── auth.py          # Authentication (WebUntis + JWT)
│       ├── timetable.py     # Timetable proxy
│       └── mitteilungen.py  # Announcements CRUD
├── .env.example             # Environment variable template
├── requirements.txt
└── run.py                   # Development entry point
```
