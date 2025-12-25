WITH source AS (
    SELECT * FROM {{ source('silver', 'clients') }}
)

SELECT
    client_id,
    TRIM(nom) AS nom,
    TRIM(prenom) AS prenom,
    LOWER(email) AS email,
    adresse,
    date_naissance,
    date_creation
FROM source