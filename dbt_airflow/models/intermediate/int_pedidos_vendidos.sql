{{
    config(
        tags = ['vendas']
    )
}}

with clientes as (
    select * from {{ ref('stg_clientes')}}
)
, pagamentos as (
    select * from {{ ref('stg_pagamentos')}}
)
, pedidos as (
    select * from {{ ref('stg_pedidos')}}
)
, pedidos_vendidos as (

    SELECT
        p.data_pedido
        ,p.id as id_pedido
        ,p.cliente_id
        ,c.nome as nome_cliente
        ,c.email as email_cliente
        ,p.status as pedido_status
        ,pg.metodo as metodo_pagamento
        ,pg.valor as valor_pagamento 

    FROM pedidos p
    LEFT JOIN clientes c on p.cliente_id = c.id
    LEFT JOIN pagamentos pg on p.id = pg.pedido_id  
)

SELECT * FROM PEDIDOS_VENDIDOS
