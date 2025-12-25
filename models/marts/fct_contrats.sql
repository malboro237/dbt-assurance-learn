WITH contrats AS (
    SELECT * FROM {{ ref('stg_contrats') }}
),

clients AS (
    SELECT * FROM {{ ref('stg_clients') }}
)

SELECT
    co.contrat_id,
    co.client_id,
    c.nom,
    c.prenom,
    co.produit,
    co.prime_annuelle,
    co.date_debut,
    co.date_fin,
    co.statut
FROM contrats co
LEFT JOIN clients c ON co.client_id = c.client_id