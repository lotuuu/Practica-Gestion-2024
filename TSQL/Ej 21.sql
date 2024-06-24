/*
21. Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que en una factura no puede contener productos de
diferentes familias. En caso de que esto ocurra no debe grabarse esa factura y
debe emitirse un error en pantalla.
*/

--after porque necesito los item_factura insertados previamente
CREATE TRIGGER controlFacturasFamilias ON Factura AFTER INSERT
AS
BEGIN
    DECLARE @fact_cliente CHAR(8), 
        @fact_fecha SMALLDATETIME, 
        @fact_numero CHAR(8), 
        @fact_sucursal CHAR(2), 
        @fact_tipo CHAR(1), 
        @fact_total DECIMAL(12, 2),
        @fact_total_impuestos DECIMAL(12, 2),
        @fact_vendedor CHAR(6),
        @prod_familia CHAR(3)

    -- cursor para recorrer cada factura, en caso de que se carguen masivamente
    DECLARE cursor_facturas CURSOR FOR SELECT
        fact_cliente, 
        fact_fecha, 
        fact_numero, 
        fact_sucursal, 
        fact_tipo, 
        fact_total, 
        fact_total_impuestos, 
        fact_vendedor,
        prod_familia FROM inserted JOIN Item_Factura ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo JOIN Producto ON item_producto = prod_codigo

    OPEN cursor_facturas
    FETCH NEXT FROM cursor_facturas INTO @fact_cliente, @fact_fecha, @fact_numero, @fact_sucursal, @fact_tipo, @fact_total, @fact_total_impuestos, @fact_vendedor, @prod_familia
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- si la factura tiene mas de una familia de productos, se elimina
        IF (SELECT COUNT(DISTINCT prod_familia) FROM inserted
                JOIN Item_Factura ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo JOIN Producto ON item_producto = prod_codigo
                WHERE fact_numero = @fact_numero AND fact_sucursal = @fact_sucursal AND fact_tipo = @fact_tipo
            ) > 1
            DELETE FROM Factura WHERE fact_numero = @fact_numero AND fact_sucursal = @fact_sucursal AND fact_tipo = @fact_tipo

        FETCH NEXT FROM cursor_facturas INTO @fact_cliente, @fact_fecha, @fact_numero, @fact_sucursal, @fact_tipo, @fact_total, @fact_total_impuestos, @fact_vendedor, @prod_familia
    END

    CLOSE cursor_facturas
    DEALLOCATE cursor_facturas
END 
