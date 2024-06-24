/*
Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que

retorne aquellos clientes
cuyas ventas son inferiores a 1/3 DEL promedio de ventas DEL producto que más se vendió en el 2012.
Además mostrar
1. Nombre DEL Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.
Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
productos NO compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.
*/
SELECT
    c.clie_codigo,
    c.clie_razon_social,
    SUM(item_cantidad) AS ventas_totales,
    (
        SELECT
            TOP 1 item_producto
        FROM
            Item_Factura
            JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
        WHERE
            YEAR (fact_fecha) = 2012 AND fact_cliente = c.clie_codigo
        GROUP BY
            item_producto
        ORDER BY
            SUM(item_cantidad) DESC
    ) AS prod_mas_vendido
FROM
    Cliente c
    JOIN Factura f ON c.clie_codigo = f.fact_cliente
    JOIN Item_Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
WHERE
    YEAR (fact_fecha) = 2012
    AND c.clie_codigo IN (
        SELECT
            fact_cliente
        FROM
            Factura
        GROUP BY
            fact_cliente
        HAVING
            COUNT(fact_cliente) > (
                SELECT
                    TOP 1 AVG(item_cantidad) cantTotal
                FROM
                    Item_Factura
                    JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
                WHERE
                    YEAR (fact_fecha) = 2012
                GROUP BY
                    item_producto
                ORDER BY
                    SUM(item_cantidad) DESC
            ) / 3
    )
GROUP BY
    c.clie_codigo,
    c.clie_razon_social,
    c.clie_domicilio
ORDER BY clie_domicilio ASC
