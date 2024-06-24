/*
Agregar el/los objetos necesarios para que si un cliente compra un producto 
compuesto a un precio menor que la suma de los precios de sus componentes 
que imprima la fecha, que cliente, que productos y a qué precio se realizó la 
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma 
de los componentes.
*/
ALTER TRIGGER alertarComponenteBarato ON Item_Factura INSTEAD OF INSERT
AS
BEGIN
    DECLARE
        @combo_codigo CHAR(8),
        @combo_precio DECIMAL(12, 2),
        @combo_cantidad INTEGER,
        @combo_numero CHAR(8),
        @combo_sucursal CHAR(2),
        @combo_tipo CHAR(1),
        @clie_codigo CHAR(6),
        @fact_fecha SMALLDATETIME

    -- Itero todos los Item_Factura insertados que sean compuestos 
    DECLARE cursor_combo CURSOR FOR SELECT
        item_producto,
        item_precio,
        item_cantidad,
        item_numero,
        item_sucursal,
        item_tipo, 
        fact_cliente,
        fact_fecha 
    FROM inserted
    JOIN Factura ON fact_numero + fact_tipo + fact_sucursal = item_numero + item_tipo + item_sucursal
    WHERE item_producto in (SELECT comp_producto FROM Composicion)

    OPEN cursor_combo
    FETCH NEXT FROM cursor_combo INTO
        @combo_codigo,
        @combo_precio,
        @combo_cantidad,
        @combo_numero,
        @combo_sucursal,
        @combo_tipo,
        @clie_codigo,
        @fact_fecha
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- CALCULAMOS LA SUMA DE LOS PRECIOS DE LOS COMPONENTES
        DECLARE @sumaPreciosComponentes DECIMAL(12, 2), @precioCombo DECIMAL(12, 2)
        
        SELECT @sumaPreciosComponentes = SUM(prod_precio) FROM inserted combo
        JOIN Composicion ON comp_producto = combo.item_producto
        JOIN Producto componente ON componente.prod_codigo = comp_componente
        WHERE item_producto = @combo_codigo;

        IF (@precioCombo < @sumaPreciosComponentes / 2)
        BEGIN
            PRINT('No se puede vender el combo ' + @combo_codigo + ' a un precio menor a la mitad de la suma de los precios de sus componentes');
            FETCH NEXT FROM cursor_combo INTO
                @combo_codigo,
                @combo_precio,
                @combo_cantidad,
                @combo_numero,
                @combo_sucursal,
                @combo_tipo,
                @clie_codigo,
                @fact_fecha
            CONTINUE;
        END

        IF (@precioCombo < @sumaPreciosComponentes)
                PRINT('El combo ' + @combo_codigo + ' se vendió a un precio menor al de sus componentes el ' + @fact_fecha + ' al cliente ' + @clie_codigo + ' a un precio de ' + @combo_precio);

        INSERT INTO Item_Factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio) VALUES (@combo_tipo, @combo_sucursal, @combo_numero, @combo_codigo, @combo_cantidad, @combo_precio)

        FETCH NEXT FROM cursor_combo INTO
            @combo_codigo,
            @combo_precio,
            @combo_cantidad,
            @combo_numero,
            @combo_sucursal,
            @combo_tipo,
            @clie_codigo,
            @fact_fecha
    END
    CLOSE cursor_combo
    DEALLOCATE cursor_combo

    -- Inserto sin handlear los que no son compuestos
    DECLARE cursor_no_combo CURSOR FOR SELECT item_producto, item_precio, item_cantidad, item_numero, item_sucursal, item_tipo FROM inserted WHERE item_producto NOT IN (SELECT comp_producto FROM Composicion)

    OPEN cursor_no_combo
    FETCH NEXT FROM cursor_no_combo INTO
        @combo_codigo,
        @combo_precio,
        @combo_cantidad,
        @combo_numero,
        @combo_sucursal,
        @combo_tipo
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO Item_Factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
        VALUES (@combo_tipo, @combo_sucursal, @combo_numero, @combo_codigo, @combo_cantidad, @combo_precio)

        FETCH NEXT FROM cursor_no_combo INTO
            @combo_codigo,
            @combo_precio,
            @combo_cantidad,
            @combo_numero,
            @combo_sucursal,
            @combo_tipo
    END
    CLOSE cursor_no_combo
    DEALLOCATE cursor_no_combo
END

--INSERT INTO Producto (prod_codigo, prod_detalle, prod_precio) VALUES ('00000001', 'Combo 1', 90)
--
--INSERT INTO Producto (prod_codigo, prod_detalle, prod_precio) VALUES ('00000002', 'Componente 1', 50)
--
--INSERT INTO Producto (prod_codigo, prod_detalle, prod_precio) VALUES ('00000003', 'Componente 2', 50)
--
--INSERT INTO Composicion (comp_producto, comp_componente, comp_cantidad) VALUES ('00000001', '00000002', 1)
--
--INSERT INTO Composicion (comp_producto, comp_componente, comp_cantidad) VALUES ('00000001', '00000003', 1)
--
--INSERT INTO Factura (fact_tipo, fact_sucursal, fact_numero,  fact_fecha, fact_cliente) VALUES ('A', '01', '00000001',  '2021-01-01', '00001')
--
--INSERT INTO
--    Item_Factura (
--        item_tipo,
--        item_sucursal,
--        item_numero,
--        item_producto,
--        item_cantidad,
--        item_precio
--    )
--VALUES
--    ('A', '01', '00000001', '00000001', 1, 90)
