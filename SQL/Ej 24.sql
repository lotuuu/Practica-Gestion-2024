/*
24.  Escriba una consulta que considerando solamente las facturas correspondientes a los 
dos vendedores ----EMPLEADOS---- con mayores comisiones, retorne los productos con composición 
facturados al menos en cinco facturas,
La consulta debe retornar las siguientes columnas:
	 Código de Producto
	 Nombre del Producto
	 Unidades facturadas
El resultado deberá ser ordenado por las unidades facturadas descendente.
*/

SELECT
    prod_codigo,
    prod_detalle,
    COUNT(item_producto) vecesFacturado,
    SUM(item_cantidad) unidadesFacturadas
FROM
    Producto
    JOIN Item_Factura ON item_producto = prod_codigo
    JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
    JOIN Cliente ON clie_codigo = fact_cliente
WHERE
    fact_vendedor IN (
        SELECT
            TOP 2 empl_codigo
        FROM
            Empleado
        ORDER BY
            empl_comision DESC
    )
    -- en vez de joinear con Composicion, nos fijamos que tenga composicion asi
    -- de esta forma no se nos duplican entradas en la query
    AND prod_codigo IN (
        SELECT
            comp_producto
        FROM
            Composicion
    )
GROUP BY
    prod_codigo,
    prod_detalle
HAVING
    COUNT(
        DISTINCT (fact_numero + fact_tipo + fact_sucursal)
    ) >= 5
ORDER BY
    SUM(item_cantidad) DESC
