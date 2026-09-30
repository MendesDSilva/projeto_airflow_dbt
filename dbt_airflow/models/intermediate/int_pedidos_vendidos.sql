{{
    config(
        tags = ['vendas']
    )
}}

with avaliacoes as (
    select * from {{ ref('stg_avaliacoes') }}
)
, carrinho as (
    select * from {{ ref('stg_carrinho')}}
)
, categorias as (
    select * from {{ ref('stg_categorias')}}
)
, clientes as (
    select * from {{ ref('stg_clientes')}}
)
, intens_pedidos as (
    select * from {{ ref('stg_itens_pedidos')}}
)
, pagamentos as (
    select * from {{ ref('stg_pagamentos')}}
)
, pedidos as (
    select * from {{ ref('stg_pedidos')}}
)
, produtos as (
    select * from {{ ref('stg_produtos')}}
)