CREATE DATABASE biblioteca;
USE biblioteca;

CREATE TABLE autor(
id_autor INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100) NOT NULL,
nacionalidad VARCHAR(100)
);

CREATE TABLE editorial(
id_editorial INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100) NOT NULL,
pais VARCHAR(100) NOT NULL
);

CREATE TABLE usuario(
id_usuario INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100) NOT NULL,
correo VARCHAR(150) NOT NULL,
fecha_registro DATE NOT NULL
);

CREATE TABLE categoria(
id_categoria INT PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(100) NOT NULL
);

CREATE TABLE libro(
id_libro INT PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(200) NOT NULL,
sinopsis TEXT,
anio_publicacion DATE NOT NULL,

id_autor INT NOT NULL,
id_editorial INT NOT NULL,

FOREIGN KEY (id_autor) REFERENCES autor(id_autor),
FOREIGN KEY (id_editorial) REFERENCES editorial(id_editorial)
);

CREATE TABLE libro_categoria(
id_libro_categora INT AUTO_INCREMENT UNIQUE,

id_libro INT,
id_categoria INT,
    
PRIMARY KEY (id_libro, id_categoria), 

FOREIGN KEY (id_libro) REFERENCES libro(id_libro),
FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE prestamo(
id_prestamo INT PRIMARY KEY AUTO_INCREMENT,
fecha_prestamo DATE,

id_usuario INT NOT NULL,

FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE detalle_prestamo(
id_detalle_prestamo INT AUTO_INCREMENT UNIQUE,
fecha_devolucion DATE NOT NULL,

id_libro INT,
id_prestamo INT,
    
PRIMARY KEY (id_libro, id_prestamo), 

FOREIGN KEY (id_libro) REFERENCES libro(id_libro),
FOREIGN KEY (id_prestamo) REFERENCES prestamo(id_prestamo)
);

-- INSERTS
-- 1. Autores
INSERT INTO autor (nombre, nacionalidad) VALUES
('Gabriel García Márquez', 'Colombiana'),
('Isabel Allende', 'Chilena'),
('Jorge Luis Borges', 'Argentina'),
('Mario Vargas Llosa', 'Peruana'),
('Julio Cortázar', 'Argentina');

-- 2. Editoriales
INSERT INTO editorial (nombre, pais) VALUES
('Alfaguara', 'España'),
('Planeta', 'España'),
('Sudamericana', 'Argentina'),
('Anagrama', 'España'),
('Seix Barral', 'España');

-- 3. Usuarios
INSERT INTO usuario (nombre, correo, fecha_registro) VALUES
('Carlos Pérez', 'carlos@gmail.com', '2024-01-15'),
('María López', 'maria@gmail.com', '2024-02-20'),
('Andrés Torres', 'andres@gmail.com', '2024-03-10'),
('Lucía Ramírez', 'lucia@gmail.com', '2024-04-05'),
('Diego Mora', 'diego@gmail.com', '2025-01-18');

-- 4. Categorías
INSERT INTO categoria (nombre) VALUES
('Realismo Mágico'),
('Novela'),
('Cuento'),
('Ciencia Ficción'),
('Fantasía');

-- 5. Libros
INSERT INTO libro (titulo, sinopsis, anio_publicacion, id_autor, id_editorial) VALUES
('Cien años de soledad', 'La historia de la familia Buendía en Macondo.', '1967-06-05', 1, 3),
('La casa de los espíritus', 'Saga familiar en un país latinoamericano.', '1982-10-01', 2, 2),
('Ficciones', 'Colección de cuentos fantásticos y filosóficos.', '1944-01-01', 3, 3),
('La ciudad y los perros', 'Vida en un colegio militar en Lima.', '1963-10-01', 4, 1),
('Rayuela', 'Una novela experimental de amor en París y Buenos Aires.', '1963-06-28', 5, 3);

-- 6. Libro_categoria
INSERT INTO libro_categoria (id_libro, id_categoria) VALUES
(1, 1), -- Cien años de soledad → Realismo Mágico
(1, 2), -- Cien años de soledad → Novela
(2, 1), -- La casa de los espíritus → Realismo Mágico
(2, 2), -- La casa de los espíritus → Novela
(3, 3), -- Ficciones → Cuento
(3, 5), -- Ficciones → Fantasía
(4, 2), -- La ciudad y los perros → Novela
(5, 2); -- Rayuela → Novela

-- 7. Préstamos
INSERT INTO prestamo (fecha_prestamo, id_usuario) VALUES
('2025-01-10', 1),
('2025-01-15', 2),
('2025-02-01', 3),
('2025-02-14', 1),
('2025-03-05', 4),
('2025-03-20', 2),
('2025-04-01', 5);

-- 8. Detalle_prestamo
INSERT INTO detalle_prestamo (fecha_devolucion, id_libro, id_prestamo) VALUES
('2025-01-20', 1, 1),
('2025-01-25', 2, 2),
('2025-02-10', 3, 3),
('2025-02-25', 4, 4),
('2025-03-15', 5, 5),
('2025-04-01', 1, 6),
('2025-04-15', 3, 7);


-- --------------------------- --
-- Consultas basicas (NIVEL 1) --
-- --------------------------- --

-- Mostrar todos los libros
SELECT * FROM libro;

-- Mostrar títulos y años de publicación
SELECT titulo, anio_publicacion FROM libro;

-- Mostrar usuarios registrados recientemente
SELECT * FROM usuario;


-- -------------- --
-- JOIN (NIVEL 2) --
-- -------------- --

-- Mostrar libros con su autor
SELECT libro.id_libro, libro.titulo, autor.nombre AS Autor
FROM autor 
INNER JOIN libro
ON libro.id_autor = autor.id_autor;

-- Mostrar libros con su editorial
SELECT libro.id_libro, libro.titulo, editorial.nombre AS Editorial
FROM editorial 
INNER JOIN libro
ON libro.id_editorial = editorial.id_editorial;

-- Mostrar categorías de cada libro
SELECT libro.id_libro, libro.titulo, categoria.nombre AS Categoria
FROM libro
INNER JOIN libro_categoria
ON libro.id_libro = libro_categoria.id_libro        
INNER JOIN categoria
ON libro_categoria.id_categoria = categoria.id_categoria;  


-- ------------------------ --
-- JOIN múltiples (NIVEL 3) --
-- ------------------------ --

-- Mostrar todos los préstamos con nombre de usuario y libro
SELECT libro.titulo AS Libro, usuario.nombre AS Usuario
FROM libro
INNER JOIN detalle_prestamo
ON libro.id_libro = detalle_prestamo.id_libro        
INNER JOIN prestamo                                       
ON detalle_prestamo.id_prestamo = prestamo.id_prestamo     
INNER JOIN usuario
ON prestamo.id_usuario = usuario.id_usuario;              

-- Mostrar libros no devueltos
ALTER TABLE detalle_prestamo 
ADD COLUMN devuelto BOOLEAN DEFAULT FALSE;

SELECT libro.titulo AS Libro, usuario.nombre AS Usuario
FROM libro
INNER JOIN detalle_prestamo
ON libro.id_libro = detalle_prestamo.id_libro      
INNER JOIN prestamo
ON detalle_prestamo.id_prestamo = prestamo.id_prestamo    
INNER JOIN usuario
ON prestamo.id_usuario = usuario.id_usuario
WHERE detalle_prestamo.devuelto = FALSE;

-- Mostrar historial completo de préstamos
SELECT usuario.nombre AS Usuario, libro.titulo AS Libro, prestamo.fecha_prestamo AS Fecha_Prestamo, detalle_prestamo.fecha_devolucion AS Fecha_Devolucion
FROM prestamo
INNER JOIN usuario
ON prestamo.id_usuario = usuario.id_usuario
INNER JOIN detalle_prestamo
ON prestamo.id_prestamo = detalle_prestamo.id_prestamo
INNER JOIN libro
ON detalle_prestamo.id_libro = libro.id_libro;


-- ---------------------- --
-- Agregaciones (NIVEL 4) --
-- ---------------------- --

-- Cantidad de libros por categoría
SELECT categoria.nombre AS Categoria, COUNT(libro_categoria.id_libro) AS Cantidad
FROM categoria
INNER JOIN libro_categoria
ON categoria.id_categoria = libro_categoria.id_categoria
GROUP BY categoria.nombre;

-- Cantidad de préstamos por usuario
SELECT usuario.nombre, COUNT(prestamo.id_prestamo) AS "Numero de prestamos"
FROM usuario
INNER JOIN prestamo
ON prestamo.id_usuario = usuario.id_usuario
GROUP BY usuario.nombre; 

-- Cantidad de libros por editorial
SELECT editorial.nombre, COUNT(libro.id_libro) AS "Cantidad libros"
FROM editorial
INNER JOIN libro
ON libro.id_editorial = editorial.id_editorial
GROUP BY editorial.nombre; 

-- ----------------------------- --
-- Consultas avanzadas (NIVEL 5) --
-- ----------------------------- --

-- Usuarios con más préstamos
SELECT usuario.nombre AS Usuario, COUNT(prestamo.id_prestamo) AS "Numero de prestamos"
FROM usuario
INNER JOIN prestamo
ON prestamo.id_usuario = usuario.id_usuario
GROUP BY usuario.nombre
HAVING COUNT(prestamo.id_prestamo) = (
    SELECT MAX(conteo) FROM (
        SELECT COUNT(id_prestamo) AS conteo
        FROM prestamo
        GROUP BY id_usuario
    ) AS subconsulta
);

-- Libro más prestado
SELECT libro.titulo AS Libro, COUNT(detalle_prestamo.id_libro) AS "Veces prestado"
FROM libro
INNER JOIN detalle_prestamo
ON libro.id_libro = detalle_prestamo.id_libro
GROUP BY libro.titulo
HAVING COUNT(detalle_prestamo.id_libro) = (
    SELECT MAX(conteo) FROM (
        SELECT COUNT(id_libro) AS conteo
        FROM detalle_prestamo
        GROUP BY id_libro
    ) AS subconsulta
);

-- Categoría más popular
SELECT categoria.nombre AS Categoria, COUNT(libro_categoria.id_libro) AS "Cantidad de libros"
FROM categoria
INNER JOIN libro_categoria
ON categoria.id_categoria = libro_categoria.id_categoria
GROUP BY categoria.nombre
HAVING COUNT(libro_categoria.id_libro) = (
    SELECT MAX(conteo) FROM (
        SELECT COUNT(id_libro) AS conteo
        FROM libro_categoria
        GROUP BY id_categoria
    ) AS subconsulta
);