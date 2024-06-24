/*
Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos 
(en la misma factura) más de 500 veces.
El resultado debe mostrar el código y descripción de cada uno de los productos y la cantidad de veces que fueron vendidos juntos.
El resultado debe estar ordenado por la cantidad de veces que se vendieron juntos dichos productos.
Los distintos pares no deben retornarse más de una vez.
Ejemplo de lo que retornaría la consulta:
PROD1    DETALLE1           PROD2    DETALLE2               VECES
1731     MARLBORO KS        1718     PHILIPS MORRIS KS      507
1718     PHILIPS MORRIS KS  1705     PHILIPS MORRIS BOX 10  562
*/
SELECT
    p1.prod_codigo,
    p1.prod_detalle,
    p2.prod_codigo,
    p2.prod_detalle,
    COUNT(
        DISTINCT (
            if1.item_numero + if1.item_sucursal + if1.item_tipo
        )
    )
FROM
    Item_Factura if1
    JOIN Item_Factura if2 on if1.item_numero + if1.item_sucursal + if1.item_tipo = if2.item_numero + if2.item_sucursal + if2.item_tipo
    JOIN Producto p1 on if1.item_producto = p1.prod_codigo
    JOIN Producto p2 on if2.item_producto = p2.prod_codigo
WHERE
    p1.prod_codigo != p2.prod_codigo
    and p1.prod_codigo > p2.prod_codigo
GROUP BY
    p1.prod_codigo,
    p1.prod_detalle,
    p2.prod_codigo,
    p2.prod_detalle
HAVING
    COUNT(
        DISTINCT (
            if1.item_numero + if1.item_sucursal + if1.item_tipo
        )
    ) > 500
