with source as (
    select 
        cast(id as int64) as id
        , lower(trim(nome)) as nome
    
    from {{source('ecomerce','categorias')}}
)

select * from source