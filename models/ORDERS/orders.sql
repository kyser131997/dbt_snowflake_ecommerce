{{

    config(
        materialized = 'table'
    )

}}

WITH source AS (

    SELECT
        COMMANDE_ID::INT              AS order_id,
        CLIENT_ID::INT                AS customer_id,
        DATE_COMMANDE::DATE           AS order_date,
        LOWER(STATUT)                 AS status,
        MONTANT_TOTAL::NUMERIC(10,2)  AS total_amount,
        MODE_PAIEMENT::STRING         AS payment_method,
        VILLE_LIVRAISON::STRING       AS delivery_city

    FROM {{ source('snowflake_source', 'commandes') }}

),

cleaned AS (

    SELECT
        order_id,
        customer_id,
        order_date,
        EXTRACT(YEAR FROM order_date) AS order_year,
        status,
        total_amount,
        payment_method,
        delivery_city
    FROM source
    WHERE status != 'annulee'

)

SELECT * FROM cleaned
