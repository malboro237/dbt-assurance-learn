from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'data-team',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='dbt_weekly_pipeline',
    default_args=default_args,
    description='Pipeline dbt hebdomadaire (snapshots)',
    schedule_interval='0 7 * * 0',  # Tous les dimanches à 7h
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=['dbt', 'weekly'],
) as dag:

    # Exécuter les snapshots
    dbt_snapshot = BashOperator(
        task_id='dbt_snapshot',
        bash_command='cd /opt/airflow/dbt && dbt snapshot --select tag:weekly --profiles-dir /opt/airflow/dbt',
    )

    # Tester les snapshots
    dbt_test_snapshots = BashOperator(
        task_id='dbt_test_snapshots',
        bash_command='cd /opt/airflow/dbt && dbt test --select tag:weekly --profiles-dir /opt/airflow/dbt',
    )

    dbt_snapshot >> dbt_test_snapshots