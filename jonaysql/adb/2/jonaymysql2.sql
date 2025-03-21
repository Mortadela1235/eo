-- 1. Crear la base de datos con collation utf8mb4_unicode_ci
CREATE DATABASE hospital CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Modificar la base de datos para cambiar su collation a utf8mb4_general_ci
ALTER DATABASE hospital COLLATE = utf8mb4_general_ci;

-- Usar la base de datos hospital
USE hospital;

-- 3. Crear la tabla pacientes
CREATE TABLE pacientes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crear la tabla historias_clinicas, donde cada paciente tiene una única historia clínica
CREATE TABLE historias_clinicas (
    paciente_id INT UNSIGNED,
    diagnostico TEXT NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (paciente_id),
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

-- 5. Modificar la tabla historias_clinicas agregando una columna tratamiento de tipo TEXT
ALTER TABLE historias_clinicas ADD COLUMN tratamiento TEXT;

-- 6. Cambiar el tamaño del campo nombre en la tabla pacientes a 150 caracteres
ALTER TABLE pacientes MODIFY nombre VARCHAR(150) NOT NULL;

-- 7. Agregar una nueva columna telefono de tipo VARCHAR(15) después del campo nombre en pacientes
ALTER TABLE pacientes ADD COLUMN telefono VARCHAR(15) AFTER nombre;

-- 8. Cambiar el tipo de dato de telefono en pacientes para que sea BIGINT
ALTER TABLE pacientes MODIFY telefono BIGINT;

-- 9. Eliminar la columna telefono de la tabla pacientes
ALTER TABLE pacientes DROP COLUMN telefono;

-- 10. Insertar un paciente llamado "Juan Pérez"
INSERT INTO pacientes (nombre) VALUES ('Juan Pérez');

-- 11. Insertar una historia clínica con diagnóstico "Hipertensión" para el paciente "Juan Pérez"
INSERT INTO historias_clinicas (paciente_id, diagnostico)
VALUES ((SELECT id FROM pacientes WHERE nombre = 'Juan Pérez'), 'Hipertensión');

-- 12. Insertar dos pacientes adicionales ("Ana Gómez" y "Carlos Ruiz")
INSERT INTO pacientes (nombre) VALUES ('Ana Gómez'), ('Carlos Ruiz');

-- 13. Añadir historias clínicas para los nuevos pacientes
INSERT INTO historias_clinicas (paciente_id, diagnostico)
VALUES ((SELECT id FROM pacientes WHERE nombre = 'Ana Gómez'), 'Diabetes'),
       ((SELECT id FROM pacientes WHERE nombre = 'Carlos Ruiz'), 'Asma');

-- 14. Consultar todas las historias clínicas junto con el nombre del paciente
SELECT p.nombre, hc.diagnostico, hc.tratamiento, hc.fecha_registro
FROM pacientes p
JOIN historias_clinicas hc ON p.id = hc.paciente_id;

-- 15. Mostrar todos los pacientes que no tienen historia clínica registrada
SELECT *
FROM pacientes
WHERE id NOT IN (SELECT paciente_id FROM historias_clinicas);

-- 16. Actualizar el diagnóstico de "Juan Pérez" a "Hipertensión crónica"
UPDATE historias_clinicas
SET diagnostico = 'Hipertensión crónica'
WHERE paciente_id = (SELECT id FROM pacientes WHERE nombre = 'Juan Pérez');

-- 17. Eliminar la historia clínica de "Carlos Ruiz"
DELETE FROM historias_clinicas
WHERE paciente_id = (SELECT id FROM pacientes WHERE nombre = 'Carlos Ruiz');

-- 18. Consultar la estructura de la tabla historias_clinicas
DESCRIBE historias_clinicas;

-- 19. Eliminar las tablas historias_clinicas y pacientes
DROP TABLE historias_clinicas;
DROP TABLE pacientes;

-- 20. Eliminar la base de datos hospital
DROP DATABASE hospital;