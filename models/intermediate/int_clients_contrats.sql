WITH clients AS (
    SELECT * FROM {{ ref('stg_clients') }}
),

contrats AS (
    SELECT * FROM {{ ref('stg_contrats') }}
)

SELECT
    c.client_id,
    c.nom,
    c.prenom,
    c.email,
    c.adresse,
    c.date_naissance,
    COUNT(co.contrat_id) AS nb_contrats,
    SUM(co.prime_annuelle) AS prime_totale
FROM clients c
LEFT JOIN contrats co ON c.client_id = co.client_id
GROUP BY 
    c.client_id,
    c.nom,
    c.prenom,
    c.email,
    c.adresse,
    c.date_naissance