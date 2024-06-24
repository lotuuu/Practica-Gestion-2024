CREATE FUNCTION estadoDeposito(@producto CHAR(8), @deposito CHAR(2))
RETURNS VARCHAR(50)
BEGIN
    DECLARE @pctDeposito FLOAT;

    SET @pctDeposito =
        (SELECT stoc_cantidad / stoc_stock_maximo * 100 FROM STOCK WHERE stoc_producto = @producto and stoc_deposito = @deposito)

    RETURN CASE
        WHEN (@pctDeposito >= 100.0) THEN 'DEPOSITO COMPLETO' 
        ELSE CONCAT('OCUPACION DEL DEPOSITO ', STR(@pctDeposito, 25, 2), '%')
    END;
END

/*
1. Hacer una función que dado un artículo y un deposito devuelva un string que indique el estado del depósito según el artículo. Si la cantidad almacenada es menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el % de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar “DEPOSITO COMPLETO”
*/
--DROP FUNCTION estadoDeposito
--SELECT dbo.ej1(stoc_producto, stoc_deposito) FROM STOCK
