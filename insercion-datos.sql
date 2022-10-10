-- Insercion de datos en cada tabla de la DB

USE teka_livings;

-- Insecion de Datos en tabla Clientes

INSERT INTO clientes (cliente_id,nombre,dni,direccion,localidad,telefono,mail)
VALUES
	(1,"Juan Perez",31256365,"Bv San Juan 254","Cordoba Capital-Cordoba",154223657,"juanperez@gmail.com"),
	(2,"Maria Lopez",22563165,"Los Platanos 1236","Cordoba Capital-Cordoba",153563214,"marialopez@gmail.com"),
	(3,"Jose Lagos",38256471,"La Rioja 589","Villa Allende-Cordoba",153511234,"joselagos@gmail.com"),
	(4,"Rosa Terreno",12563987,"Jose Paz 1236","Las Varillas-Cordoba",112433214,"rosaterreno@gmail.com"),
	(5,"Alberto Fernandez",21363165,"Medanos 587","Villa Maria-Cordoba",353387569,"albertofernandez@gmail.com"),
	(6, "Lucia Paredes",22563165,"Salta 216","Cordoba Capital-Cordoba",153569814,"luciaparedes@gmail.com"),
	(7,"Luis Juarez",13658974,"Martin Garcia 1236","Cordoba Capital-Cordoba",153587214,"luisjuarez@gmail.com"),
	(8,"Maria Jose Racca",35874563,"Buenos Aires 874","Mina Clavero-Cordoba",354789612,"joseracca@gmail.com"),
	(9,"Miguel Garcia",31457893,"9 de Julio 7854","Cordoba Capital-Cordoba",153563212,"miguelgarcia@gmail.com"),
	(10,"Cassandra Lange",14569875,"Lopez de Vega 87","Rio Cuarto-Cordoba",153563214,"cassandralange@gmail.com")
;

-- Insecion de Datos en tabla Envios

INSERT INTO envios (envio_id,transporte,retiro_local,detalle_envio)
VALUES
	(1,0,1,NULL),
	(2,1,0,"Se envia pedido con empresa Alta Cordoba"),
	(3,1,0,"Cliente envia flete para retirar pedido"),
	(4,1,0,"Se envio pedido con empresa El Porvenir"),
	(5,1,0,"Se envia pedido con empresa Flex"),
	(6,1,0,"Se envia pedido con empresa Encomiendas Central"),
	(7,1,0,"Se envia pedido con empresa Andesmar"),
	(8,1,0,"Se envia pedido con empresa Via Cargo"),
	(9,1,0,"Se envia pedido con empresa Atencio Comisiones"),
	(10,1,0,"Se envia pedido con empresa Red Pack")
;

-- Insecion de Datos en tabla Pagos

INSERT INTO pagos (pago_id,tranferencia,tarjeta_credito,efectivo,mercado_pago)
VALUES
	(1,1,0,0,0),
	(2,0,1,0,0),
	(3,0,0,1,0),
	(4,0,0,0,1),
	(5,1,0,0,0),
	(6,1,0,0,0)
;

-- Insecion de Datos en tabla Proveedores

INSERT INTO proveedores (proveedor_id,empresa,telefono,mail,direccion,localidad,cbu_banco
)
VALUES
	(1,"Caon S.R.L.",155426398,"caon@mueble.com.ar","Los Rosedales 123","Capital Federal",123456789),
	(2,"Genoud Foresto Industrial S.A.",1119792632,"genoud@gmail.com","Pampa y la Via 1234","Misiones",123456789),
	(3,"Hanford",15236911,"hanford@equipamientos.com.ar","Sosa Villada 7569","Cordoba Capital",123456789),
	(4,"Novo Equipamiento",125487893,"novoequipamiento@gmail.com","Los Paraisos 23","Cordoba Capital",123456789),
	(5,"Muebles del Centro S.R.L.",1245639871,"contacto@mueblesdelcentro.com.ar","Belgrano 1259","Cordoba Capital",123456789)
;

-- Insecion de Datos en tabla Productos

INSERT INTO productos (producto_id,proveedor_id,nombre,precio,color,medida)
VALUES
	(1,2,"Rack TV",25000,"blanco","1.40 cm"),
	(2,5,"Mesa de Comerdor para 8 personas",75000,"negro",NULL),
	(3,2,"Mesa de luz",15000,"blanco",NULL),
	(4,1,"Sofa esquinero",50000,"beige","1.80x1.20 cm"),
	(5,2,"Silla eames",5000,"negra",NULL),
	(6,2,"Silla eames",5000,"blanca",NULL),
	(7,4,"Biblioteca",20000,"blanco",NULL),
	(8,3,"Escritorio",30000,"negro",NULL),
	(9,2,"Rack TV",25000,"negro","1.20 cm"),
	(10,2,"Sofa individual",30000,"gris",NULL)
;

-- Insecion de Datos en tabla Pedidos

INSERT INTO pedidos (pedidos_id,cliente_id,pago_id,envio_id,seña,fecha_pedido,precio_total)
VALUES
	(1,8,6,1,NULL,"2022-08-28",75000),
	(2,1,5,4,15000,"2022-08-28",115000),
	(3,6,4,2,NULL,"2022-08-28",75000),
	(4,4,3,1,25000,"2022-08-28",55000),
	(5,2,2,6,NULL,"2022-08-28",105000),
	(6,10,1,1,NULL,"2022-08-28",25000)
;

-- Insecion de Datos en tabla Items de Compra

INSERT INTO items (pedidos_id,producto_id,cantidad,subtotal)
VALUES
	(5,2,1,75000),
	(1,7,2,40000),
	(1,2,1,25000),
	(1,4,1,50000),
	(6,5,1,75000),
	(4,1,1,25000),
	(4,8,1,30000),
	(2,10,1,30000),
	(2,1,1,75000),
	(6,9,1,25000)
;
