-- 1. Crear la base de datos con utf8mb4_unicode_ci
CREATE DATABASE instituto CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Modificar la collation de la base de datos
ALTER DATABASE instituto COLLATE utf8mb4_general_ci;

-- Usar la base de datos
USE instituto;

-- 3. Crear la tabla profesores
CREATE TABLE profesores (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crear la tabla cursos
CREATE TABLE cursos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT NULL
);

-- 5. Crear la tabla intermedia profesores_cursos
CREATE TABLE profesores_cursos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    profesor_id INT UNSIGNED NOT NULL,
    curso_id INT UNSIGNED NOT NULL,
    fecha_asignacion DATE NOT NULL,
    FOREIGN KEY (profesor_id) REFERENCES profesores(id) ON DELETE CASCADE,
    FOREIGN KEY (curso_id) REFERENCES cursos(id) ON DELETE CASCADE
);

-- 6. Agregar la columna horas_clase a profesores_cursos
ALTER TABLE profesores_cursos ADD COLUMN horas_clase INT;

-- 7. Cambiar el tamaño del campo nombre en la tabla cursos a 200 caracteres
ALTER TABLE cursos MODIFY COLUMN nombre VARCHAR(200) NOT NULL;

-- 8. Eliminar la columna horas_clase de profesores_cursos
ALTER TABLE profesores_cursos DROP COLUMN horas_clase;

-- 9. Añadir un índice a la columna nombre en cursos
CREATE INDEX idx_nombre ON cursos(nombre);

-- 10. Insertar un profesor llamado "Juan Pérez"
INSERT INTO profesores (nombre) VALUES ('Juan Pérez');

-- 11. Añadir un curso llamado "Matemáticas"
INSERT INTO cursos (nombre, descripcion) VALUES ('Matemáticas', 'Curso de álgebra y geometría');

-- 12. Asignar el profesor "Juan Pérez" al curso "Matemáticas"
INSERT INTO profesores_cursos (profesor_id, curso_id, fecha_asignacion)
VALUES ((SELECT id FROM profesores WHERE nombre = 'Juan Pérez'),
        (SELECT id FROM cursos WHERE nombre = 'Matemáticas'),
        CURDATE());

-- 13. Insertar dos profesores adicionales
INSERT INTO profesores (nombre) VALUES ('Ana Rodríguez'), ('Luis Gómez');

-- 14. Añadir tres cursos adicionales
INSERT INTO cursos (nombre, descripcion) VALUES
    ('Física', 'Curso de mecánica y termodinámica'),
    ('Historia', 'Curso sobre historia universal'),
    ('Química', 'Curso de química general');

-- 15. Asignar a los profesores a distintos cursos
INSERT INTO profesores_cursos (profesor_id, curso_id, fecha_asignacion) VALUES
    ((SELECT id FROM profesores WHERE nombre = 'Ana Rodríguez'), (SELECT id FROM cursos WHERE nombre = 'Física'), CURDATE()),
    ((SELECT id FROM profesores WHERE nombre = 'Luis Gómez'), (SELECT id FROM cursos WHERE nombre = 'Historia'), CURDATE()),
    ((SELECT id FROM profesores WHERE nombre = 'Juan Pérez'), (SELECT id FROM cursos WHERE nombre = 'Química'), CURDATE());

-- 16. Consultar todos los cursos en los que imparte clases "Juan Pérez"
SELECT c.nombre FROM cursos c
JOIN profesores_cursos pc ON c.id = pc.curso_id
JOIN profesores p ON pc.profesor_id = p.id
WHERE p.nombre = 'Juan Pérez';

-- 17. Consultar todos los profesores que enseñan el curso "Matemáticas"
SELECT p.nombre FROM profesores p
JOIN profesores_cursos pc ON p.id = pc.profesor_id
JOIN cursos c ON pc.curso_id = c.id
WHERE c.nombre = 'Matemáticas';

-- 18. Eliminar la asignación de un profesor en un curso específico
DELETE FROM profesores_cursos WHERE profesor_id = (SELECT id FROM profesores WHERE nombre = 'Ana Rodríguez')
AND curso_id = (SELECT id FROM cursos WHERE nombre = 'Física');

-- 19. Eliminar un profesor y sus registros de cursos
DELETE FROM profesores WHERE nombre = 'Luis Gómez';

-- 20. Eliminar la base de datos instituto
DROP DATABASE instituto;