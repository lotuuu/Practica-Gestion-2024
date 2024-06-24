/*
Crear el/los objetos de base de datos que ante el intento de borrar un artículo 
verifique que no exista stock y si es así lo borre en caso contrario que emita un 
mensaje de error.


CREATE TRIGGER borrarArticulo ON Producto
FOR DELETE
AS
BEGIN
    IF (SELECT count(*) FROM deleted JOIN STOCK ON stoc_producto = prod_codigo WHERE stoc_cantidad > 0) > 0
    BEGIN
        PRINT('NO SE PEUDE BORRAR PRODUCTOS CON STOCK')
        ROLLBACK
    END
END
*/

CREATE TRIGGER borrarArticulo2 ON PRODUCTO INSTEAD OF DELETE
AS
BEGIN
    DECLARE @prod char(8)

    DECLARE c1 CURSOR FOR SELECT prod_codigo FROM deleted
    
    OPEN c1
    FETCH NEXT INTO @prod
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF (SELECT count(*) FROM deleted JOIN STOCK ON stoc_producto = prod_codigo WHERE stoc_cantidad > 0) > 0
            PRINT('NO SE PEUDE BORRAR EL PRODUCTO CON STOCK ' + @prod)
        ELSE BEGIN
            DELETE FROM STOCK WHERE stoc_producto = @prod
            DELETE FROM Producto WHERE prod_codigo = @prod
        END
  
        FETCH NEXT INTO @prod
    END
END
