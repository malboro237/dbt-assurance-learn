WITH source AS (
    SELECT * FROM {{ source('silver', 'sinistres') }}
)

SELECT
    sinistre_id,
    contrat_id,
    client_id,
    type_sinistre,
    montant,
    date_declaration,
    statut
FROM source