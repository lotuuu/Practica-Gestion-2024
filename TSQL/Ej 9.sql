/*
Crear el/los objetos de base de datos que ante alguna modificación de un ítem de 
factura de un artículo con composición realice el movimiento de sus 
correspondientes componentes.
*/

CREATE TRIGGER actualizarComposicion ON Item_Factura
FOR INSERT
AS
BEGIN
    DECLARE @comp_componente CHAR(8), @cantidad decimal(12,2), @deposito CHAR(2)

    -- cursor para recorrer los componentes de los productos
    DECLARE c1 CURSOR FOR SELECT comp_componente, item_cantidad*comp_cantidad FROM inserted JOIN Composicion ON item_producto = comp_producto

    -- para cada componente
    OPEN c1
    FETCH NEXT FROM c1 INTO @comp_componente, @cantidad
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- obtener el depósito con mayor stock
        SELECT @deposito stoc_deposito FROM Stock WHERE stoc_producto = @comp_componente ORDER BY stoc_cantidad DESC

        -- actualizar el stock
        UPDATE Stock SET stoc_cantidad = stoc_cantidad - @cantidad WHERE stoc_producto = @comp_componente AND stoc_deposito = @deposito

        -- buscar el siguiente componente
        FETCH NEXT FROM c1 INTO @comp_componente, @cantidad
    END
    CLOSE c1
    DEALLOCATE c1
END
