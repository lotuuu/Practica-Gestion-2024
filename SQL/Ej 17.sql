/*
Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo 
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el 
periodo
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por periodo y código de producto
            */
SELECT
    (
        CAST(YEAR (fact_fecha) AS varchar) + CAST(MONTH (fact_fecha) AS varchar)
    ) AS PERIODO,
    prod_codigo AS PROD,
    prod_detalle AS DETALLE,
    SUM(item_cantidad) AS CANTIDAD_VENDIDA,
    ISNULL (
        (
            SELECT
                SUM(item_cantidad)
            FROM
                Item_Factura itf2
                JOIN Factura f2 ON itf2.item_numero + itf2.item_tipo + itf2.item_sucursal = f2.fact_numero + f2.fact_tipo + f2.fact_sucursal
            WHERE
                YEAR (f2.fact_fecha) = YEAR (f1.fact_fecha) - 1
                AND MONTH (f2.fact_fecha) = MONTH (f1.fact_fecha)
        ),
        0
    ) AS VENTAS_ANO_ANT
FROM
    Producto
    JOIN Item_Factura ON item_producto = prod_codigo
    JOIN Factura f1 ON item_numero + item_tipo + item_sucursal = f1.fact_numero + f1.fact_tipo + f1.fact_sucursal
GROUP BY
    MONTH (fact_fecha),
    YEAR (fact_fecha),
    prod_codigo,
    prod_detalle
ORDER BY
    1,
    2


select CONCAT(YEAR(F1.fact_fecha), RIGHT('0' + RTRIM(MONTH(F1.fact_fecha)), 2))  Periodo,
       prod_codigo ,
       prod_detalle detalle,
       isnull(sum(item_cantidad),0) CANTIDAD_VENDIDA,
       isnull((select sum(item_cantidad)
        from Item_Factura
        join Factura f2 on item_numero + item_tipo + item_sucursal = f2.fact_numero + f2.fact_tipo + f2.fact_sucursal 
        where year(f2.fact_fecha) = year(f1.fact_fecha) - 1
        and month(f1.fact_fecha) = month(f2.fact_fecha)),0) ventas_anio_ant,
        count(*) cant_facturas
from Item_Factura i1
join Factura f1 on i1.item_numero + i1.item_tipo + i1.item_sucursal = f1.fact_numero + f1.fact_tipo + f1.fact_sucursal 
join Producto on item_producto = prod_codigo
group by  prod_codigo, prod_detalle, YEAR(F1.fact_fecha), MONTH(F1.fact_fecha)
ORDER BY 1, 2
