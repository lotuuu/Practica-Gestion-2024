/*
Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor 
que más vendió (en monto) a lo largo del último año.
*/


CREATE PROCEDURE setearComision(@codMejorEmpleado numeric(6) output) AS
BEGIN
    UPDATE Empleado
    SET empl_comision = (SELECT SUM(fact_total) FROM Factura WHERE fact_vendedor = empl_codigo AND YEAR(fact_fecha) = YEAR(GETDATE()))

    SELECT TOP 1 @codMejorEmpleado = empl_codigo FROM Empleado ORDER BY empl_comision DESC 
END
