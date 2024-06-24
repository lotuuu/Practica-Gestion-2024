/*
15. Cree el/los objetos de base de datos necesarios para que el objeto principal
reciba un producto como parametro y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de
los componentes del mismo multiplicado por sus respectivas cantidades. No se
conocen los nivles de anidamiento posibles de los productos. Se asegura que
nunca un producto esta compuesto por si mismo a ningun nivel. El objeto
principal debe poder ser utilizado como filtro en el where de una sentencia
select.
*/

CREATE FUNCTION precioProducto(@prod char(8))
RETURNS DECIMAL(12, 2)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Composicion WHERE comp_producto = @prod)
        RETURN (SELECT prod_precio FROM Producto WHERE prod_codigo = @prod)

    DECLARE @precioAcc DECIMAL(12, 2)
    SET @precioAcc = 0
    
    DECLARE @subProducto char(8), @cantidad INTEGER
    DECLARE cursor_composiciones CURSOR FOR SELECT comp_componente, comp_cantidad FROM Composicion WHERE comp_producto = @prod
    OPEN cursor_composiciones
    FETCH NEXT FROM cursor_composiciones INTO @subProducto, @cantidad
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @precioAcc = @precioAcc + dbo.precioProducto(@subProducto) * @cantidad
        FETCH NEXT FROM cursor_composiciones INTO @subProducto, @cantidad
    END
    CLOSE cursor_composiciones
    DEALLOCATE cursor_composiciones
    RETURN @precioAcc
END

--SELECT dbo.precioProducto(prod_codigo), comp_producto FROM Producto JOIN Composicion ON prod_codigo = comp_componente 
