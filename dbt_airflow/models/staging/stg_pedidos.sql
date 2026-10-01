with source as (
    select
        cast(id as int64) as id
        , cast(cliente_id as int64) as cliente_id
        , cast(endereco_id as int64) as endereco_id
        , cast(data_pedido as date) as data_pedido
        , lower(trim(status)) as status  
    
    from {{ source('ecomerce','pedidos')}}
)

select * from source