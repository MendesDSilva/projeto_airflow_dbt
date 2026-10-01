with source as (

    select 
        cast(id as int64) as id
        , cast(pedido_id as int64) as pedido_id
        , cast(valor as numeric) as valor
        , lower(trim(metodo)) as metodo
        , lower(trim(status)) as status 
        , cast(data_pagamento as date) as data_pagamento
    
    from {{ source('ecomerce','pagamentos')}}
)

select * from source

