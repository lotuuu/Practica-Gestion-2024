/*
31. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las 
siguientes columnas:
 Año.
 Codigo de Vendedor
 Detalle del Vendedor
 Cantidad de facturas que realizó en ese año
 Cantidad de clientes a los cuales les vendió en ese año.
 Cantidad de productos facturados con composición en ese año
 Cantidad de productos facturados sin composicion en ese año.
 Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya 
vendido mas productos diferentes de mayor a menor.
*/

SELECT
    YEAR (fact_fecha),
    empl_codigo,
    -- esta alternativa parece mas rapida que un count distinct de las pkey de factura
    (
        SELECT
            COUNT(*)
        FROM
            Factura
        WHERE
            fact_vendedor = empl_codigo
            AND YEAR(F.fact_fecha) = YEAR (fact_fecha)
    ) cantFacturas,
    -- idem
    (
        SELECT
            COUNT(DISTINCT fact_cliente)
        FROM
            Factura
        WHERE
            fact_vendedor = empl_codigo
            AND YEAR(F.fact_fecha) = YEAR (fact_fecha)
    ) cantClientes,
    (
        SELECT
            COUNT(DISTINCT item_producto)
        FROM
            Item_Factura
            JOIN Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
        WHERE
            fact_vendedor = empl_codigo
            AND YEAR(F.fact_fecha) = YEAR (fact_fecha)
            AND item_producto IN (
                SELECT
                    comp_producto
                FROM
                    Composicion
            )
    ) cantProdComp,
    (
        SELECT
            COUNT(DISTINCT item_producto)
        FROM
            Item_Factura
            JOIN Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
        WHERE
            fact_vendedor = empl_codigo
            AND YEAR(F.fact_fecha) = YEAR (fact_fecha)
            AND item_producto NOT IN (
                SELECT
                    comp_producto
                FROM
                    Composicion
            )
    ) cantProdSinComp,
    (
        SELECT
            SUM(item_cantidad * item_precio)
        FROM
            Item_Factura
            JOIN Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
        WHERE
            fact_vendedor = empl_codigo
            AND YEAR(F.fact_fecha) = YEAR (fact_fecha)
    ) montoTotal
FROM
    Factura F
    JOIN Empleado ON fact_vendedor = empl_codigo
    JOIN Item_Factura ON fact_numero + fact_sucursal + fact_tipo = item_numero + item_sucursal + item_tipo
    JOIN Producto ON item_producto = prod_codigo
GROUP BY
    YEAR (fact_fecha),
    empl_codigo
ORDER BY
    YEAR (fact_fecha),
    COUNT(DISTINCT prod_codigo) DESC;
