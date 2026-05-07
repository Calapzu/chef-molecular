-- =============================================
-- DATOS: Escenarios y Recetas Base
-- =============================================

USE chef_molecular;

-- Escenarios iniciales
INSERT INTO escenario (nombre, descripcion, orden, estrellas_requeridas) VALUES
('La Cocina Molecular',  'Introducción a la química de los alimentos y sus transformaciones básicas.', 1, 0),
('Emulsiones y Espumas', 'Aprende a crear texturas únicas mediante técnicas de emulsificación.',        2, 3),
('Gelificación',         'Domina el arte de transformar líquidos en geles con diferentes texturas.',    3, 6),
('Esferificación',       'Crea esferas de sabor intenso usando alginato y cloruro de calcio.',          4, 9),
('Nitrógeno Líquido',    'Descubre las posibilidades culinarias del nitrógeno líquido a -196 grados.',  5, 12);

-- Recetas
INSERT INTO receta (id_escenario, nombre, descripcion, ingredientes, pasos, imagen_url, es_opcional) VALUES
(1, 'Huevo a Baja Temperatura', 'Técnica de cocción precisa que preserva la textura sedosa de la yema.', 
 '1 huevo fresco\nAgua a 63 grados Celsius',
 '1. Calentar agua a exactamente 63 grados.\n2. Sumergir el huevo durante 45 minutos.\n3. Retirar y servir inmediatamente.',
 '/img/recetas/huevo_baja_temperatura.png', 0),

(2, 'Mayonesa Molecular', 'Emulsión perfecta con técnicas de cocina molecular.',
 '2 yemas de huevo\n200ml de aceite de oliva\n10ml de jugo de limón\n2g de lecitina de soja\nSal al gusto',
 '1. Mezclar yemas con lecitina.\n2. Agregar aceite en hilo fino mientras se bate.\n3. Emulsionar con batidora de inmersión.',
 '/img/recetas/mayonesa_molecular.png', 0);

SELECT '✅ Escenarios y recetas insertadas' as Mensaje;