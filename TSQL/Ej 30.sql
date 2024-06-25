/*
30. Agregar el/los objetos necesarios para crear una regla por la cual un cliente no 
pueda comprar más de 100 unidades en el mes de ningún producto, si esto 
ocurre no se deberá ingresar la operación y se deberá emitir un mensaje “Se ha 
superado el límite máximo de compra de un producto”. Se sabe que esta regla se 
cumple y que las facturas no pueden ser modificadas.
*/

CREATE TRIGGER TRG_LIMITE_COMPRA
ON Factura
AFTER INSERT
AS
BEGIN
    DECLARE
    @fact_numero CHAR(8),
    @fact_sucursal CHAR(2),
    @fact_tipo CHAR(1),
    @fact_cliente CHAR(6),
    @fact_fecha DATE

    DECLARE cursor_facturas CURSOR FOR SELECT fact_numero, fact_sucursal, fact_tipo, fact_cliente, fact_fecha FROM inserted

    OPEN cursor_facturas
    FETCH NEXT FROM cursor_facturas INTO @fact_numero, @fact_sucursal, @fact_tipo, @fact_cliente

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @item_producto CHAR(6)
        DECLARE cursor_items CURSOR FOR
            SELECT item_producto FROM Item_Factura
            WHERE item_numero = @fact_numero AND item_sucursal = @fact_sucursal AND item_tipo = @fact_tipo

        OPEN cursor_items
        FETCH NEXT FROM cursor_items INTO @item_producto
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF (SELECT SUM(item_cantidad) FROM Item_Factura
                JOIN Factura ON item_numero+item_sucursal+item_tipo = fact_numero+fact_sucursal+fact_tipo
                WHERE fact_cliente = @fact_cliente
                AND item_producto = @item_producto
                AND MONTH(fact_fecha) = MONTH(@fact_fecha)
            ) > 100
            BEGIN
                PRINT 'Se ha superado el límite máximo de compra de un producto'
                DELETE FROM Item_Factura WHERE item_numero = @fact_numero AND item_sucursal = @fact_sucursal AND item_tipo = @fact_tipo
                DELETE FROM Factura WHERE fact_numero = @fact_numero AND fact_sucursal = @fact_sucursal AND fact_tipo = @fact_tipo
            END
        END
    END
END
