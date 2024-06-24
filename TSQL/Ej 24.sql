/*
24. Se requiere recategorizar los encargados asignados a los depositos. Para ello 
cree el o los objetos de bases de datos necesarios que lo resueva, teniendo en 
cuenta que un deposito no puede tener como encargado un empleado que 
pertenezca a un departamento que no sea de la misma zona que el deposito, si 
esto ocurre a dicho deposito debera asignársele el empleado con menos 
depositos asignados que pertenezca a un departamento de esa zona
*/


ALTER PROCEDURE recategorizarEncargdadosDepositos
AS
BEGIN
    DECLARE @depo_codigo CHAR(2), @depo_zona CHAR(2)

    DECLARE c_depositos CURSOR FOR
        SELECT depo_codigo, depo_zona
        FROM Deposito

    OPEN c_depositos

    FETCH NEXT FROM c_depositos
        INTO @depo_codigo, @depo_zona
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF dbo.depositoTieneEncargadoDeOtraZona(@depo_codigo) = 1
        BEGIN
            DECLARE @empl CHAR(6)
            -- POR ALGUN MOTIVO ESTO ME ESTA SETEANDO NULL EN VEZ DEL EMPLEADO >:(
            SELECT TOP 1 @empl = empl_codigo
                FROM Empleado
                JOIN Departamento
                ON empl_departamento = depa_codigo
                WHERE depa_zona = @depo_zona
                ORDER BY (SELECT COUNT(*) FROM Deposito WHERE depo_encargado = empl_codigo) ASC
            UPDATE Deposito SET depo_encargado = @empl WHERE depo_codigo = @depo_codigo
        END

        FETCH NEXT FROM c_depositos INTO
            @depo_codigo,
            @depo_zona
    END

    CLOSE c_depositos
    DEALLOCATE c_depositos
END

SELECT *
                FROM Empleado
                JOIN Departamento
                ON empl_departamento = depa_codigo

SELECT depo_codigo, depo_encargado, dbo.depositoTieneEncargadoDeOtraZona(depo_codigo) FROM Deposito ORDER BY depo_encargado

UPDATE Deposito SET depo_encargado = 1 WHERE depo_codigo = '00'

EXEC recategorizarEncargdadosDepositos



--ALTER FUNCTION depositoTieneEncargadoDeOtraZona(@depo CHAR(2))
--RETURNS BIT
--AS
--BEGIN
--    DECLARE @zona CHAR(2), @empl CHAR(6)
--    SELECT @zona = depo_zona, @empl = depo_encargado FROM Deposito WHERE depo_codigo = @depo
--    
--    IF @zona IS NULL OR @empl IS NULL
--        RETURN 1
--
--    IF EXISTS (SELECT 1 FROM Empleado JOIN Departamento ON empl_departamento = depa_codigo WHERE empl_codigo = @empl AND depa_zona != @zona)
--        RETURN 1
--    RETURN 0
--END
