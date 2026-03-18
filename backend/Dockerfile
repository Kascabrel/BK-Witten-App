# ── Stage 1: build dependencies ─────────────────────────────
FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --prefix=/install --no-cache-dir -r requirements.txt

# ── Stage 2: runtime ───────────────────────────────────────
FROM python:3.12-slim

WORKDIR /app

# Copy dependencies
COPY --from=builder /install /usr/local

# Copy app
COPY . .

# Install gunicorn
RUN pip install --no-cache-dir gunicorn

# Flask config
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

# Start app
CMD ["sh", "-c", "flask db upgrade && gunicorn -w 4 -b 0.0.0.0:5000 run:app"]