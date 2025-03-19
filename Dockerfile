FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Install system dependencies
RUN --mount=type=cache,target=/var/lib/apt/lists \
    apt update && \
    apt install -y --no-install-recommends \
    tesseract-ocr poppler-utils

# Install python dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project

COPY src /app

EXPOSE 8501
CMD ["uv","run", "streamlit", "run", "streamlit_app/home.py"]