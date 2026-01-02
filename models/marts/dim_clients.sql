WITH clients_enrichis AS (
    SELECT * FROM {{ ref('int_clients_contrats') }}
)

SELECT
    client_id,
    nom,
    prenom,
    email,
    adresse,
    date_naissance,
    {{ calcul_age('date_naissance') }} AS age,
    nb_contrats,
    prime_totale,
    CASE
        WHEN prime_totale > 3000 THEN 'Gold'
        WHEN prime_totale > 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS segment
FROM clients_enrichis