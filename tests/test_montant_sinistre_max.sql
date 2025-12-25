SELECT * FROM {{ ref('fct_sinistres') }}
WHERE montant > 50000
