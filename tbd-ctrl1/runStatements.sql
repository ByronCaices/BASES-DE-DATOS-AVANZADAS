--- 1) Lista de lugares al que más viajan los chilenos por año (durante los últimos 4 años). 
SELECT
    v.destino,
    EXTRACT(YEAR FROM v.fecha_vuelo) AS anio,
    COUNT(*) AS total_viajes
FROM
    CLIENTE_COMP cc
JOIN
    CLIENTE c ON cc.nro_documento = c.nro_documento
JOIN
    VUELO v ON cc.vuelo_id = v.vuelo_id
WHERE
    c.nacionalidad = 'Chile'
    AND v.fecha_vuelo >= (CURRENT_DATE - INTERVAL '4 years')
GROUP BY
    v.destino,
    anio
ORDER BY
    total_viajes DESC;


-- 2) Lista con las secciones de vuelos más compradas por argentinos.
SELECT
    s.tipo_seccion,
    COUNT(*) AS num_compras
FROM
    CLIENTE c
    INNER JOIN PASAJE p ON c.nro_documento = p.nro_documento
    INNER JOIN SECCION s ON p.id_seccion = s.id_seccion
WHERE
    c.nacionalidad = 'Argentina'
GROUP BY
    s.tipo_seccion
ORDER BY
    num_compras DESC;


-- 3) Lista mensual de países que más gastan en volar (durante los últimos 4 años).
WITH country_month_spending AS (
    SELECT
        c.nacionalidad,
        DATE_TRUNC('month', v.fecha_vuelo) AS mes,
        SUM(co.monto_costo) AS total_gastado
    FROM
        CLIENTE c
        INNER JOIN PASAJE p ON c.nro_documento = p.nro_documento
        INNER JOIN VUELO v ON p.vuelo_id = v.vuelo_id
        INNER JOIN COSTO co ON p.id_pasaje = co.id_pasaje
    WHERE
        v.fecha_vuelo >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '4 years'
    GROUP BY
        c.nacionalidad,
        DATE_TRUNC('month', v.fecha_vuelo)
),
ranked_country_spending AS (
    SELECT
        cms.*,
        RANK() OVER (PARTITION BY cms.mes ORDER BY cms.total_gastado DESC) AS rank
    FROM
        country_month_spending cms
)
SELECT
    mes,
    nacionalidad,
    total_gastado
FROM
    ranked_country_spending
WHERE
    rank = 1
ORDER BY
    mes;


-- 4) Lista de pasajeros que viajan en “First Class” más de 4 veces al mes.
SELECT
    c.nro_documento,
    c.nombre,
    c.apellido,
    TO_CHAR(DATE_TRUNC('month', v.fecha_vuelo), 'YYYY-MM') AS mes,
    COUNT(*) AS cantidad_viajes
FROM
    PASAJE p
    INNER JOIN CLIENTE c ON p.nro_documento = c.nro_documento
    INNER JOIN SECCION s ON p.id_seccion = s.id_seccion
    INNER JOIN VUELO v ON p.vuelo_id = v.vuelo_id
WHERE
    s.tipo_seccion = 'First Class'
GROUP BY
    c.nro_documento,
    c.nombre,
    c.apellido,
    mes
HAVING
    COUNT(*) > 4
ORDER BY
    mes,
    cantidad_viajes DESC;


-- 5) Avión con menos vuelos.
SELECT a.id_avion, COUNT(*) AS cantidad_de_viajes
FROM AVION a
JOIN COMPANIA c ON a.compania_id = c.compania_id
JOIN VUELO v ON c.compania_id = v.compania_id
GROUP BY a.id_avion
ORDER BY cantidad_de_viajes ASC
LIMIT 1;


-- 6) Lista mensual de pilotos con mayor sueldo (durante los últimos 4 años).
SELECT e.nombre_empleado, e.cargo_empleado, s.fecha_pago, s.cantidad_sueldo AS c_sueldo
FROM empleado e
JOIN sueldo s ON e.id_empleado = s.id_empleado
WHERE e.cargo_empleado = 'Piloto' AND s.fecha_pago >= NOW() - INTERVAL '4 years'
ORDER BY c_sueldo DESC;


