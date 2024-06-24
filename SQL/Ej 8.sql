/* Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene. */

Select prod_codigo, prod_detalle , MAX(stoc_cantidad) as max_stock
from Producto join STOCK on stoc_producto = prod_codigo
group by prod_codigo, prod_detalle having count(*) > (select count(*) from DEPOSITO)
