--Tabla que contiene informacion de los clientes registrados y les asigna un ID
DROP TABLE IF EXISTS clientes;
CREATE TABLE clientes
(	
	id SERIAL,
	rut VARCHAR(255),
	email VARCHAR(255),
	password VARCHAR(255),
		CONSTRAINT pk_clientes PRIMARY KEY(id)
);

INSERT INTO clientes (id,rut,email,password)
VALUES (default,'192745357','s.marambiosandoval@gmail.com','cerezasverdes'),
(default,'182745357','cammamarambiop@gmail.com','cerezasazules'),
(default,'172745357','zhinus.manshadi@gmail.com','cerezasrojas'),
(default,'162745357','joseperez@gmail.com','cerezasamarillas'),
(default,'152745357','pedrourdemales@gmail.com','cerezasnaranja');


--Tabla que contiene base de datos con las caracteristicas de cada producto a la venta
DROP TABLE IF EXISTS productos;
CREATE TABLE productos
(
	id INTEGER,
	precio INTEGER,
	nombre VARCHAR(255),
		CONSTRAINT pk_productos PRIMARY KEY(id)
);

INSERT INTO productos (id,precio,nombre)
VALUES (1000,8100,'Naruto tomo 1'),
(1001,8200,'Naruto tomo 2'),
(2007,12100,'La casa en el confín de la Tierra'),
(3001,15100,'Harry Potter y la Piedra Filosofal'),
(3002,15200,'Harry Potter y la Camara de los Secretos')
;

--Tabla que documenta las existencias
DROP TABLE IF EXISTS stock;
CREATE TABLE stock
(
	id SERIAL,
	id_producto INTEGER,
	cantidad INTEGER,
		CONSTRAINT pk_stock PRIMARY KEY(id),
		CONSTRAINT fk_stock_idp FOREIGN KEY (id_producto)
			REFERENCES productos (id) MATCH SIMPLE
);

INSERT INTO stock (id,id_producto,cantidad)
VALUES (default,1000,500),
(default,1001,1000),
(default,2007,800),
(default,3001,600),
(default,3002,200);


--Tabla en la que se van insertando las facturas
DROP TABLE IF EXISTS facturas;
CREATE TABLE facturas
(
	id SERIAL,
	id_cliente INTEGER,
	id_producto INTEGER,
	cantidad INTEGER,
	fecha DATE,
		CONSTRAINT pk_facturas PRIMARY KEY(id),
		CONSTRAINT fk_facturas_idp FOREIGN KEY (id_producto)
			REFERENCES productos (id) MATCH SIMPLE,
		CONSTRAINT fk_facturas_idc FOREIGN KEY (id_cliente)
			REFERENCES clientes (id) MATCH SIMPLE
);


INSERT INTO facturas (id,id_cliente, id_producto,cantidad,fecha)
VALUES (default,1,1000,4,'2022-5-27'),
(default,2,1001,6,'2022-11-6'),
(default,3,2007,8,'2019-12-3'),
(default,4,3001,22,'2018-12-14'),
(default,5,3002,10,'2021-11-6');

--Consulta para actualizar precio de productos a un 20% de descuento
update productos set precio = precio*0.8 where id = 1000;
update productos set precio = precio*0.8 where id = 1001;
update productos set precio = precio*0.8 where id = 2007;
update productos set precio = precio*0.8 where id = 3001;
update productos set precio = precio*0.8 where id = 3002;

-- Consulta que sirve para listar el stock de un producto por debajo e un limite critico(en vez de 5 puse 300)
SELECT p.nombre, s.cantidad
FROM productos as p, stock s
WHERE p.id=s.id_producto
AND s.cantidad<300

--Para iniciar una comprar primero se inserta los datos de esta en la tabla facturas.
INSERT INTO facturas (id,id_cliente, id_producto,cantidad,fecha)
VALUES (default,3,1000,6,current_timestamp),
(default,2,2007,8,current_timestamp),
(default,5,3001,1,current_timestamp);

--Luego consultamos los datos de las nuevas compras para obtener detalles y precios finales
SELECT f.id AS id_factura, 
p.nombre, 
p.precio*f.cantidad AS subtotal, 
ROUND(p.precio * f.cantidad*0.19) AS IVA,
ROUND((p.precio*f.cantidad+p.precio*f.cantidad*0.19)) AS precio_masIVA,
f.fecha
FROM facturas AS f, productos AS p
WHERE f.id_producto=p.id
AND f.id IN (6,7,8)
ORDER BY id_factura 

--Extraemos el mes de la columna fecha y podemos consultar las ventas de un mes en especifico en este caso el 12

SELECT f.id AS id_factura, 
p.nombre, 
p.precio*f.cantidad AS subtotal, 
ROUND(p.precio * f.cantidad*0.19) AS IVA,
ROUND((p.precio*f.cantidad+p.precio*f.cantidad*0.19)) AS precio_masIVA,
f.fecha
FROM facturas AS f, productos AS p
WHERE f.id_producto=p.id 
AND EXTRACT(MONTH FROM f.fecha) = 12
ORDER BY id_factura 

--Listamos al usuario que mas compras realizo el 2022

SELECT c.rut, COUNT(f.id) as numero_compras
FROM clientes AS c, facturas AS f
WHERE c.id=f.id 
AND EXTRACT(YEAR FROM f.fecha) = 2022
GROUP BY c.rut
ORDER BY COUNT(f.id) DESC LIMIT 1

