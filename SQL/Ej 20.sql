/*
Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje 
2012.

El puntaje de cada empleado se calculara de la siguiente manera:
para los que hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas que superen los 100 pesos que haya vendido en el año,\

para los que tengan menos de 50 facturas en el año el calculo del puntaje sera el 50% de cantidad de facturas realizadas por sus subordinados directos en dicho año.
 */
SELECT
    TOP 3 e.empl_codigo,
    e.empl_nombre,
    e.empl_apellido,
    e.empl_ingreso,
    (
        CASE
            WHEN (
                SELECT
                    COUNT(fact_numero + fact_tipo + fact_sucursal)
                FROM
                    Factura
                WHERE
                    fact_vendedor = e.empl_codigo
                    AND YEAR (fact_fecha) = 2011
            ) >= 50 THEN (
                SELECT
                    COUNT(f2.fact_numero + f2.fact_tipo + f2.fact_sucursal)
                FROM
                    Factura f2
                WHERE
                    f2.fact_vendedor = e.empl_codigo
                    AND f2.fact_total > 100
                    AND YEAR (f2.fact_fecha) = 2011
            )
            ELSE (
                SELECT
                    COUNT(f2.fact_numero + f2.fact_tipo + f2.fact_sucursal)
                FROM
                    Factura f2
                WHERE
                    f2.fact_vendedor IN (
                        SELECT
                            e2.empl_codigo
                        FROM
                            Empleado e2
                        WHERE
                            e2.empl_jefe = e.empl_codigo
                    )
                    AND YEAR (f2.fact_fecha) = 2011
            )
        END
    ) AS puntaje_2011,
    (
        CASE
            WHEN (
                SELECT
                    COUNT(fact_numero + fact_tipo + fact_sucursal)
                FROM
                    Factura
                WHERE
                    fact_vendedor = e.empl_codigo
                    AND YEAR (fact_fecha) = 2012
            ) >= 50 THEN (
                SELECT
                    COUNT(f2.fact_numero + f2.fact_tipo + f2.fact_sucursal)
                FROM
                    Factura f2
                WHERE
                    f2.fact_vendedor = e.empl_codigo
                    AND f2.fact_total > 100
                    AND YEAR (f2.fact_fecha) = 2012
            )
            ELSE (
                SELECT
                    COUNT(f2.fact_numero + f2.fact_tipo + f2.fact_sucursal)
                FROM
                    Factura f2
                WHERE
                    f2.fact_vendedor IN (
                        SELECT
                            e2.empl_codigo
                        FROM
                            Empleado e2
                        WHERE
                            e2.empl_jefe = e.empl_codigo
                    )
                    AND YEAR (f2.fact_fecha) = 2012
            )
        END
    ) AS puntaje_2012
FROM
    Empleado e
GROUP BY
    e.empl_codigo,
    e.empl_nombre,
    e.empl_apellido,
    e.empl_ingreso
ORDER BY
    puntaje_2012 DESC
