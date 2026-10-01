{{
    config(
        tags = ['vendas']
    )
}}

with categorias as (
    select * from {{ ref('stg_categorias')}}
)
, intens_pedidos as (
    select * from {{ ref('stg_itens_pedidos')}}
)
, produtos as (
    select * from {{ ref('stg_produtos')}}
)
, int_itens_vendidos as (
    SELECT
        ip.pedido_id
        ,ip.produto_id
        ,p.nome as nome_produto
        ,c.nome as nome_categoria
        ,ip.quantidade
        ,ip.preco_unitario
        ,ip.subtotal            
    FROM intens_pedidos ip
    LEFT JOIN produtos p ON ip.produto_id = p.id
    LEFT JOIN categorias c ON p.categoria_id = c.id
)

SELECT * FROM int_itens_vendidos