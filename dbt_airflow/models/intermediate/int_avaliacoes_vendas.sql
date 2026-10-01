{{
    config(
        tags = ['vendas']
    )
}}

with clientes as (
    select * from {{ ref('stg_clientes')}}
)
, produtos as (
    select * from {{ ref('stg_produtos')}}
)
, avaliacoes as (
    select * from {{ ref('stg_avaliacoes')}}
)
, int_avaliacoes_vendas as (
    SELECT
        a.data_avaliacao
        ,a.id as id_avaliacao
        ,a.cliente_id
        ,c.nome as nome_cliente
        ,a.produto_id
        ,p.nome as nome_produto
        ,a.nota
        ,a.comentario
        
    FROM avaliacoes a
    LEFT JOIN clientes c ON a.cliente_id = c.id
    LEFT JOIN produtos p ON a.produto_id = p.id
)

SELECT * FROM int_avaliacoes_vendas