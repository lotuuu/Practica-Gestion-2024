/*
6.Realizar un procedimiento que si en alguna factura se facturaron componentes
que conforman un combo determinado (o sea que juntos componen otro
producto de mayor nivel), en cuyo caso deberá reemplazar las filas 
correspondientes a dichos productos por una sola fila con el producto que
componen con la cantidad de dicho producto que corresponda.
*/

CREATE PROCEDURE reemplazarProductosPorComposiciones
AS
BEGIN
    DECLARE @fact_tipo CHAR(1), @fact_sucursal CHAR(2), @fact_numero CHAR(8)
    DECLARE @prodCombo CHAR(8), @combocantidad INTEGER;


    DECLARE cFacturas CURSOR FOR (SELECT fact_tipo, fact_sucursal, fact_numero FROM Factura)

    OPEN cFacturas

    -- para cada factura
    FETCH NEXT FROM cFacturas INTO @fact_tipo, @fact_sucursal, @fact_numero
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE cProducto CURSOR FOR (SELECT comp_producto FROM Item_Factura JOIN Composicion c1 ON comp_componente = item_producto WHERE item_tipo = @fact_tipo AND item_sucursal = @fact_sucursal AND item_numero = @fact_numero AND item_cantidad >= comp_cantidad)
        -- para cada producto de la factura que compone un combo
        OPEN cProducto

        FETCH NEXT FROM cProducto INTO @prodCombo, @combocantidad
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- borrar los items de la factura que componen el combo
            DELETE FROM Item_Factura WHERE item_tipo = @fact_tipo AND item_sucursal = @fact_sucursal AND item_numero = @fact_numero AND item_producto = @prodCombo

            -- insertar el combo en la factura
            INSERT INTO Item_Factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad)
            VALUES (@fact_tipo, @fact_sucursal, @fact_numero, @prodCombo, @combocantidad)

            FETCH NEXT FROM cProducto INTO @prodCombo, @combocantidad
        END

        CLOSE cProducto
        DEALLOCATE cProducto
        
        FETCH NEXT FROM cFacturas INTO @fact_tipo, @fact_sucursal, @fact_numero
    END

    CLOSE cFacturas
    DEALLOCATE cFacturas
END
