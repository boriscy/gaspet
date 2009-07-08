# view_campos_detalles
# Vista para poder ver un campo con todas sus dependencias como area, contrato, empresa
CREATE VIEW view_campos_detalles AS  SELECT e.nombre AS empresa, a.nombre AS area,
c.nombre AS campo, c.codigo, c.id AS campo_id, e.id AS empresa_id, a.id AS area_id,
c.departamento_id AS departamento_id
FROM campos c
JOIN areas a ON ( a.id = c.area_id )
JOIN contratos con ON ( con.id = a.contrato_id )
JOIN empresas e ON ( e.id = con.empresa_id )