with source as (
    select
        cast(id as int64) as id
        , lower(trim(nome)) as nome
        , lower(trim(email)) as email
        , regexp_replace(trim(telefone), r'[^0-9]', '') as telefone
        , cast(data_registro as date) as data_registro
    
    from {{ source('ecomerce','clientes')}}
)

select * from source