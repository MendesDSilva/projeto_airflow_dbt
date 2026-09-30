with source as (
    select 
        cast(id as int64) as id
        , lower(trim(nome)) as nome 
        , lower(trim(descricao)) as descricao
        , cast(categoria_id as int64) as categoria_id
        , cast(preco as int64) as preco
        , lower(trim(marca)) as marca
        , cast(estoque as int64) as estoque
        , cast(data_cadastro as date) as data_cadastro
    
    from {{source('ecomerce','produtos')}}
)

select * from source