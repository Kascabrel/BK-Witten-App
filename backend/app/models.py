"""SQLAlchemy database models."""

from datetime import datetime, timezone
from . import db


class Mitteilung(db.Model):
    """A school announcement / message (Mitteilung).

    Can be created by any authenticated user via the REST API and
    read by everyone who is logged in.
    """

    __tablename__ = "mitteilungen"

    id: int = db.Column(db.Integer, primary_key=True)
    title: str = db.Column(db.String(200), nullable=False)
    content: str = db.Column(db.Text, nullable=False)
    author: str = db.Column(db.String(100), nullable=False)
    created_at: datetime = db.Column(
        db.DateTime,
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
    )
    updated_at: datetime = db.Column(
        db.DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False,
    )

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "title": self.title,
            "content": self.content,
            "author": self.author,
            "created_at": self.created_at.isoformat(),
            "updated_at": self.updated_at.isoformat(),
        }
