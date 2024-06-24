/*
Realizar una consulta que retorne
para cada producto que posea composición
 nombre del producto,
 precio del producto,
 precio de la sumatoria de los precios por la cantidad 
de los productos que lo componen.

Solo se deberán mostrar los productos que estén compuestos por más de 2 productos
y deben ser ordenados de mayor a menor por  cantidad de productos que lo componen.
*/


SELECT p.prod_codigo, p.prod_detalle, COUNT(c.comp_producto) FROM Producto p
JOIN COMPOSICION c on c.comp_producto = p.prod_codigo
GROUP BY p.prod_codigo, p.prod_detalle
HAVING COUNT(c.comp_producto) > 1
ORDER BY COUNT(c.comp_producto) ASC
