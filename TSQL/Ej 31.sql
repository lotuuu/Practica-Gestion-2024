/*
31. Desarrolle el o los objetos de base de datos necesarios, para que un jefe no pueda 
tener más de 20 empleados a cargo, directa o indirectamente, si esto ocurre 
debera asignarsele un jefe que cumpla esa condición, si no existe un jefe para 
asignarle se le deberá colocar como jefe al gerente general que es aquel que no 
tiene jefe.
*/

CREATE TRIGGER controlarCantidadEmpleados ON Empleado FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @empl_codigo NUMERIC(6,0)
    DECLARE @cant INT
    DECLARE @nuevoJefe NUMERIC(6,0)
    DECLARE @gerenteGeneral NUMERIC(6,0)
    DECLARE @empleadosSinJefe INT

    DECLARE cursor_empleados CURSOR FOR SELECT empl_codigo FROM inserted
    OPEN cursor_empleados
    FETCH NEXT FROM cursor_empleados INTO @empl_codigo
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @cant = dbo.CantEmpleadosACargo(@empl_codigo)
        IF @cant > 20
        BEGIN
            SET @nuevoJefe = (SELECT TOP 1 empl_codigo FROM Empleado WHERE dbo.CantEmpleadosACargo(empl_codigo) < 20)
            IF @nuevoJefe IS NULL
            BEGIN
                SET @gerenteGeneral = (SELECT TOP 1 empl_codigo FROM Empleado WHERE empl_jefe IS NULL)
                UPDATE Empleado
                SET empl_jefe = @gerenteGeneral
                WHERE empl_codigo = @empl_codigo
            END
            ELSE
            BEGIN
                UPDATE Empleado
                SET empl_jefe = @nuevoJefe
                WHERE empl_codigo = @empl_codigo
            END
        END
        FETCH NEXT FROM cursor_empleados INTO @empl_codigo
    END
    CLOSE cursor_empleados
    DEALLOCATE cursor_empleados
END
