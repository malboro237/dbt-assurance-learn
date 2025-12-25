WITH source AS (
    SELECT * FROM {{ source('silver', 'contrats') }}
)

SELECT
    contrat_id,
    client_id,
    produit,
    prime_annuelle,
    date_debut,
    date_fin,
    statut
FROM source