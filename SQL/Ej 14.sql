/*
 Escriba una consulta que retorne una estadística de ventas por cliente.
 Los campos que debe retornar son:
    Código del cliente
    Cantidad de veces que compro en el último año
    Promedio por compra en el último año
    Cantidad de productos diferentes que compro en el último año
    Monto de la mayor compra que realizo en el último año
 Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en el último año.
 No se deberán visualizar NULLs en ninguna columna
*/

SELECT
    clie_codigo,
    clie_razon_social,
    COUNT(DISTINCT(fact_numero + fact_tipo + fact_sucursal)) AS cantidad_compras,
    COUNT(DISTINCT (item_producto)) AS cantidad_productos_distintos,
    AVG(fact_total) AS promedio,
    MAX(fact_total) AS mayor_compra
FROM
    Cliente
    JOIN Factura ON fact_cliente = clie_codigo
    JOIN Item_Factura on item_numero + item_sucursal + item_tipo = fact_numero + fact_sucursal + fact_tipo
WHERE
    YEAR (fact_fecha) = 2012
GROUP BY
    clie_codigo,
    clie_razon_social
ORDER BY
    clie_codigo
