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

# Streamlit Configurations
ENV STREAMLIT_CLIENT_TOOLBAR_MODE="viewer"
ENV STREAMLIT_SERVER_FILE_WATCHER_TYPE="none"
ENV STREAMLIT_SERVER_HEADLESS="true"
ENV STREAMLIT_BROWSER_GATHER_USAGE_STATS="false"

# Create a non-root user and group
RUN groupadd -r appuser && useradd -r -g appuser appuser && \
    mkdir /home/appuser

COPY src /app

# Set proper permissions
RUN chown -R appuser:appuser /app && \
    chown -R appuser:appuser /home/appuser

# Switch to non-root user
USER appuser

EXPOSE 8501
CMD ["uv","run", "streamlit", "run", "streamlit_app/home.py"]
