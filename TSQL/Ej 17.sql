/*
17. Sabiendo que el punto de reposicion del stock es la menor cantidad de ese objeto
que se debe almacenar en el deposito y que el stock maximo es la maxima
cantidad de ese producto en ese deposito, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio se cumpla automaticamente. No se
conoce la forma de acceso a los datos ni el procedimiento por el cual se
incrementa o descuenta stock
*/


--CREATE TRIGGER controlStock ON Stock FOR INSERT, UPDATE
--AS
--BEGIN
--    DECLARE @stoc_deposito INT
--    DECLARE @stoc_minimo INT
--    DECLARE @stoc_maximo INT
--    
--    SELECT
--        @stoc_deposito = stoc_deposito,
--        @stoc_minimo = stoc_punto_reposicion,
--        @stoc_maximo = stoc_stock_maximo
--    FROM inserted
--
--    IF @stoc_deposito < @stoc_minimo
--    BEGIN
--        PRINT('No se puede ingresar stock menor al minimo')
--        ROLLBACK TRANSACTION
--    END
--    IF @stoc_deposito > @stoc_maximo
--    BEGIN
--        PRINT('No se puede ingresar stock mayor al maximo')
--        ROLLBACK TRANSACTION
--    END
--END

-- si necesito hacerlo individualmente

CREATE TRIGGER controlStock ON Stock FOR INSERT
AS
BEGIN
    DECLARE
        @stoc_cantidad INT,
        @stoc_punto_reposicion INT,
        @stoc_stock_maximo INT,
        @stoc_detalle CHAR(100),
        @stoc_proxima_reposicion SMALLDATETIME,
        @stoc_producto CHAR(8),
        @stoc_deposito CHAR(2)


    DECLARE cursor_stock CURSOR FOR SELECT stoc_cantidad, stoc_punto_reposicion, stoc_stock_maximo, stoc_detalle, stoc_proxima_reposicion, stoc_producto, stoc_deposito FROM inserted
    OPEN cursor_stock
    FETCH NEXT FROM cursor_stock INTO @stoc_cantidad, @stoc_punto_reposicion, @stoc_stock_maximo, @stoc_detalle, @stoc_proxima_reposicion, @stoc_producto, @stoc_deposito
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @stoc_deposito < @stoc_punto_reposicion
        BEGIN
            PRINT('No se puede ingresar stock menor al minimo')
            CONTINUE
        END
        IF @stoc_deposito > @stoc_stock_maximo
        BEGIN
            PRINT('No se puede ingresar stock mayor al maximo')
            CONTINUE
        END
        INSERT INTO Stock (stoc_cantidad, stoc_punto_reposicion, stoc_stock_maximo, stoc_detalle, stoc_proxima_reposicion, stoc_producto, stoc_deposito) VALUES (@stoc_cantidad, @stoc_punto_reposicion, @stoc_stock_maximo, @stoc_detalle, @stoc_proxima_reposicion, @stoc_producto, @stoc_deposito)
        FETCH NEXT FROM cursor_stock INTO @stoc_cantidad, @stoc_punto_reposicion, @stoc_stock_maximo, @stoc_detalle, @stoc_proxima_reposicion, @stoc_producto, @stoc_deposito
    END
END
