ARG PYTHON_FULL=3.8-bookworm
ARG PYTHON_SLIM=3.8-slim-bookworm

FROM python:${PYTHON_FULL} AS build

WORKDIR /app

RUN python -m venv /opt/venv

COPY requirements.txt .

ENV PATH="/opt/venv/bin:${PATH}"

RUN pip install --no-cache-dir --upgrade pip  && \
    pip install --no-cache-dir -r requirements.txt

FROM python:${PYTHON_SLIM} AS run

WORKDIR /app

COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:${PATH}"

ENV PYTHONUNBUFFERED=1

COPY . .

RUN python manage.py migrate

EXPOSE 8080

CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]
