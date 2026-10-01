with source as (

    select
        cast(pedido_id as int64) as pedido_id
        , cast(produto_id as int64) as produto_id
        , cast(quantidade as int64) as quantidade
        , cast(preco_unitario as numeric) as preco_unitario
        , cast(subtotal as numeric) as subtotal
    
    from {{ source('ecomerce','itens_pedidos') }}

)

select * from source