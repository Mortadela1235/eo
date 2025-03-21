-- 1. Crear una base de datos llamada universidad con utf8mb4_unicode_ci.
CREATE DATABASE universidad CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Modifica la base de datos universidad para cambiar su collation a utf8mb4_general_ci.
ALTER DATABASE universidad COLLATE utf8mb4_general_ci;

-- 3. Crea una tabla alumnos con los siguientes campos:
use universidad;
CREATE TABLE alumnos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crea una tabla asignaturas con los siguientes campos:
CREATE TABLE asignaturas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 5. Crea la tabla intermedia matriculas para gestionar la relación muchos a muchos entre alumnos y asignaturas, con los campos:
CREATE TABLE matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_id INT UNSIGNED,
    asignatura_id INT UNSIGNED,
    fecha_matricula DATE NOT NULL,
    FOREIGN KEY (alumno_id) REFERENCES alumnos(id) ON DELETE CASCADE,
    FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id) ON DELETE CASCADE
);

-- 6. Modifica la tabla matriculas para agregar una columna nota de tipo DECIMAL(4,2).
ALTER TABLE matriculas ADD COLUMN nota DECIMAL(4,2);

-- 7. Cambia el tamaño del campo nombre en la tabla asignaturas a 150 caracteres.
ALTER TABLE asignaturas MODIFY COLUMN nombre VARCHAR(150) NOT NULL;

-- 8. Elimina la columna nota de la tabla matriculas.
ALTER TABLE matriculas DROP COLUMN nota;

-- 9. Añade un índice a la columna nombre en asignaturas para mejorar la búsqueda.
CREATE INDEX idx_nombre ON asignaturas(nombre);

-- 10. Inserta un alumno llamado "Luis Gómez".
INSERT INTO alumnos (nombre) VALUES ('Luis Gómez');

-- 11. Añade una asignatura llamada "Matemáticas".
INSERT INTO asignaturas (nombre) VALUES ('Matemáticas');

-- 12. Matricula al alumno en Matemáticas con fecha de matrícula de hoy.
INSERT INTO matriculas (alumno_id, asignatura_id, fecha_matricula)
VALUES ((SELECT id FROM alumnos WHERE nombre = 'Luis Gómez'),
        (SELECT id FROM asignaturas WHERE nombre = 'Matemáticas'),
        CURDATE());

-- 13. Inserta dos alumnos adicionales ("María Fernández" y "Carlos Ruiz").
INSERT INTO alumnos (nombre) VALUES ('María Fernández'), ('Carlos Ruiz');

-- 14. Añade tres asignaturas adicionales ("Física", "Historia", "Química").
INSERT INTO asignaturas (nombre) VALUES ('Física'), ('Historia'), ('Química');

-- 15. Matricula a los alumnos en distintas asignaturas.
INSERT INTO matriculas (alumno_id, asignatura_id, fecha_matricula) VALUES
((SELECT id FROM alumnos WHERE nombre = 'María Fernández'),
 (SELECT id FROM asignaturas WHERE nombre = 'Física'), CURDATE()),
((SELECT id FROM alumnos WHERE nombre = 'Carlos Ruiz'),
 (SELECT id FROM asignaturas WHERE nombre = 'Historia'), CURDATE()),
((SELECT id FROM alumnos WHERE nombre = 'Luis Gómez'),
 (SELECT id FROM asignaturas WHERE nombre = 'Química'), CURDATE());
 
 -- 16. Consulta todas las asignaturas en las que está inscrito el alumno "Luis Gómez".
SELECT asignaturas.nombre FROM asignaturas
JOIN matriculas ON asignaturas.id = matriculas.asignatura_id
JOIN alumnos ON matriculas.alumno_id = alumnos.id
WHERE alumnos.nombre = 'Luis Gómez';

-- 17. Consulta todos los alumnos que están inscritos en la asignatura "Matemáticas".
SELECT alumnos.nombre FROM alumnos
JOIN matriculas ON alumnos.id = matriculas.alumno_id
JOIN asignaturas ON matriculas.asignatura_id = asignaturas.id
WHERE asignaturas.nombre = 'Matemáticas';

-- 18. Elimina la inscripción de un alumno en una asignatura específica.
DELETE FROM matriculas
WHERE alumno_id = (SELECT id FROM alumnos WHERE nombre = 'Luis Gómez')
AND asignatura_id = (SELECT id FROM asignaturas WHERE nombre = 'Matemáticas');

-- 19. Elimina un alumno y sus matrículas asociadas.
DELETE FROM alumnos WHERE nombre = 'Carlos Ruiz';

-- 20. Elimina la base de datos universidad.
DROP DATABASE universidad;