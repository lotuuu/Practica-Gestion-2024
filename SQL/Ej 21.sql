/*
21. Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al 
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta 
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. Se 
considera que una factura es incorrecta cuando la diferencia entre el total de la factura 
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de 
los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar 
son:
 Año
 Clientes a los que se les facturo mal en ese año
 Facturas mal realizadas en ese año
 */
SELECT
    YEAR(fact_fecha),
    COUNT(DISTINCT fact_cliente),
    COUNT(*)
FROM
    Factura
WHERE
    (fact_total - fact_total_impuestos) > 1 +  (
        SELECT
            SUM(item_precio * item_cantidad)
        FROM
            Item_Factura
        WHERE item_numero + item_sucursal + item_tipo = fact_numero + fact_sucursal + fact_tipo
    )
GROUP BY
    YEAR(fact_fecha)
