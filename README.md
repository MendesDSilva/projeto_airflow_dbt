# Airflow + dbt + BigQuery Data Pipeline

Projeto de Engenharia de Dados desenvolvido com **dbt, Google BigQuery, Apache Airflow e Astronomer Cosmos**, utilizando **Docker** para conteinerização e **GitHub Actions** para CI/CD.

O projeto implementa uma arquitetura de transformação de dados em camadas, com testes automatizados, orquestração do pipeline e publicação automática da imagem Docker no Docker Hub.

---

## 🏗️ Arquitetura

O **BigQuery** é utilizado como Data Warehouse e o **dbt** é responsável pelas transformações dos dados.

Os modelos são organizados em três camadas:

```text
BigQuery
   │
   ▼
Source
   │
   ▼
dbt
   │
   ├── Staging
   │      ↓
   ├── Intermediate
   │      ↓
   └── Marts
          │
          ▼
      fct_vendas
```

A execução do projeto dbt é orquestrada pelo **Apache Airflow**, utilizando o **Astronomer Cosmos** para transformar o grafo de dependências do dbt em tasks do Airflow.

```text
Apache Airflow
      │
      ▼
Astronomer Cosmos
      │
      ▼
dbt DAG
      │
      ▼
BigQuery
```

---

## 🛠️ Tecnologias

- Apache Airflow
- Astronomer Cosmos
- dbt Core
- Google BigQuery
- Python
- SQL
- Docker
- Astro CLI
- Git
- GitHub
- GitHub Actions
- Docker Hub

---

## 📂 Estrutura do projeto

```text
projeto_airflow_dbt/
│
├── .github/
│   └── workflows/
│       ├── dbt_ci.yml
│       └── dbt_cd.yml
│
├── .astro/
│   └── config.yaml
│
├── dags/
│   └── dbt_cosmos_dag.py
│
├── dbt_airflow/
│   ├── macros/
│   ├── models/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── marts/
│   ├── dbt_project.yml
│   └── profiles.yml
│
├── tests/
│   └── dags/
│
├── Dockerfile
├── requirements.txt
├── packages.txt
├── airflow_settings.yaml
└── README.md
```

---

## 🔄 Modelagem dbt

O projeto utiliza uma arquitetura de transformação dividida em três camadas.

### Staging

Responsável pela padronização inicial dos dados provenientes das tabelas source.

Os modelos de staging são materializados como:

```yaml
view
```

Nessa camada são realizadas operações como:

- padronização de strings;
- conversão de tipos;
- normalização de campos;
- preparação dos dados para as próximas transformações.

### Intermediate

Responsável pelas transformações intermediárias e regras de negócio necessárias para construção dos marts.

Os modelos são materializados como:

```yaml
ephemeral
```

Dessa forma, não são criadas tabelas intermediárias físicas no BigQuery. O SQL é incorporado aos modelos dependentes durante a compilação do dbt.

### Marts

Camada responsável pelos modelos analíticos finais.

O principal modelo desenvolvido é:

```text
fct_vendas
```

A granularidade da tabela representa:

> um produto dentro de um pedido.

Para identificação única dos registros é utilizada uma **surrogate key**, construída a partir de:

```text
id_pedido + produto_id
```

---

## 🧪 Testes de dados

O projeto utiliza testes do dbt para validar a qualidade dos dados.

Entre as validações utilizadas estão:

```text
not_null
unique
relationships
accepted_values
```

Também foram desenvolvidos testes customizados para validação de dados, incluindo:

```text
valid_email
valid_phone
```

Os testes são executados tanto durante o desenvolvimento quanto automaticamente pelo pipeline de CI.

---

## 🌌 Orquestração com Airflow + Cosmos

O **Apache Airflow** é responsável pela orquestração do pipeline.

O **Astronomer Cosmos** interpreta o projeto dbt e converte seus modelos e dependências em tasks do Airflow.

A DAG principal é:

```text
dbt_cosmos_pipeline
```

O fluxo permite visualizar no Airflow as dependências existentes entre os modelos dbt.

Exemplo conceitual:

```text
staging
   │
   ▼
intermediate
   │
   ▼
marts
   │
   ▼
fct_vendas
```

O dbt é executado em um ambiente Python isolado dentro da imagem Docker.

---

## 🚀 CI/CD

O projeto utiliza **GitHub Actions** para implementar Continuous Integration e Continuous Delivery.

O fluxo de desenvolvimento segue:

