/*
Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de 
sus empleados totales (directos + indirectos)”. Se sabe que en la actualidad dicha 
regla se cumple y que la base de datos es accedida por n aplicaciones de 
diferentes tipos y tecnologías
*/

ALTER TRIGGER controlarSalario ON Empleado FOR INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i WHERE dbo.SumaSalariosEmpleadosACargo(i.empl_jefe) 
        < (SELECT empl_salario * 0.2 FROM Empleado WHERE empl_codigo = i.empl_jefe))
    BEGIN
        PRINT 'El salario no puede ser mayor al 20% de la suma de los salarios de los empleados a cargo'
        ROLLBACK
    END
    IF EXISTS (SELECT 1 FROM deleted d WHERE dbo.SumaSalariosEmpleadosACargo(d.empl_jefe) 
        < (SELECT empl_salario * 0.2 FROM Empleado WHERE empl_codigo = d.empl_jefe))
    BEGIN
        PRINT 'El salario no puede ser mayor al 20% de la suma de los salarios de los empleados a cargo'
        ROLLBACK
    END
END

--ALTER FUNCTION SumaSalariosEmpleadosACargo(@empleado NUMERIC(6,0))
--RETURNS DECIMAL(12,2)
--AS
--BEGIN
--    DECLARE @salario DECIMAL(12,2)
--    SET @salario = 0
--
--    IF NOT EXISTS (SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = @empleado)
--        RETURN @salario
--
--    SELECT @salario = COALESCE(SUM(empl_salario), 0) FROM Empleado WHERE empl_jefe = @empleado
--
--
--    DECLARE @empl NUMERIC(6,0)
--    DECLARE c1 CURSOR FOR SELECT empl_codigo FROM Empleado WHERE empl_jefe = @empleado
--    OPEN c1
--    FETCH NEXT FROM c1 INTO @empl
--    WHILE @@FETCH_STATUS = 0
--    BEGIN
--        SET @salario = @salario + dbo.SumaSalariosEmpleadosACargo(@empl) 
--
--        FETCH NEXT FROM c1 INTO @empl
--    END
--    CLOSE c1
--    DEALLOCATE c1
--
--    RETURN @salario
--END

-- SELECT empl_codigo, dbo.SumaSalariosEmpleadosACargo(empl_codigo), empl_salario FROM Empleado
