/*
27. Se requiere reasignar los encargados de stock de los diferentes depósitos. Para 
ello se solicita que realice el o los objetos de base de datos necesarios para 
asignar a cada uno de los depósitos el encargado que le corresponda, 
entendiendo que el encargado que le corresponde es cualquier empleado que no 
es jefe y que no es vendedor, o sea, que no está asignado a ningun cliente, se 
deberán ir asignando tratando de que un empleado solo tenga un deposito 
asignado, en caso de no poder se irán aumentando la cantidad de depósitos 
progresivamente para cada empleado
*/

ALTER PROCEDURE asignarEncargados AS
BEGIN
    DECLARE @deposito int
    DECLARE @empleado char(8)

    DECLARE c1 CURSOR FOR SELECT depo_codigo FROM Deposito
    OPEN c1
    FETCH NEXT FROM c1 INTO @deposito
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @empleado = dbo.empleadoConMenosDepositosNoVendedor()

        UPDATE Deposito SET depo_encargado = @empleado WHERE depo_codigo = @deposito
        FETCH NEXT FROM c1 INTO @deposito
    END
    CLOSE c1
    DEALLOCATE c1
END

ALTER FUNCTION empleadoConMenosDepositosNoVendedor() RETURNS char(8) AS
BEGIN
    DECLARE @empleado char(8)
    DECLARE @gerenteGeneral char(8)

    SELECT TOP 1 @gerenteGeneral = empl_codigo FROM Empleado WHERE empl_jefe IS NULL

    SELECT TOP 1 @empleado = empl_codigo FROM Empleado
    LEFT JOIN Deposito ON empl_codigo = depo_encargado
    WHERE NOT EXISTS (
        SELECT 1
        FROM Cliente
        WHERE clie_vendedor = empl_codigo
    )
    GROUP BY empl_codigo
    ORDER BY COUNT(depo_codigo) ASC

    SET @empleado = ISNULL(@empleado, 999)

    RETURN @empleado
END

SELECT dbo.empleadoConMenosDepositosNoVendedor() AS empleadoConMenosDepositos
SELECT * FROM Empleado

SELECT COUNT(*) FROM Deposito GROUP BY depo_encargado

INSERT INTO Empleado (
    empl_codigo,
    empl_nombre,
    empl_apellido,
    empl_nacimiento,
    empl_ingreso,
    empl_tareas,
    empl_salario,
    empl_comision,
    empl_jefe,
    empl_departamento
) VALUES (
    99,
    'Juan',
    'Perez',
    '1990-01-01',
    '2010-01-01',
    'Encargado de deposito',
    1000,
    0,
    1,
    1
)
EXEC asignarEncargados
