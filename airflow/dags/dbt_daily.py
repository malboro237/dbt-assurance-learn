from airflow import DAG
from airflow.operators.bash import BashOperator
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping
from datetime import datetime, timedelta

default_args = {
    'owner': 'data-team',
    'depends_on_past': False,
    'email_on_failure': False,
    'retries': 2,                              # ← Retry par modèle
    'retry_delay': timedelta(minutes=2),
}

# Configuration du profil dbt
profile_config = ProfileConfig(
    profile_name='assurance_learn',
    target_name='dev',
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id='postgres_dbt',                # ← Connexion Airflow
        profile_args={
            'schema': 'public',
        },
    ),
)

with DAG(
    dag_id='dbt_daily_cosmos',
    default_args=default_args,
    description='Pipeline dbt avec Cosmos (atomicité)',
    schedule_interval='0 6 * * *',
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['dbt', 'daily', 'cosmos'],
) as dag:

    # Étape 1 : Vérifier la fraîcheur
    dbt_source_freshness = BashOperator(
        task_id='dbt_source_freshness',
        bash_command='cd /opt/airflow/dbt && dbt source freshness --profiles-dir /opt/airflow/dbt',
    )

    # Étape 2 : Seeds
    dbt_seed = BashOperator(
        task_id='dbt_seed',
        bash_command='cd /opt/airflow/dbt && dbt seed --profiles-dir /opt/airflow/dbt',
    )

    # Étape 3 : Modèles avec Cosmos (1 tâche par modèle)
    dbt_models = DbtTaskGroup(
        group_id='dbt_models',
        project_config=ProjectConfig(
            dbt_project_path='/opt/airflow/dbt',
        ),
        profile_config=profile_config,
        execution_config=ExecutionConfig(
            dbt_executable_path='/usr/local/bin/dbt',
        ),
        default_args={'retries': 2},
    )

    # Étape 4 : Tests
    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command='cd /opt/airflow/dbt && dbt test --profiles-dir /opt/airflow/dbt',
    )

    # Ordre
    dbt_source_freshness >> dbt_seed >> dbt_models >> dbt_test
