/*
Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que 
tengan un código mayor que su jefe directo
*/

CREATE FUNCTION CantEmpleadosACargo(@empleado NUMERIC(6,0))
RETURNS INT
AS
BEGIN
    DECLARE @cant INT
    SET @cant = 0

    SET @cant = @cant + (SELECT COUNT(*) FROM Empleado WHERE empl_jefe = @empleado AND empl_codigo > @empleado)
    IF (@cant = 0)
        RETURN @cant

    DECLARE @empl NUMERIC(6,0)
    DECLARE c1 CURSOR FOR SELECT empl_codigo FROM Empleado WHERE empl_jefe = @empleado

    OPEN c1
    FETCH NEXT FROM c1 INTO @empl

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @cant = @cant + (SELECT dbo.CantEmpleadosACargo(@empl)) 

        FETCH NEXT FROM c1 INTO @empl
    END
    CLOSE c1
    DEALLOCATE c1

    RETURN @cant
END

--SELECT empl_codigo, dbo.CantEmpleadosACargo(empl_codigo) FROM Empleado