-- 7) Lista de compañías indicando cuál es el avión que más ha recaudado en los últimos 4 años y cuál es el monto recaudado.
WITH AvionesConRecaudacion AS (
	SELECT
    	c.compania_id,
    	a.id_avion,
    	SUM(co.monto_costo) AS RecaudacionTotal,
    	ROW_NUMBER() OVER (PARTITION BY c.compania_id ORDER BY SUM(co.monto_costo) DESC) AS rn
	FROM avion a
	INNER JOIN vuelo v ON a.id_avion = v.id_avion
	INNER JOIN compania c ON c.compania_id = v.compania_id
	INNER JOIN pasaje p ON p.vuelo_id = v.vuelo_id
	INNER JOIN costo co ON co.id_pasaje = p.id_pasaje
	WHERE v.fecha_vuelo > '2019-12-31'
	GROUP BY c.compania_id, a.id_avion
)

SELECT compania_id, id_avion, RecaudacionTotal
FROM AvionesConRecaudacion
WHERE rn = 1
ORDER BY RecaudacionTotal DESC;


-- 8) Lista de compañías y total de aviones por año (en los últimos 10 años).
WITH years AS (
    SELECT (EXTRACT(YEAR FROM CURRENT_DATE) - s.a) AS year
    FROM generate_series(0, 9) AS s(a)
),
company_years AS (
    SELECT
        c.compania_id,
        c.nombre AS company_name,
        y.year
    FROM
        COMPANIA c
        CROSS JOIN years y
)
SELECT
    cy.company_name,
    cy.year,
    COUNT(a.id_avion) AS total_aviones
FROM
    company_years cy
    LEFT JOIN AVION a ON
        a.compania_id = cy.compania_id AND
        EXTRACT(YEAR FROM a.anio_avion) <= cy.year
GROUP BY
    cy.company_name,
    cy.year
ORDER BY
    cy.company_name,
    cy.year;


-- 9) Lista anual de compañías que en promedio han pagado más a sus empleados (durante los últimos 10 años).
WITH avg_salaries AS (
    SELECT
        EXTRACT(YEAR FROM s.fecha_pago) AS year,
        c.compania_id,
        c.nombre AS company_name,
        AVG(s.cantidad_sueldo) AS average_salary
    FROM
        SUELDO s
        INNER JOIN EMPLEADO e ON s.id_empleado = e.id_empleado
        INNER JOIN COMPANIA c ON e.id_compania = c.compania_id
    WHERE
        s.fecha_pago >= (DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '10 years')
    GROUP BY
        year,
        c.compania_id,
        c.nombre
),
ranked_salaries AS (
    SELECT
        avg_salaries.*,
        RANK() OVER (PARTITION BY year ORDER BY average_salary DESC) AS salary_rank
    FROM
        avg_salaries
)
SELECT
    year,
    company_name,
    average_salary
FROM
    ranked_salaries
WHERE
    salary_rank = 1
ORDER BY
    year;


-- 10) Modelo de avión más usado por compañía durante el 2021.
WITH AvionesMasUsados AS (
 SELECT C.compania_id AS compania_id,
   m.id_modelo AS id_modelo,
   COUNT(V.vuelo_id) AS total_vuelos,
   ROW_NUMBER() OVER (PARTITION BY c.compania_id ORDER BY COUNT(V.vuelo_id) DESC) AS rn
 FROM Vuelo V
   JOIN Avion A ON V.id_avion = A.id_avion 
   JOIN Compania C ON V.compania_id = C.compania_id
   JOIN MODELO m ON a.id_modelo = m.id_modelo
 WHERE EXTRACT(YEAR FROM V.fecha_vuelo) = 2021
 GROUP BY C.compania_id,
   m.id_modelo
 ORDER BY c.compania_id,
   total_vuelos DESC
)


SELECT compania_id, id_modelo, total_vuelos
FROM AvionesMasUsados
WHERE rn = 1;