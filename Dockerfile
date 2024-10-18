ARG PYTHON_VERSION=python:3.11.6-slim-bookworm

FROM ${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY ./pyproject.toml /pyproject.toml
COPY ./poetry.lock /poetry.lock
RUN pip install --no-cache-dir --upgrade poetry
RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction --no-ansi
