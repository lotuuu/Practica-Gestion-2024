/*
Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada Fact_table tiene las siguiente definición:
DROP TABLE Fact_table
CREATE table Fact_table
( anio char(4) NOT NULL,
mes char(2) NOT NULL,
familia char(3) NOT NULL,
rubro char(4) NOT NULL,
zona char(3) NOT NULL,
cliente char(6) NOT NULL,
producto char(8) NOT NULL,
cantidad decimal(12,2),
monto decimal(12,2)
)
Alter table Fact_table
Add constraint constttt primary key(anio,mes,familia,rubro,zona,cliente,producto)
*/

CREATE PROCEDURE llenarFactTable
AS
BEGIN  
INSERT Fact_table
SELECT YEAR(fact_fecha), MONTH(fact_fecha), prod_familia, prod_rubro, depa_zona, clie_codigo, prod_codigo, SUM(item_cantidad), SUM(item_precio)
FROM Factura
JOIN Item_Factura ON item_numero + item_tipo + item_sucursal = fact_numero + fact_tipo + fact_sucursal
JOIN Producto ON prod_codigo = item_producto
JOIN Cliente ON fact_cliente = clie_codigo
JOIN Empleado on empl_codigo = fact_vendedor
JOIN Departamento on depa_codigo = empl_departamento
GROUP BY 
    YEAR(fact_fecha), MONTH(fact_fecha), prod_familia, prod_rubro, depa_zona, clie_codigo, prod_codigo
END

EXEC dbo.llenarFactTable
DROP PROCEDURE llenarFactTable
