/*
19.  En virtud de una recategorizacion de productos referida a la familia de los mismos se 
solicita que desarrolle una consulta sql que retorne para todos los productos:

 Codigo de producto
 Detalle del producto
 Codigo de la familia del producto
 Detalle de la familia actual del producto
 Codigo de la familia sugerido para el producto
 Detalla de la familia sugerido para el producto

La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo 
detalle coinciden en los primeros 5 caracteres.
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor 
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea 
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente
*/

-- esta mal la consigna, la familia sugerida es la que comienza como el producto, no la que tiene los productos mas repetidos
-- segun la resolucion en github


SELECT
	prod_codigo,
	prod_detalle,
	f_act.fami_id,
	f_act.fami_detalle,
	(
		SELECT
			TOP 1 fami_id
		FROM
			Familia f_sug
		JOIN Producto p_sug ON f_sug.fami_id = p_sug.prod_familia
		WHERE p_sug.prod_detalle LIKE LEFT(p.prod_detalle, 5) + '%' AND f_sug.fami_id != f_act.fami_id AND fami_id IS NOT NULL
		GROUP BY
			fami_id
		HAVING COUNT(fami_id) >= ALL (
			SELECT
				COUNT(fami_id)
			FROM
				Familia f_sug
			JOIN Producto p_sug ON f_sug.fami_id = p_sug.prod_familia
			WHERE p_sug.prod_detalle LIKE LEFT(p.prod_detalle, 5) + '%' AND f_sug.fami_id != f_act.fami_id
			GROUP BY
				fami_id
		)
		ORDER BY
			COUNT(fami_id) DESC, fami_id ASC
	) AS fami_sug
FROM
	Producto p
	JOIN Familia f_act ON prod_familia = f_act.fami_id
	WHERE fami_sug IS NOT NULL
	ORDER BY prod_detalle ASC
