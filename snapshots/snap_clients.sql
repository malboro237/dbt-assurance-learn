{% snapshot snap_clients %}
{{
    config(
        target_schema='snapshots',
        unique_key='client_id',
        strategy='check',
        check_cols= ['email', 'adresse']
    )
}}

SELECT * FROM {{ source('silver', 'clients') }}
{% endsnapshot %}