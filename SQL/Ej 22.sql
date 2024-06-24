/*
22. Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por 
trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1 
por cada trimestre).
Se deben mostrar 4 columnas:
 Detalle del rubro
 Numero de trimestre del año (1 a 4)
 Cantidad de facturas emitidas en el trimestre en las que se haya vendido al 
menos un producto del rubro
 Cantidad de productos diferentes del rubro vendidos en el trimestre 
El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada 
rubro primero el trimestre en el que mas facturas se emitieron.
No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas 
no superen las 100.
En ningun momento se tendran en cuenta los productos compuestos para esta 
estadistica.
 */
SELECT
    rubr_detalle,
    (
        CASE
            WHEN (
                MONTH (fact_fecha) = 1
                OR MONTH (fact_fecha) = 2
                OR MONTH (fact_fecha) = 3
            ) THEN 1
            WHEN (
                MONTH (fact_fecha) = 4
                OR MONTH (fact_fecha) = 5
                OR MONTH (fact_fecha) = 6
            ) THEN 2
            WHEN (
                MONTH (fact_fecha) = 7
                OR MONTH (fact_fecha) = 8
                OR MONTH (fact_fecha) = 9
            ) THEN 3
            WHEN (
                MONTH (fact_fecha) = 10
                OR MONTH (fact_fecha) = 11
                OR MONTH (fact_fecha) = 12
            ) THEN 4
        END
    ) trimestre,
    COUNT(
        DISTINCT (fact_numero + fact_sucursal + fact_tipo)
    ) cant_facturas,
    COUNT(DISTINCT (prod_codigo)) cant_productos
FROM
    Producto
    JOIN Rubro ON prod_rubro = rubr_id
    JOIN Item_Factura on item_producto = prod_codigo
    JOIN Factura on item_numero + item_sucursal + item_tipo = fact_numero + fact_sucursal + fact_tipo
GROUP BY
    rubr_detalle,
    (
        CASE
            WHEN (
                MONTH (fact_fecha) = 1
                OR MONTH (fact_fecha) = 2
                OR MONTH (fact_fecha) = 3
            ) THEN 1
            WHEN (
                MONTH (fact_fecha) = 4
                OR MONTH (fact_fecha) = 5
                OR MONTH (fact_fecha) = 6
            ) THEN 2
            WHEN (
                MONTH (fact_fecha) = 7
                OR MONTH (fact_fecha) = 8
                OR MONTH (fact_fecha) = 9
            ) THEN 3
            WHEN (
                MONTH (fact_fecha) = 10
                OR MONTH (fact_fecha) = 11
                OR MONTH (fact_fecha) = 12
            ) THEN 4
        END
    )
ORDER BY
    rubr_detalle,
    COUNT(
        DISTINCT (fact_numero + fact_sucursal + fact_tipo)
    ) DESC
