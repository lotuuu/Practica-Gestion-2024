/*
27. Escriba una consulta sql que retorne una estadística basada en la facturacion por año y 
envase devolviendo las siguientes columnas:
 Año
 Codigo de envase
 Detalle del envase
 Cantidad de productos que tienen ese envase
 Cantidad de productos facturados de ese envase
 Producto mas vendido de ese envase
 Monto total de venta de ese envase en ese año
 Porcentaje de la venta de ese envase respecto al total vendido de ese año
Los datos deberan ser ordenados por año y dentro del año por el envase con más 
facturación de mayor a menor
 */
SELECT
    YEAR (fact_fecha),
    prod_envase,
    COUNT(DISTINCT prod_codigo) cantProductosConEnvase,
    (
        SELECT
            SUM(item_cantidad)
        FROM
            Factura
            JOIN Item_Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
            JOIN Producto ON prod_codigo = item_producto
        WHERE
            prod_envase = p.prod_envase
            AND YEAR (f.fact_fecha) = YEAR (fact_fecha)
    ) cantProductosConEnvaseFacturados,
    (
        SELECT
            TOP 1 prod_codigo
        FROM
            Factura
            JOIN Item_Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
            JOIN Producto ON prod_codigo = item_producto
        WHERE
            prod_envase = p.prod_envase
            AND YEAR (f.fact_fecha) = YEAR (fact_fecha)
        GROUP BY
            prod_codigo
        ORDER BY
            SUM(item_cantidad) DESC
    ) prodMasVendido,
    (
        SELECT
            TOP 1 SUM(item_cantidad * item_precio)
        FROM
            Factura
            JOIN Item_Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
            JOIN Producto ON prod_codigo = item_producto
        WHERE
            prod_envase = p.prod_envase
            AND YEAR (f.fact_fecha) = YEAR (fact_fecha)
        GROUP BY
            prod_codigo
        ORDER BY
            SUM(item_cantidad) DESC
    ) montoProdMasVendido,
    SUM(item_cantidad * item_precio) / (
        SELECT
            SUM(item_cantidad * item_precio)
        FROM
            Factura
            JOIN Item_Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
            JOIN Producto ON prod_codigo = item_producto
        WHERE
            YEAR (f.fact_fecha) = YEAR (fact_fecha)
    ) pctVentas
FROM
    Factura f
    JOIN Item_Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
    JOIN Producto p ON prod_codigo = item_producto
GROUP BY
    YEAR (fact_fecha),
    prod_envase
ORDER BY
    YEAR (fact_fecha),
    SUM(item_cantidad * item_precio) DESC;
