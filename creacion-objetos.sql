-- Creacion de tablas para TEKA LIVINGS

CREATE DATABASE IF NOT EXISTS teka_livings;

USE teka_livings;

CREATE TABLE IF NOT EXISTS clientes (
	cliente_id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    dni VARCHAR(20) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
	localidad VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    mail VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS pagos (
    pago_id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    tranferencia TINYINT DEFAULT 0,
    tarjeta_credito TINYINT DEFAULT 0,
    efectivo TINYINT DEFAULT 0,
    mercado_pago TINYINT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS envios (
    envio_id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    transporte TINYINT DEFAULT 0,
    retiro_local TINYINT DEFAULT 0,
    detalle_envio VARCHAR (100)
    
);

CREATE TABLE IF NOT EXISTS proveedores (
    proveedor_id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    empresa VARCHAR(50) NOT NULL,
    telefono VARCHAR(50),
    mail VARCHAR(50),
    direccion VARCHAR(50),
    localidad VARCHAR(50),
    cbu_banco VARCHAR(50)

);

CREATE TABLE IF NOT EXISTS productos (
    producto_id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    proveedor_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    precio DECIMAL(20.2) NOT NULL,
    color VARCHAR(50),
    medida VARCHAR(50),
    FOREIGN KEY (proveedor_id)
        REFERENCES proveedores (proveedor_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS pedidos (
	pedidos_id INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    pago_id INT NOT NULL,
    envio_id INT NOT NULL,
    seña VARCHAR (20),
    fecha_pedido DATETIME, 
    precio_total DECIMAL (20,2),
    FOREIGN KEY (cliente_id)
		REFERENCES clientes(cliente_id)
        ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (pago_id)
		REFERENCES pagos(pago_id)
        ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (envio_id)
		REFERENCES envios(envio_id)
        ON DELETE CASCADE
		ON UPDATE CASCADE
        
);

CREATE TABLE IF NOT EXISTS items (
    pedidos_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL(20.2),
    FOREIGN KEY (pedidos_id)
        REFERENCES pedidos (pedidos_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (producto_id)
        REFERENCES productos (producto_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);


-- Vistas
-- Vista para mostrar los productos de la muebleria con sus respectivos proveedores y a que localidad pertenecen, donde el precio del producto sea mayor a $10000

CREATE OR REPLACE VIEW v_proveedores_productos AS
    (SELECT prov.empresa as EMPRESA, prov.localidad as LOCALIDAD, p.nombre as PRODUCTO, p.precio as PRECIO
	FROM proveedores prov
    JOIN productos p ON prov.proveedor_id = p.proveedor_id
    WHERE p.precio > 10000
    );

SELECT 
    *
FROM
    v_proveedores_productos;

-- Vista para mostrar los clientes que realizaron compras igual o superiores a 50000, y como se envio el pedido

CREATE OR REPLACE VIEW v_compras AS
    (SELECT c.nombre as CLIENTE, c.localidad as LOCALIDAD, p.precio_total as TOTAL_COMPRA , p.fecha_pedido, e.detalle_envio as ENVIO
	FROM pedidos p
    JOIN clientes c ON c.cliente_id = p.cliente_id
    JOIN envios e ON p.envio_id = e.envio_id
    WHERE p.precio_total > 10000
    ORDER BY c.cliente_id
    );

SELECT 
    *
FROM
    v_compras;

-- Vista para mostrar cuantos clientes retiraron el pedido en el local

CREATE OR REPLACE VIEW v_retiro_local AS
    (SELECT c.nombre as CLIENTE, c.localidad as LOCALIDAD, p.precio_total as TOTAL, p.fecha_pedido
	FROM clientes c
    JOIN pedidos p ON c.cliente_id = p.cliente_id
    JOIN envios e ON p.envio_id = e.envio_id
    WHERE e.retiro_local = 1
    );

SELECT 
    *
FROM
    v_retiro_local;


-- Vista para mostrar cuantos proveedores con de Cordoba Capital 

CREATE OR REPLACE VIEW v_proveedores_cordoba AS
    (SELECT p.empresa as EMPRESA, p.direccion as Direccion, p.localidad as LOCALIDAD, p.telefono as TELEFONO
	FROM proveedores p
    WHERE localidad LIKE '%Cordoba Capital%'
    );

SELECT 
    *
FROM
    v_proveedores_cordoba;
    

-- Vista para mostrar cuantos clientes abonaron en efectivo

CREATE OR REPLACE VIEW v_compras_efectivo AS
    (SELECT c.nombre as CLIENTE, c.localidad as LOCALIDAD, p.precio_total as TOTAL, p.fecha_pedido
	FROM clientes c
    JOIN pedidos p ON c.cliente_id = p.cliente_id
    JOIN pagos pag ON p.pago_id = pag.pago_id
    WHERE pag.efectivo = 1
    );

SELECT 
    *
FROM
    v_compras_efectivo;
    
-- Funciones
-- Funcion para mostrar el detalle de cada producto (nombre, color, medida)

USE teka_livings;
DELIMITER $$
CREATE FUNCTION detalle_producto (param_nombre VARCHAR(50), param_color VARCHAR(50), param_medida VARCHAR(50))
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
DECLARE mueble_detalle VARCHAR(1000);
SET mueble_detalle = (SELECT CONCAT('Mueble: ', param_nombre, '. ','Color: ', param_color, '. ', 'Medida: ', param_medida, '.'));
RETURN mueble_detalle;
END$$

-- Ejemplo
SELECT detalle_producto('Rack TV','negro con detalles en olmo finlandes', '140 cm');

-- Funcion para mostrar la cantidad de muebles vendidos utilizando el id del producto

USE teka_livings;
DELIMITER $$
CREATE FUNCTION cant_vendida (param_producto_id INT)
RETURNS INT
READS SQL DATA
BEGIN
DECLARE cant_producto INT;
SET cant_producto = 
(
SELECT 
   SUM(cantidad)
FROM
    items
WHERE
    producto_id = param_producto_id 
) ;

RETURN cant_producto;
END$$

-- Ejemplo

SELECT CANT_VENDIDA(1)

-- Stored Procedures
-- SP para ordenar clientes segun el parametro que se pase

USE teka_livings
DELIMITER $$ 
CREATE PROCEDURE `sp_ordenar_clientes` (IN orden VARCHAR (40))
BEGIN
IF orden <> '' THEN 
SET @ordenar = CONCAT('ORDER BY ', orden);
else
SET @ordenar = '';
END IF;

SET @lista = concat ('SELECT * FROM `teka_livings`.`clientes` ', @ordenar);

PREPARE querySQL FROM @lista;
EXECUTE querySQL;
DEALLOCATE PREPARE querySQL;
END$$

-- SP para agregar un nuevo producto

USE  teka_livings
DELIMITER $$
CREATE PROCEDURE `sp_agregar_producto`(IN proveedor_id INT, IN nombre VARCHAR(50), IN precio DECIMAL(20,0), IN color VARCHAR(50), IN medida VARCHAR(50))
BEGIN
	SET @verificar = 0;

	IF nombre = '' THEN
		SET @respuesta = 'SELECT \'ERROR: no se pudo crear el producto indicado\' AS Error';
		SET @verificar = 1;
	ELSE
		SET @respuesta = CONCAT('INSERT INTO `teka_livings`.`productos` (`proveedor_id`,`nombre`, `precio`,`color`,`medida`) VALUES (', '"', proveedor_id, '", "', nombre, '", "', precio, '", "', color, '", "', medida,'")');
		SET @seleccionar = 'SELECT * FROM `teka_livings`.`productos` ORDER BY id DESC';
	END IF;
     
	PREPARE ejecutarSQL FROM @respuesta;
	EXECUTE ejecutarSQL;
	DEALLOCATE PREPARE ejecutarSQL;

	IF @verificar = 1 THEN
		PREPARE seleccionarSQL FROM @seleccionar;
		EXECUTE seleccionarSQL;
		DEALLOCATE PREPARE seleccionarSQL;
	END IF;

END$$