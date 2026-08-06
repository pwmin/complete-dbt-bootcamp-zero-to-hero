-- Similar to declaring a Python function with two parameters.
{% test positive_values(model, column_name) %}

SELECT
    *
FROM
    {{ model }}
WHERE
    {{ column_name }} <= 0

{% endtest %}
