-- Crea una base de datos llamada usuarios_db con utf8mb4_unicode_ci.
CREATE DATABASE usuarios_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE usuarios_db;
-- Modifica la base de datos usuarios_db para cambiar su collation a utf8mb4_general_ci.
ALTER DATABASE usuarios_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- Crea una tabla usuarios con los siguientes campos:
use usuarios_db;
CREATE TABLE usuarios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
-- Crea una tabla direcciones donde cada usuario tiene una única dirección, con los campos:
use usuarios_db;
CREATE TABLE direcciones (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT UNSIGNED UNIQUE,
    direccion VARCHAR(255) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
-- Modifica la tabla direcciones para cambiar la clave primaria y hacer que usuario_id sea clave primaria y clave foránea a la vez.
use usuarios_db;
ALTER TABLE direcciones DROP PRIMARY KEY;
ALTER TABLE direcciones ADD PRIMARY KEY (usuario_id);
-- Cambia el tamaño del campo nombre en la tabla usuarios a 150 caracteres.
use usuarios_db;
ALTER TABLE usuarios MODIFY nombre VARCHAR(150) NOT NULL;
-- Agrega una nueva columna telefono de tipo VARCHAR(15) después del campo nombre en usuarios.
use usuarios_db;
ALTER TABLE usuarios ADD COLUMN telefono VARCHAR(15) AFTER nombre;
-- Cambia el tipo de dato de telefono en usuarios para que sea BIGINT.
use usuarios_db;
ALTER TABLE usuarios MODIFY telefono BIGINT;
-- Elimina la columna telefono de la tabla usuarios.
use usuarios_db;
ALTER TABLE usuarios DROP COLUMN telefono;
-- Inserta un usuario llamado "Juan Pérez".
use usuarios_db;
INSERT INTO usuarios (nombre) VALUES ('Juan Pérez');
-- Inserta una dirección "Calle Mayor 123" para el usuario "Juan Pérez".
use usuarios_db;
INSERT INTO direcciones (usuario_id, direccion)
VALUES ((SELECT id FROM usuarios WHERE nombre = 'Juan Pérez'), 'Calle Mayor 123');
-- Inserta dos usuarios adicionales ("Ana Gómez" y "Carlos Ruiz").
use usuarios_db;
INSERT INTO usuarios (nombre) VALUES ('Ana Gómez'), ('Carlos Ruiz');
-- Añade direcciones para los nuevos usuarios.
use usuarios_db;
INSERT INTO direcciones (usuario_id, direccion)
VALUES ((SELECT id FROM usuarios WHERE nombre = 'Ana Gómez'), 'Avenida Libertad 456'),
       ((SELECT id FROM usuarios WHERE nombre = 'Carlos Ruiz'), 'Calle Secundaria 789');
-- Consulta todas las direcciones junto con el nombre del usuario.
use usuarios_db;
SELECT u.nombre, d.direccion FROM usuarios u
LEFT JOIN direcciones d ON u.id = d.usuario_id;
-- Muestra todos los usuarios que no tienen dirección registrada.
use usuarios_db;
SELECT * FROM usuarios WHERE id NOT IN (SELECT usuario_id FROM direcciones);
-- Actualiza la dirección de "Juan Pérez" a "Avenida Central 456".
use usuarios_db;
UPDATE direcciones SET direccion = 'Avenida Central 456' 
WHERE usuario_id = (SELECT id FROM usuarios WHERE nombre = 'Juan Pérez');
-- Elimina la dirección de "Carlos Ruiz".
use usuarios_db;
DELETE FROM direcciones WHERE usuario_id = (SELECT id FROM usuarios WHERE nombre = 'Carlos Ruiz');
-- Consulta la estructura de la tabla direcciones.
use usuarios_db;
DESCRIBE direcciones;
-- Elimina las tablas direcciones y usuarios.
use usuarios_db;
DROP TABLE direcciones;
DROP TABLE usuarios;
-- Elimina la base de datos usuarios_db.
use usuarios_db;
DROP DATABASE usuarios_db;