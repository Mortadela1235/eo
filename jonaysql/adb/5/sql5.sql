-- 1. Crea una base de datos llamada cine con utf8mb4_unicode_ci.
CREATE DATABASE cine CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Modifica la base de datos cine para cambiar su collation a utf8mb4_general_ci.
ALTER DATABASE cine COLLATE utf8mb4_general_ci;

-- Usar la base de datos cine
USE cine;

-- 3. Crea una tabla actores con los siguientes campos:
CREATE TABLE actores (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crea una tabla peliculas con los siguientes campos:
CREATE TABLE peliculas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    anio_estreno YEAR NOT NULL
);

-- 5. Crea la tabla intermedia actores_peliculas para gestionar la relación muchos a muchos entre actores y peliculas, con los campos:
CREATE TABLE actores_peliculas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    actor_id INT UNSIGNED,
    pelicula_id INT UNSIGNED,
    personaje VARCHAR(100) NOT NULL,
    FOREIGN KEY (actor_id) REFERENCES actores(id) ON DELETE CASCADE,
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id) ON DELETE CASCADE
);

-- 6. Modifica la tabla actores_peliculas para agregar una columna salario de tipo DECIMAL(10,2).
ALTER TABLE actores_peliculas ADD COLUMN salario DECIMAL(10,2);

-- 7. Cambia el tamaño del campo nombre en la tabla actores a 150 caracteres.
ALTER TABLE actores MODIFY COLUMN nombre VARCHAR(150) NOT NULL;

-- 8. Elimina la columna salario de la tabla actores_peliculas.
ALTER TABLE actores_peliculas DROP COLUMN salario;

-- 9. Añade un índice a la columna titulo en peliculas para mejorar la búsqueda.
CREATE INDEX idx_titulo ON peliculas(titulo);

-- 10. Inserta un actor llamado "Leonardo DiCaprio".
INSERT INTO actores (nombre) VALUES ('Leonardo DiCaprio');

-- 11. Añade una película llamada "Titanic" con año de estreno 1997.
INSERT INTO peliculas (titulo, anio_estreno) VALUES ('Titanic', 1997);

-- 12. Registra la participación de "Leonardo DiCaprio" en "Titanic" como el personaje "Jack Dawson".
INSERT INTO actores_peliculas (actor_id, pelicula_id, personaje)
VALUES (
    (SELECT id FROM actores WHERE nombre = 'Leonardo DiCaprio'),
    (SELECT id FROM peliculas WHERE titulo = 'Titanic'),
    'Jack Dawson'
);

-- 13. Inserta dos actores adicionales ("Kate Winslet" y "Tom Hanks").
INSERT INTO actores (nombre) VALUES ('Kate Winslet'), ('Tom Hanks');

-- 14. Añade tres películas adicionales ("Forrest Gump", "Avatar", "Inception").
INSERT INTO peliculas (titulo, anio_estreno) VALUES ('Forrest Gump', 1994), ('Avatar', 2009), ('Inception', 2010);

-- 15. Registra la participación de actores en distintas películas.
INSERT INTO actores_peliculas (actor_id, pelicula_id, personaje) VALUES
(
    (SELECT id FROM actores WHERE nombre = 'Kate Winslet'),
    (SELECT id FROM peliculas WHERE titulo = 'Titanic'),
    'Rose DeWitt Bukater'
),
(
    (SELECT id FROM actores WHERE nombre = 'Tom Hanks'),
    (SELECT id FROM peliculas WHERE titulo = 'Forrest Gump'),
    'Forrest Gump'
),
(
    (SELECT id FROM actores WHERE nombre = 'Leonardo DiCaprio'),
    (SELECT id FROM peliculas WHERE titulo = 'Inception'),
    'Dom Cobb'
);

-- 16. Consulta todas las películas en las que ha trabajado "Leonardo DiCaprio".
SELECT peliculas.titulo 
FROM peliculas
JOIN actores_peliculas ON peliculas.id = actores_peliculas.pelicula_id
JOIN actores ON actores_peliculas.actor_id = actores.id
WHERE actores.nombre = 'Leonardo DiCaprio';

-- 17. Consulta todos los actores que han participado en la película "Titanic".
SELECT actores.nombre 
FROM actores
JOIN actores_peliculas ON actores.id = actores_peliculas.actor_id
JOIN peliculas ON actores_peliculas.pelicula_id = peliculas.id
WHERE peliculas.titulo = 'Titanic';

-- 18. Elimina la participación de un actor en una película específica.
DELETE FROM actores_peliculas
WHERE actor_id = (SELECT id FROM actores WHERE nombre = 'Kate Winslet')
AND pelicula_id = (SELECT id FROM peliculas WHERE titulo = 'Titanic');

-- 19. Elimina un actor y sus registros de películas.
DELETE FROM actores WHERE nombre = 'Tom Hanks';

-- 20. Elimina la base de datos cine.
DROP DATABASE cine;
