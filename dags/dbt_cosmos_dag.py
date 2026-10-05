from datetime import datetime

from cosmos import (
    DbtDag,
    ProjectConfig,
    ProfileConfig,
    ExecutionConfig,
)

from cosmos.constants import ExecutionMode
from cosmos.profiles import GoogleCloudServiceAccountDictProfileMapping

DBT_PROJECT_PATH = "/usr/local/airflow/dbt_airflow"
DBT_EXECUTABLE_PATH = "/usr/local/airflow/dbt_venv/bin/dbt"


profile_config = ProfileConfig(
    profile_name="dbt_airflow",
    target_name="dev",
    profile_mapping=GoogleCloudServiceAccountDictProfileMapping(
        conn_id="gcp_conn",
        profile_args={
            "project": "dbt-project-508815",
            "dataset": "dbt_airflow_dw",
        },
    ),
)

execution_config = ExecutionConfig(
    execution_mode=ExecutionMode.LOCAL,
    dbt_executable_path=DBT_EXECUTABLE_PATH,
)

dbt_dag = DbtDag(
    dag_id="dbt_cosmos_pipeline",

    project_config=ProjectConfig(
        dbt_project_path=DBT_PROJECT_PATH,
    ),

    profile_config=profile_config,
    execution_config=execution_config,

    schedule=None,
    start_date=datetime(2026, 1, 1),
    catchup=False,
)