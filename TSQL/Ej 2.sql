
CREATE FUNCTION stockEnFecha(@producto CHAR(8), @fecha DATETIME)
RETURNS INT
BEGIN
DECLARE @stock_en_fecha INT;
SET @stock_en_fecha = (
    SELECT SUM(stoc_cantidad) -
        (SELECT COALESCE(SUM(item_cantidad), 0)
        FROM Item_Factura
        JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
        WHERE fact_fecha > @fecha AND item_producto = @producto
    )
    FROM Producto
    JOIN Stock on stoc_producto = prod_codigo
    WHERE prod_codigo = @producto
    GROUP BY stoc_producto
);
RETURN @stock_en_fecha
END

/*
2. Realizar una función que dado un artículo y una fecha, retorne el stock que existía a esa fecha
*/
--DROP FUNCTION stockEnFecha
-- SELECT dbo.stockEnFecha(item_producto, fact_fecha) FROM Item_Factura JOIN Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal ORDER BY 1
