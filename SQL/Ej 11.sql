/*
Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
el año 2012
 */

SELECT
	fami_id,
	fami_detalle,
	COUNT(DISTINCT(prod_codigo)) AS cant_productos,
	SUM(item_cantidad * item_precio) AS total_ventas
FROM Producto
	JOIN Familia on prod_familia = fami_id
	JOIN Item_Factura on item_producto = prod_codigo
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
WHERE fami_id in (
	SELECT fami_id
	FROM Producto
		JOIN Familia on prod_familia = fami_id
		JOIN Item_Factura on item_producto = prod_codigo
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+		item_numero 
	WHERE YEAR(fact_fecha) = 2012
	GROUP BY fami_id
	HAVING SUM(item_precio*item_cantidad) > 20000)
GROUP BY fami_id, fami_detalle
ORDER BY COUNT(DISTINCT(prod_codigo)) DESC
