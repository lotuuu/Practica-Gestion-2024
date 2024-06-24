

/*
Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados
 */

 

 SELECT jefe.empl_codigo AS cod_jefe, subordinado.empl_codigo AS cod_subor, subordinado.empl_nombre AS nombre_subor, COUNT(depos_subor.depo_codigo) AS depos_subor 
 FROM Empleado AS jefe JOIN Empleado AS subordinado on subordinado.empl_jefe = jefe.empl_codigo
 LEFT JOIN DEPOSITO AS depos_subor ON depo_encargado = subordinado.empl_codigo
 GROUP BY jefe.empl_codigo, subordinado.empl_codigo, subordinado.empl_nombre


 
/* 
 SELECT jefe.empl_codigo AS cod_jefe, subordinado.empl_codigo AS cod_subor, subordinado.empl_nombre AS nombre_subor
 FROM Empleado AS jefe JOIN Empleado AS subordinado ON subordinado.empl_jefe = jefe.empl_codigo
 */


 SELECT 
	jefe.empl_codigo AS cod_jefe,
	subordinado.empl_codigo AS cod_subor,
	subordinado.empl_nombre AS nombre_subor,
	COUNT(depos_jefe.depo_codigo) AS depos_jefe,
	COUNT(depos_subor.depo_codigo) AS depos_subor
 FROM Empleado AS jefe
	JOIN Empleado AS subordinado on subordinado.empl_jefe = jefe.empl_codigo
	LEFT JOIN DEPOSITO AS depos_subor ON depos_subor.depo_encargado = subordinado.empl_codigo
	LEFT JOIN DEPOSITO AS depos_jefe ON depos_jefe.depo_encargado = jefe.empl_codigo
 GROUP BY jefe.empl_codigo, subordinado.empl_codigo, subordinado.empl_nombre


 SELECT 
	jefe.empl_codigo AS cod_jefe,
	subordinado.empl_codigo AS cod_subor,
	subordinado.empl_nombre AS nombre_subor,
	COUNT(depos.depo_codigo) AS depos
 FROM Empleado AS jefe
	JOIN Empleado AS subordinado on subordinado.empl_jefe = jefe.empl_codigo
	LEFT JOIN DEPOSITO AS depos ON depos.depo_encargado = subordinado.empl_codigo or depos.depo_encargado = jefe.empl_codigo
 GROUP BY jefe.empl_codigo, subordinado.empl_codigo, subordinado.empl_nombre
