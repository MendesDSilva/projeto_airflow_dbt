from airflow.models import DagBag
from airflow.utils.db import initdb


DAG_ID = "dbt_cosmos_pipeline"


def create_dag_bag():
    """
    Inicializa o metadatabase utilizado pelo ambiente de testes
    e carrega as DAGs.
    """
    initdb()
    return DagBag(include_examples=False)


def test_no_import_errors():
    dag_bag = create_dag_bag()

    assert not dag_bag.import_errors, (
        f"Erros ao importar DAGs: {dag_bag.import_errors}"
    )


def test_dbt_cosmos_dag_exists():
    dag_bag = create_dag_bag()

    assert DAG_ID in dag_bag.dags, (
        f"DAG {DAG_ID} não encontrada"
    )


def test_dbt_cosmos_dag_has_tasks():
    dag_bag = create_dag_bag()

    dag = dag_bag.dags.get(DAG_ID)

    assert dag is not None
    assert len(dag.tasks) > 0, (
        f"DAG {DAG_ID} não possui tasks"
    )