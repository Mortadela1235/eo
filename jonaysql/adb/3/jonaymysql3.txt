-- 1. Crear la base de datos biblioteca con utf8mb4_unicode_ci
CREATE DATABASE biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Modificar la collation de la base de datos
ALTER DATABASE biblioteca COLLATE utf8mb4_general_ci;

-- 3. Crear la tabla bibliotecas
CREATE TABLE bibliotecas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crear la tabla libros
CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    biblioteca_id INT UNSIGNED,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    anio_publicacion YEAR NOT NULL,
    FOREIGN KEY (biblioteca_id) REFERENCES bibliotecas(id)
);

-- 5. Modificar la tabla libros para agregar una columna genero
ALTER TABLE libros ADD COLUMN genero VARCHAR(50);

-- 6. Cambiar el tamaño de nombre en bibliotecas a 150 caracteres
ALTER TABLE bibliotecas MODIFY COLUMN nombre VARCHAR(150) NOT NULL;

-- 7. Eliminar la columna genero de libros
ALTER TABLE libros DROP COLUMN genero;

-- 8. Añadir una nueva columna isbn después de titulo en libros
ALTER TABLE libros ADD COLUMN isbn VARCHAR(20) AFTER titulo;

-- 9. Cambiar el tipo de dato de isbn en libros a CHAR(13)
ALTER TABLE libros MODIFY COLUMN isbn CHAR(13);

-- 10. Insertar una biblioteca llamada "Biblioteca Central"
INSERT INTO bibliotecas (nombre) VALUES ('Biblioteca Central');

-- 11. Añadir un libro "El Quijote" de "Miguel de Cervantes" en la Biblioteca Central
INSERT INTO libros (biblioteca_id, titulo, isbn, autor, anio_publicacion) 
VALUES ((SELECT id FROM bibliotecas WHERE nombre = 'Biblioteca Central'), 'El Quijote', '9788491050736', 'Miguel de Cervantes', 1605);

-- 12. Registrar dos libros adicionales en la Biblioteca Central
INSERT INTO libros (biblioteca_id, titulo, isbn, autor, anio_publicacion) 
VALUES ((SELECT id FROM bibliotecas WHERE nombre = 'Biblioteca Central'), 'Cien años de soledad', '9780307474728', 'Gabriel García Márquez', 1967),
       ((SELECT id FROM bibliotecas WHERE nombre = 'Biblioteca Central'), '1984', '9780451524935', 'George Orwell', 1949);

-- 13. Consultar todos los libros con su biblioteca
SELECT libros.*, bibliotecas.nombre AS biblioteca_nombre 
FROM libros 
JOIN bibliotecas ON libros.biblioteca_id = bibliotecas.id;

-- 14. Mostrar todas las bibliotecas sin libros registrados
SELECT * FROM bibliotecas 
WHERE id NOT IN (SELECT DISTINCT biblioteca_id FROM libros);

-- 15. Actualizar el año de publicación de "1984" a 1950
SET SQL_SAFE_UPDATES = 0;
UPDATE libros SET anio_publicacion = 1950 WHERE titulo = '1984';

-- 16. Eliminar un libro con id = 1
DELETE FROM libros WHERE id = 1;

-- 17. Eliminar la Biblioteca Central y todos sus libros
DELETE FROM libros WHERE biblioteca_id = (SELECT id FROM bibliotecas WHERE nombre = 'Biblioteca Central');
DELETE FROM bibliotecas WHERE nombre = 'Biblioteca Central';

-- 18. Consultar la estructura de la tabla libros
SHOW CREATE TABLE libros;

-- 19. Eliminar la tabla libros y bibliotecas
DROP TABLE libros;
DROP TABLE bibliotecas;

-- 20. Eliminar la base de datos biblioteca
DROP DATABASE biblioteca;