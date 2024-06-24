/*
. Generar una consulta que muestre para cada artículo código, detalle, mayor precio
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean
stock
 */

select a.prod_codigo, a.prod_detalle, a.mi, a.ma, a.dif from (
	select prod_codigo, prod_detalle, MIN(item_precio) as mi, MAX(item_precio) as ma, 
		(max(item_precio) - min(item_precio)) / MAX(item_precio) * 100 as dif
	from Producto
	join Item_Factura on item_producto = prod_codigo
	group by prod_codigo, prod_detalle) as a
join STOCK on stoc_producto = a.prod_codigo
group by a.prod_codigo, a.prod_detalle, a.mi, a.ma, a.dif
having sum(stoc_cantidad) > 0

/* mal por mala atomicidad, si saco el group by y el having, se ve como tengo repetido cada producto por cada deposito en el que esta. El motivo es que no estoy haciendo el join con el total de la primary key. Si lo estuviera haciendo, estarìa multiplicando por 1 y no se agrandarìa el sample */


select prod_codigo, prod_detalle, MIN(item_precio) as mi, MAX(item_precio) as ma, 
	(max(item_precio) - min(item_precio)) / MAX(item_precio) * 100 as dif
from Producto
join Item_Factura on item_producto = prod_codigo
where prod_codigo in (
	select stoc_producto from STOCK
	group by stoc_producto
	having sum(stoc_cantidad) > 0
	)
group by prod_codigo,prod_detalle
