/* Mostrar nombre de producto,
cantidad de clientes distintos que lo compraron
importe promedio pagado por el producto,
cantidad de depósitos en los cuales hay stock del producto y
stock actual del producto en todos los depósitos. Se deberán mostrar
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto. */

SELECT 
    prod_detalle,
    COUNT(DISTINCT(fact_cliente)) AS cant_clientes,
    AVG(item_precio * item_cantidad) AS importe_promedio,
    COUNT(DISTINCT(stoc_deposito)) AS cant_depositos,
    SUM(stoc_cantidad) AS stock_total
    FROM Producto
    JOIN Item_Factura ON item_producto = prod_codigo
    JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
    JOIN STOCK ON stoc_producto = prod_codigo
    WHERE YEAR(fact_fecha) = 2012
    GROUP BY prod_detalle
    ORDER BY SUM(item_cantidad * item_cantidad) DESC
