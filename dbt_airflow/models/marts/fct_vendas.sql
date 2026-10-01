{{
    config(
        materialized = 'table'
    )
}}

with pedidos as (

    select *
    from {{ ref('int_pedidos_vendidos') }}

),

itens as (

    select *
    from {{ ref('int_itens_vendidos') }}

),

vendas as (

    select
        p.id_pedido,
        p.data_pedido,
        p.cliente_id,
        p.nome_cliente,
        p.email_cliente,
        p.pedido_status,
        p.metodo_pagamento,
        p.valor_pagamento,
        i.produto_id,
        i.nome_produto,
        i.nome_categoria,
        i.quantidade,
        i.preco_unitario,
        {{ generate_surrogate_key(
            ['p.id_pedido', 'i.produto_id']
        ) }} as venda_id

    from pedidos p

    inner join itens i
        on p.id_pedido = i.pedido_id

    {% if is_incremental() %}

    where p.data_pedido >= (
        select coalesce(
            max(data_pedido),
            date('1900-01-01')
        )
        from {{ this }}
    )

    {% endif %}

)

select *
from vendas