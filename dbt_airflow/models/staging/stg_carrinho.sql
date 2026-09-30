with source as (
    select 
        cast(cliente_id as int64) as cliente_id
        , cast(produto_id as int64) as produto_id
        , cast(quantidade as int64) as quantidade
        , cast(data_adicionado as date) as data_adicionado

    from {{ source('ecomerce','carrinho')}}
)

select * from source