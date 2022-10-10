-- Triggers

-- Tabla que registre los clientes que se eliminaron de la DB

USE teka_livings;

CREATE TABLE clientes_eliminados (
cliente_id INT,
nombre VARCHAR (50),
fecha_hora TIMESTAMP,
usuario VARCHAR (50)
);

-- Trigger que almacena que usuario eliminó un cliente de la DB, dia y hora del mismo, despues de que se ejecute el DELETE
DELIMITER $$
CREATE TRIGGER `tr_clientes_eliminados`
AFTER DELETE ON `teka_livings`.`clientes` 
FOR EACH ROW 
INSERT INTO `clientes_eliminados` (cliente_id, nombre, fecha_hora, usuario ) VALUES (OLD.cliente_id, OLD.nombre, CURDATE.TIMESTAMP(), SESSION_USER());
END$$

-- Tabla que registre los nuevos productos que se ingresaron

USE teka_livings;

CREATE TABLE productos_nuevos (
producto_id INT,
nombre VARCHAR (50),
fecha_hora TIMESTAMP,
usuario VARCHAR (50)
);

-- Trigger para registrar los productos nuevos que se agreguen a la DB, con su respetivo usuario, fecha y hora.
DELIMITER $$
CREATE TRIGGER `tr_productos_agregados`
BEFORE INSERT ON `teka_livings`.`productos` 
FOR EACH ROW 
INSERT INTO `productos_nuevos` (producto_id, nombre, fecha_hora, usuario ) VALUES (NEW.producto_id, NEW.nombre, CURDATE.TIMESTAMP(), SESSION_USER());
END$$