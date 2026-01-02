{% macro calcul_age(date_naissance) %}
    DATE_PART('year', AGE(CURRENT_DATE, {{ date_naissance }}))
{% endmacro %}