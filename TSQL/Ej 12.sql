/*
Cree el/los objetos de base de datos necesarios para que nunca un producto 
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se 
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos 
y tecnologías. No se conoce la cantidad de niveles de composición existentes.
*/

CREATE TRIGGER noCompuestoPorSiMismo ON Composicion
AFTER INSERT, UPDATE
AS
BEGIN
    IF (SELECT SUM(dbo.componeA(comp_componente, comp_producto)) FROM inserted) = 0
        RETURN
    
    PRINT 'EL PRODUCTO SE COMPONE POR SI MISMO'
    ROLLBACK
END


--ALTER FUNCTION componeA(@componente char(8), @prodCompuesto char(8)) --RETURNS INT
--AS
--BEGIN
--    IF (@componente = @prodCompuesto)
--        RETURN 1
--    DECLARE @subProducto char(8)
--    DECLARE cursor_composiciones CURSOR FOR SELECT comp_componente FROM Composicion WHERE comp_producto = @componente
--    OPEN cursor_composiciones
--    FETCH NEXT FROM cursor_composiciones INTO @subProducto
--    WHILE @@FETCH_STATUS = 0
--    BEGIN
--        IF (dbo.componeA(@subProducto, @prodCompuesto) = 1)
--        BEGIN
--            CLOSE cursor_composiciones
--            DEALLOCATE cursor_composiciones
--            RETURN 1
--        END
--        FETCH NEXT FROM cursor_composiciones INTO @subProducto
--    END
--    CLOSE cursor_composiciones
--    DEALLOCATE cursor_composiciones
--    RETURN 0
--END

SELECT dbo.componeA(prod_codigo, '00000001') FROM Producto
