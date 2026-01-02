FROM apache/airflow:2.10.4

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow

# 1. On met à jour pip
RUN pip install --upgrade pip

# 2. On installe dbt-core et cosmos (Cela installe aussi dbt-common, dbt-adapters, etc.)
RUN pip install dbt-core==1.8.0 astronomer-cosmos

# 3. On installe la version BINAIRE de psycopg2
RUN pip install psycopg2-binary

# 4. LE FIX : On installe dbt-postgres SANS ses dépendances
# Comme on a déjà installé dbt-core (étape 2) et psycopg2-binary (étape 3),
# dbt-postgres va fonctionner sans savoir qu'on l'a "forcé".
RUN pip install --no-deps dbt-postgres==1.8.0