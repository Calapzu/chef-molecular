-- ============================================================
-- DATOS: ESCENARIOS, RECETAS, INSIGNIAS
-- ============================================================

USE chef_molecular;

-- ------------------------------------------------------------
-- ESCENARIOS
-- ------------------------------------------------------------
INSERT INTO escenario (nombre, descripcion, orden, estrellas_requeridas) VALUES
('La Cocina Fría — Dispersión de London',       'Aprende las fuerzas de dispersión de London en aceites e hidrocarburos.', 1, 0),
('La Sala de Salsas — Dipolo-dipolo',           'Comprende cómo las moléculas polares se atraen entre sí.',               2, 3),
('El Taller del Merengue — Puentes de hidrógeno','Explora los puentes de hidrógeno en agua y proteínas del huevo.',        3, 6),
('El Horno y el Congelador — Estados de la materia','Observa cómo las fuerzas intermoleculares determinan el estado físico.', 4, 9),
('El Bar Molecular — Propiedades de los líquidos','Comprende tensión superficial, viscosidad y capilaridad.',              5, 12),
('La Olla a Presión — Presión de vapor y ebullición','Aprende cómo la presión de vapor determina el punto de ebullición.', 6, 15);

-- ------------------------------------------------------------
-- RECETAS
-- ------------------------------------------------------------
INSERT INTO receta (id_escenario, nombre, descripcion, ingredientes, pasos, imagen_url, es_opcional)
SELECT e.id_escenario, 'Huevo a Baja Temperatura',
       'Técnica de cocción precisa que preserva la textura sedosa de la yema.',
       '1 huevo fresco\nAgua a 63 °C',
       '1. Calentar agua a exactamente 63 °C.\n2. Sumergir el huevo durante 45 min.\n3. Retirar y servir.',
       '/img/recetas/huevo_baja_temperatura.png', 0
FROM escenario e WHERE e.orden = 1
UNION ALL
SELECT e.id_escenario, 'Mayonesa Molecular',
       'Emulsión perfecta con técnicas de cocina molecular.',
       '2 yemas de huevo\n200 ml aceite de oliva\n10 ml jugo de limón\n2 g lecitina de soja\nSal',
       '1. Mezclar yemas con lecitina.\n2. Agregar aceite en hilo fino batiendo.\n3. Incorporar limón y sal.\n4. Emulsionar con batidora.',
       '/img/recetas/mayonesa_molecular.png', 0
FROM escenario e WHERE e.orden = 2
UNION ALL
SELECT e.id_escenario, 'Gel de Mango con Agar',
       'Gel transparente de mango con textura firme y sabor intenso.',
       '300 ml jugo de mango\n3 g agar-agar\n20 g azúcar',
       '1. Calentar jugo con azúcar.\n2. Disolver el agar-agar en caliente.\n3. Verter en moldes, enfriar.\n4. Refrigerar 30 min.',
       '/img/recetas/gel_mango.png', 0
FROM escenario e WHERE e.orden = 3
UNION ALL
SELECT e.id_escenario, 'Esferas de Aceite de Oliva',
       'Esferas de aceite de oliva virgen extra con membrana de alginato.',
       '100 ml aceite de oliva\n2 g alginato de sodio\n500 ml agua\n5 g cloruro de calcio',
       '1. Mezclar aceite con alginato.\n2. Disolver cloruro de calcio en agua fría.\n3. Con jeringa, gotear mezcla en baño de calcio.\n4. Reposar 2 min y enjuagar.',
       '/img/recetas/esferas_aceite.png', 0
FROM escenario e WHERE e.orden = 4
UNION ALL
SELECT e.id_escenario, 'Helado Instantáneo de Vainilla',
       'Helado cremoso preparado al instante con nitrógeno líquido.',
       '500 ml crema de leche\n100 ml leche entera\n80 g azúcar\n1 vaina de vainilla\n500 ml nitrógeno líquido',
       '1. Mezclar crema, leche, azúcar y vainilla en bol metálico.\n2. Verter nitrógeno líquido poco a poco revolviendo.\n3. Continuar hasta obtener textura deseada.\n4. Servir inmediatamente.',
       '/img/recetas/helado_nitrogeno.png', 0
FROM escenario e WHERE e.orden = 5
UNION ALL
SELECT e.id_escenario, 'Caldos Concentrados a Presión',
       'Caldos ricos en colágeno cocinados en olla a presión para extraer sabores profundos.',
       '500 g huesos de res\n1 cebolla\n2 zanahorias\nAgua hasta cubrir\nSal y especias',
       '1. Colocar todos los ingredientes en olla a presión.\n2. Cocinar a alta presión por 45 min.\n3. Liberar presión, colar y reducir si se desea.',
       '/img/recetas/caldo_presion.png', 0
FROM escenario e WHERE e.orden = 6;

-- ------------------------------------------------------------
-- INSIGNIAS
-- ------------------------------------------------------------
INSERT INTO insignia (nombre, descripcion, icono_url, tipo_condicion, valor_condicion, id_escenario_asociado) VALUES
('Maestro London',        'Obtiene 3 estrellas en La Cocina Fría.',              '/img/insignias/maestro_london.png',      'PERFECTO_ESCENARIO', 3, 1),
('Rey Dipolar',           'Obtiene 3 estrellas en La Sala de Salsas.',           '/img/insignias/rey_dipolar.png',         'PERFECTO_ESCENARIO', 3, 2),
('Arquitecto de Puentes', 'Obtiene 3 estrellas en El Taller del Merengue.',      '/img/insignias/arquitecto_puentes.png',  'PERFECTO_ESCENARIO', 3, 3),
('Alquimista de Estados', 'Obtiene 3 estrellas en El Horno y el Congelador.',    '/img/insignias/alquimista_estados.png',  'PERFECTO_ESCENARIO', 3, 4),
('Barman Molecular',      'Obtiene 3 estrellas en El Bar Molecular.',            '/img/insignias/barman_molecular.png',    'PERFECTO_ESCENARIO', 3, 5),
('Chef Estrella',         'Completa todos los escenarios con 3 estrellas.',      '/img/insignias/chef_estrella.png',       'ESTRELLAS_TOTALES',  18, NULL);