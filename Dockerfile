FROM python:3.10-slim

WORKDIR /dbt

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

RUN pip install dbt-core dbt-postgres

COPY . .

ENTRYPOINT ["dbt"]