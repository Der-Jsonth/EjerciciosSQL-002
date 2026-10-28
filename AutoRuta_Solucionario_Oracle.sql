-- SOLUCIONARIO DOCENTE | CONCESIONARIA AUTORUTA | ORACLE SQL
-- Requiere ejecutar previamente AutoRuta_Datos_Oracle.sql.
-- Cada caso se resuelve con una consulta independiente.

-- CASO 01 | Inventario completo: todas las columnas y filas.
SELECT *
FROM CA_VEHICULO;

-- CASO 02 | Catalogo de precios: orden descendente de precio y marca ascendente.
SELECT marca AS "MARCA",
       modelo AS "MODELO",
       anio AS "AÑO",
       estado AS "ESTADO",
       precio_lista AS "PRECIO LISTA"
FROM CA_VEHICULO
ORDER BY precio_lista DESC, marca ASC;

-- CASO 03 | Marcas diferentes sin repetir, en orden alfabetico.
SELECT DISTINCT marca AS "MARCA"
FROM CA_VEHICULO
ORDER BY marca ASC;

-- CASO 04 | Nombre completo, ciudad y correo de cada cliente.
SELECT nombre || ' ' || apellido AS "NOMBRE COMPLETO",
       ciudad AS "CIUDAD",
       correo AS "CORREO"
FROM CA_CLIENTE
ORDER BY apellido ASC, nombre ASC;

-- CASO 05 | Mensaje personalizado de seguimiento a cada cliente.
SELECT 'Hola, ' || nombre || ' ' || apellido ||
       '. Tenemos novedades en AutoRuta.' AS "MENSAJE"
FROM CA_CLIENTE
ORDER BY apellido ASC, nombre ASC;

-- CASO 06 | Vehiculos nuevos con precio de lista <= $20.000.000.
-- Resultados: Kia Morning, Chevrolet Onix, Nissan Versa, Kia Sonet, Toyota Yaris.
SELECT marca AS "MARCA",
       modelo AS "MODELO",
       anio AS "AÑO",
       precio_lista AS "PRECIO LISTA"
FROM CA_VEHICULO
WHERE estado = 'Nuevo' AND precio_lista <= 20000000
ORDER BY precio_lista ASC, marca ASC;

-- CASO 07 | Simular rebaja del 8%; sin actualizar precios en la BD.
-- Ejemplo Suzuki Swift: 12.990.000 - 1.039.200 = 11.950.800.
SELECT marca || ' ' || modelo AS "VEHICULO",
       precio_lista AS "PRECIO ORIGINAL",
       precio_lista * 0.08 AS "DESCUENTO 8%",
       precio_lista * 0.92 AS "PRECIO PROMOCIONAL"
FROM CA_VEHICULO
ORDER BY "PRECIO PROMOCIONAL" ASC;

-- CASO 08 | Mostrar efecto de valores nulos en calculos.
-- Si BONO_MARCA es NULL, la resta tambien devuelve NULL.
SELECT marca || ' ' || modelo AS "VEHICULO",
       precio_lista AS "PRECIO LISTA",
       bono_marca AS "BONO MARCA",
       precio_lista - bono_marca AS "PRECIO CON BONO"
FROM CA_VEHICULO
ORDER BY marca ASC, modelo ASC;

-- CASO 09 | Descuento monetario y total a pagar de cada venta.
-- Ejemplo 4002: precio base 23.990.000, descuento 2.399.000, total 21.591.000.
SELECT id_venta AS "VENTA",
       precio_base AS "PRECIO BASE",
       descuento_pct AS "DESCUENTO %",
       precio_base * descuento_pct / 100 AS "DESCUENTO CLP",
       precio_base * (1 - descuento_pct / 100) AS "TOTAL A PAGAR"
FROM CA_VENTA
ORDER BY "DESCUENTO CLP" DESC, id_venta ASC;

-- CASO 10 | Simular 24 cuotas sin intereses sobre el total descontado.
-- No incluye gastos de gestion, seguros ni otros cargos.
SELECT id_venta AS "VENTA",
       precio_base * (1 - descuento_pct / 100) AS "MONTO FINANCIADO",
       precio_base * (1 - descuento_pct / 100) / 24 AS "CUOTA TEORICA"
FROM CA_VENTA
ORDER BY "CUOTA TEORICA" DESC, id_venta ASC;

-- CASO 11 | Ventas mas recientes primero; desempate por precio base.
SELECT id_venta AS "VENTA",
       fecha_venta AS "FECHA",
       precio_base AS "PRECIO BASE"
FROM CA_VENTA
ORDER BY fecha_venta DESC, precio_base DESC;

-- CASO 12 | Generar catalogo de PROMOCION de vehiculos nuevos con 7% de rebaja.
-- CTAS no copia las restricciones PK, FK y UNIQUE de la tabla de origen.
-- Ejecutar UNA SOLA VEZ. Para repetir, eliminar CA_CATALOGO_PROMO.
CREATE TABLE CA_CATALOGO_PROMO AS
SELECT id_vehiculo,
       marca,
       modelo,
       precio_lista AS precio_original,
       precio_lista * 0.93 AS precio_promocional
FROM CA_VEHICULO
WHERE estado = 'Nuevo';

SELECT *
FROM CA_CATALOGO_PROMO
ORDER BY precio_promocional ASC;

-- DESAFIO OPCIONAL | Uso de JOIN (contenido de nivel posterior).
-- Una fila por venta, con vehiculo, cliente, vendedor y total con descuento.
SELECT vt.id_venta AS "VENTA",
       c.nombre || ' ' || c.apellido AS "CLIENTE",
       vh.marca || ' ' || vh.modelo AS "VEHICULO",
       vd.nombre || ' ' || vd.apellido AS "VENDEDOR",
       vt.precio_base * (1 - vt.descuento_pct / 100) AS "TOTAL A PAGAR"
FROM CA_VENTA vt
JOIN CA_CLIENTE c ON c.id_cliente = vt.id_cliente
JOIN CA_VEHICULO vh ON vh.id_vehiculo = vt.id_vehiculo
JOIN CA_VENDEDOR vd ON vd.id_vendedor = vt.id_vendedor
ORDER BY vt.id_venta ASC;
