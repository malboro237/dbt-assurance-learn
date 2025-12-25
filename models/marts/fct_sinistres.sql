WITH sinistres AS (
    SELECT * FROM {{ ref('stg_sinistres') }}
),

contrats AS (
    SELECT * FROM {{ ref('stg_contrats') }}
),

clients AS (
    SELECT * FROM {{ ref('stg_clients') }}
),

types AS (
    SELECT * FROM {{ ref('types_sinistres') }}
)
SELECT
    {{ dbt_utils.generate_surrogate_key(['s.sinistre_id', 's.contrat_id']) }} AS unique_key,
    s.sinistre_id,
    s.contrat_id,
    s.client_id,
    c.nom,
    c.prenom,
    co.produit,
    s.type_sinistre,
    t.gravite,
    t.delai_traitement_jours,
    s.montant,
    s.date_declaration,
    s.statut AS statut_sinistre,
    co.statut AS statut_contrat
FROM sinistres s
LEFT JOIN contrats co ON s.contrat_id = co.contrat_id
LEFT JOIN clients c ON s.client_id = c.client_id
LEFT JOIN types t ON s.type_sinistre = t.type_sinistre

