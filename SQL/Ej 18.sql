/*
18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.
 */
SELECT
	rubr_detalle DETALLE_RUBRO,
	SUM(item_cantidad * item_precio) VENTAS,
	(
		SELECT
			TOP 1 item_producto
		FROM
			Item_Factura
			JOIN Producto ON item_producto = prod_codigo
		WHERE
			prod_rubro = rubr_id
		GROUP BY
			item_producto
		ORDER BY
			SUM(item_cantidad) DESC
	) PROD1,
	(
		SELECT
			TOP 1 item_producto
		FROM
			Item_Factura
			JOIN Producto ON item_producto = prod_codigo
		WHERE
			prod_rubro = rubr_id AND item_producto != (
				SELECT
					TOP 1 item_producto
				FROM
					Item_Factura
					JOIN Producto ON item_producto = prod_codigo
				WHERE
					prod_rubro = rubr_id
				GROUP BY
					item_producto
				ORDER BY
					SUM(item_cantidad) DESC
			)
		GROUP BY
			item_producto
		ORDER BY
			SUM(item_cantidad) DESC
	) PROD2,
	ISNULL((
		SELECT
			TOP 1 fact_cliente
		FROM
			Factura
			JOIN Item_Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
			JOIN Producto ON item_producto = prod_codigo
		WHERE
			prod_rubro = rubr_id
			AND DATEDIFF (DAY, fact_fecha, GETDATE ()) <= 30
		GROUP BY
			fact_cliente
		ORDER BY
			SUM(item_cantidad) DESC
	), 'NO HAY CLIENTE') CLIENTE
FROM
	Rubro
	JOIN Producto ON prod_rubro = rubr_id
	JOIN Item_Factura ON prod_codigo = item_producto
	JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
	JOIN Cliente ON clie_codigo = fact_cliente
GROUP BY
	rubr_detalle,
	rubr_id
ORDER BY
	COUNT(DISTINCT item_producto) DESC