```text
feature/*
    │
    ▼
Pull Request
    │
    ▼
develop
    │
    ▼
CI
├── dbt-ci
└── airflow-ci
    │
    ▼
develop
    │
    ▼
Pull Request
    │
    ▼
main
    │
    ▼
CD
```

### Continuous Integration

Nos Pull Requests destinados à branch `develop`, o GitHub Actions executa dois processos.

#### dbt-ci

Realiza:

```text
dbt debug
dbt compile
dbt test
```

Isso valida:

- configuração do projeto;
- conexão com BigQuery;
- compilação dos modelos;
- testes de qualidade dos dados.

#### airflow-ci

Executa testes das DAGs utilizando:

```bash
astro dev pytest
```

Isso permite detectar problemas de importação ou configuração das DAGs antes do merge.

---

## 📦 Continuous Delivery

Após um merge na branch `main`, o workflow de CD é executado automaticamente.

O pipeline realiza:

```text
main
 │
 ▼
GitHub Actions
 │
 ├── Production Artifact
 │
 └── Docker Build
          │
          ▼
      Docker Hub
```

O projeto gera um artifact contendo os arquivos necessários para execução da aplicação.

Além disso, uma imagem Docker é construída e publicada automaticamente no Docker Hub.

As imagens são versionadas utilizando:

```text
latest
<git-commit-sha>
```

Exemplo:

```text
mendesdsilva/airflow-dbt:latest

mendesdsilva/airflow-dbt:<commit-sha>
```

A utilização do commit SHA permite rastrear exatamente qual versão do código originou determinada imagem.

---

## 🐳 Docker

O ambiente utiliza uma imagem baseada no **Astronomer Runtime**.

Durante o build é criado um ambiente Python isolado para execução do dbt:

```text
/usr/local/airflow/dbt_venv
```

Nesse ambiente é instalado:

```text
dbt-bigquery
```

Essa separação permite que Airflow/Cosmos e dbt utilizem suas dependências de forma controlada dentro do container.

---

## 🔐 Gerenciamento de credenciais

Credenciais não são armazenadas diretamente no código-fonte.

O GitHub Actions utiliza **GitHub Secrets** para informações sensíveis necessárias durante CI/CD.

Entre elas:

```text
GCP_SERVICE_ACCOUNT_KEY
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
```

Arquivos locais contendo credenciais e variáveis de ambiente são excluídos do versionamento através do `.gitignore`.

---

## 📊 Pipeline CI/CD

```text
                         GitHub
                            │
                      Pull Request
                            │
                            ▼
                     GitHub Actions
                            │
                           CI
                    ┌───────┴───────┐
                    │               │
                 dbt-ci         airflow-ci
                    │               │
                    └───────┬───────┘
                            │
                         develop
                            │
                      Pull Request
                            │
                            ▼
                           main
                            │
                           CD
                    ┌───────┴────────┐
                    │                │
                 Artifact       Docker Build
                                     │
                                     ▼
                                 Docker Hub
                            ┌────────┴────────┐
                            │                 │
                         latest         commit SHA
```

---

## 💡 Decisões de arquitetura

Algumas decisões adotadas no projeto:

- **Staging como view:** evita persistência desnecessária dos dados de preparação.
- **Intermediate como ephemeral:** evita criação de tabelas intermediárias físicas no BigQuery.
- **Marts como modelos físicos:** disponibiliza os dados analíticos finais para consumo.
- **Surrogate key:** garante identificação única no nível de granularidade da `fct_vendas`.
- **Airflow + Cosmos:** permite que o grafo do dbt seja representado e orquestrado diretamente pelo Airflow.
- **GitHub Actions:** automatiza validações antes dos merges e o processo de entrega.
- **Docker:** cria um ambiente reproduzível para execução da aplicação.
- **Docker Hub:** funciona como registry das imagens geradas pelo pipeline de CD.
- **Commit SHA nas imagens:** garante rastreabilidade entre código-fonte e imagem Docker.

---

## 📌 Status do projeto

Atualmente o projeto possui:

```text
dbt + BigQuery                 ✅
Modelagem em camadas           ✅
Testes de dados                ✅
Airflow + Cosmos               ✅
Docker                         ✅
CI com GitHub Actions          ✅
Continuous Delivery            ✅
Publicação no Docker Hub       ✅
Versionamento por commit SHA   ✅
```

O projeto implementa **Continuous Delivery**. O deploy automático da imagem em uma infraestrutura remota de produção não faz parte do escopo atual.