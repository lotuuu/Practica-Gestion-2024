
/* 
Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo
*/

SELECT prod_codigo, prod_detalle FROM Producto
	LEFT JOIN Item_Factura on item_producto = prod_codigo
	WHERE prod_codigo in 
		(SELECT TOP 10 prod_codigo
				FROM Producto
				FULL JOIN Item_Factura on item_producto = prod_codigo
				GROUP BY prod_codigo
				ORDER BY SUM(item_cantidad) ASC
		) or prod_codigo in
		(SELECT TOP 10 prod_codigo
				FROM Producto
				FULL JOIN Item_Factura on item_producto = prod_codigo
				GROUP BY prod_codigo
				ORDER BY SUM(item_cantidad) DESC
		)
		GROUP BY prod_codigo, prod_detalle

/*  le falta la parte del cliente */ 


/* intento incompleto: */


SELECT prod_codigo, prod_detalle, max(y.num) FROM Producto
	LEFT JOIN Item_Factura on item_producto = prod_codigo
	LEFT JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
	LEFT JOIN Cliente on fact_cliente = clie_codigo
	JOIN (SELECT COUNT(*) as num FROM Cliente) AS y ON 
	WHERE prod_codigo in 
		(SELECT TOP 10 prod_codigo
				FROM Producto
				FULL JOIN Item_Factura on item_producto = prod_codigo
				GROUP BY prod_codigo
				ORDER BY SUM(item_cantidad) ASC
		) or prod_codigo in
		(SELECT TOP 10 prod_codigo
				FROM Producto
				FULL JOIN Item_Factura on item_producto = prod_codigo
				GROUP BY prod_codigo
				ORDER BY SUM(item_cantidad) DESC
		)
		GROUP BY prod_codigo, prod_detalle
	
