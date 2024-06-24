/*
Cree el/los objetos de base de datos necesarios para corregir la tabla empleado 
en caso que sea necesario. Se sabe que debería existir un único gerente general 
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado 
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por 
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la 
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla 
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad 
de empleados que había sin jefe antes de la ejecución.
*/

CREATE PROCEDURE corregirEmpleados(@empleadosSinJefe numeric(3) output) AS
BEGIN
    DECLARE @nuevoGerenteGeneral numeric(6);

    SET @empleadosSinJefe = (SELECT COUNT(*) FROM Empleado WHERE empl_jefe IS NULL);

    IF @empleadosSinJefe > 1
    BEGIN
        SELECT TOP 1 @nuevoGerenteGeneral = empl_codigo FROM Empleado WHERE empl_jefe IS NULL ORDER BY empl_salario DESC, empl_ingreso ASC;

        WITH EmpleadosSinJefe AS (SELECT empl_codigo FROM Empleado WHERE empl_jefe IS NULL)
        UPDATE Empleado
        SET empl_jefe = @nuevoGerenteGeneral
        WHERE empl_jefe IS NULL and empl_codigo != @nuevoGerenteGeneral and empl_codigo in (SELECT empl_codigo FROM EmpleadosSinJefe)
    END
    RETURN @empleadosSinJefe;
END

--DROP PROCEDURE corregirEmpleados
