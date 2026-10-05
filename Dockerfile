FROM astrocrpublic.azurecr.io/runtime:3.3-8

RUN python -m venv /usr/local/airflow/dbt_venv && \
    /usr/local/airflow/dbt_venv/bin/pip install --no-cache-dir dbt-bigquery==1.12.1

COPY --chown=astro:0 dbt_airflow /usr/local/airflow/dbt_airflow