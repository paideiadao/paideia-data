FROM python:3-slim

COPY ./alembic /app
COPY ./alembic.ini /app
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update \
  && apt-get -y install netcat gcc postgresql nano \
  && apt-get clean

# install python dependencies
RUN pip install --upgrade pip
RUN pip install psycopg2-binary alembic

CMD tail /dev/null -f
