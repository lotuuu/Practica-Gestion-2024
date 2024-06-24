/*
Realizar una consulta SQL que para cada año muestre :
 Año
 El producto con composición más vendido para ese año.
 Cantidad de productos que componen directamente al producto más vendido
 La cantidad de facturas en las cuales aparece ese producto.
 El código de cliente que más compro ese producto.
 El porcentaje que representa la venta de ese producto respecto al total de venta 
DEL año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente.
 */
SELECT
    YEAR (fact_fecha),
    (
        SELECT
            TOP 1 item_producto
        FROM
            Item_Factura
            JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
            JOIN Composicion ON item_producto = comp_producto
        WHERE
            YEAR (fact_fecha) = YEAR (f.fact_fecha)
        GROUP BY
            item_producto
        ORDER BY
            SUM(item_cantidad) DESC
    ) ProdMasVendido,
    (
        SELECT
            TOP 1 SUM(comp_cantidad)
        FROM
            Item_Factura
            JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
            JOIN Composicion ON item_producto = comp_producto
        WHERE
            YEAR (fact_fecha) = YEAR (f.fact_fecha)
        GROUP BY
            item_producto
        ORDER BY
            SUM(item_cantidad) DESC
    ) CantProductosComp,
    (
        SELECT
            TOP 1 COUNT(DISTINCT fact_numero + fact_tipo + fact_sucursal)
        FROM
            Item_Factura
            JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
            JOIN Composicion ON item_producto = comp_producto
        WHERE
            YEAR (fact_fecha) = YEAR (f.fact_fecha)
        GROUP BY
            item_producto
        ORDER BY
            SUM(item_cantidad) DESC
    ) CantFacturas,
    (
        SELECT TOP 1 fact_cliente FROM Item_Factura
            JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
            WHERE item_producto IN (SELECT
            TOP 1 item_producto
        FROM
            Item_Factura
            JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
            JOIN Composicion ON item_producto = comp_producto
        WHERE
            YEAR (fact_fecha) = YEAR (f.fact_fecha)
        GROUP BY
            item_producto
        ORDER BY
            SUM(item_cantidad) DESC)
        GROUP BY fact_cliente
       -- ORDER BY 
    ) ClieMasComprador,
    --El porcentaje que representa la venta de ese producto respecto al total de venta del año.
    (
        (
            SELECT
                TOP 1 SUM(item_cantidad * item_producto)
            FROM
                Item_Factura
                JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
                JOIN Composicion ON item_producto = comp_producto
            WHERE
                YEAR (fact_fecha) = YEAR (f.fact_fecha)
            GROUP BY
                item_producto
            ORDER BY
                SUM(item_cantidad) DESC
        ) / (
            SELECT
                SUM(item_cantidad * item_precio)
            FROM
                Item_Factura
                JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
            WHERE
                YEAR (fact_fecha) = YEAR (f.fact_fecha)
            GROUP BY
                YEAR(fact_fecha)
        )
    ) PctVentas
FROM
    Composicion
    JOIN Producto ON prod_codigo = comp_producto
    JOIN Item_Factura ON item_producto = prod_codigo
    JOIN Factura f ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
GROUP BY
    YEAR (fact_fecha)
ORDER BY
    SUM(item_cantidad) DESC
