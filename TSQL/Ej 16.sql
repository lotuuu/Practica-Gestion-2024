/*
16. Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se descuenten del stock los articulos vendidos. Se descontaran
del deposito que mas producto poseea y se supone que el stock se almacena
tanto de productos simples como compuestos (si se acaba el stock de los
compuestos no se arman combos)
En caso que no alcance el stock de un deposito se descontara del siguiente y asi
hasta agotar los depositos posibles. En ultima instancia se dejara stock negativo
en el ultimo deposito que se desconto.
*/

CREATE TRIGGER descontarStock ON Item_Factura
FOR INSERT
AS
BEGIN
    DECLARE @prod CHAR(8), @cantidad DECIMAL(12, 2), @deposito CHAR(2), @stock DECIMAL(12, 2)

    -- cursor para recorrer los productos de la factura
    DECLARE c1 CURSOR FOR SELECT item_producto, item_cantidad FROM inserted

    -- para cada producto
    OPEN c1
    FETCH NEXT FROM c1 INTO @prod, @cantidad
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- cursor para recorrer los depositos con stock
        DECLARE c2 CURSOR FOR SELECT stoc_deposito, stoc_cantidad FROM Stock WHERE stoc_producto = @prod ORDER BY stoc_cantidad DESC

        -- para cada deposito
        OPEN c2
        FETCH NEXT FROM c2 INTO @deposito, @stock
        WHILE @@FETCH_STATUS = 0 AND @cantidad > 0
        BEGIN
            IF @stock >= @cantidad
            BEGIN
                -- descontar del stock
                UPDATE Stock SET stoc_cantidad = stoc_cantidad - @cantidad WHERE stoc_producto = @prod AND stoc_deposito = @deposito
                SET @cantidad = 0
            END
            ELSE
            BEGIN
                -- descontar del stock
                UPDATE Stock SET stoc_cantidad = 0 WHERE stoc_producto = @prod AND stoc_deposito = @deposito
                SET @cantidad = @cantidad - @stock
            END

            -- buscar el siguiente deposito
            FETCH NEXT FROM c2 INTO @deposito, @stock
        END
        CLOSE c2
        DEALLOCATE c2

        -- buscar el siguiente producto
        FETCH NEXT FROM c1 INTO @prod, @cantidad
    END
    CLOSE c1
    DEALLOCATE c1
END
