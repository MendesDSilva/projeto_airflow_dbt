with source as (
    select 
        cast(cliente_id as int64) as cliente_id
        , cast (produto_id as int64) as produto_id
        , cast(nota as int64) as nota
        , lower(trim(comentario)) as comentario
        , cast(data_avaliacao as date) as data_avaliacao
       
     from {{source('ecomerce','avaliacoes')}}
)

select * from source