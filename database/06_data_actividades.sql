USE chef_molecular;

-- ============================================================
-- DATOS PARA ESCENARIO 1 (Drag & Drop Polar/No polar + Fuerzas)
-- ============================================================
-- Actividad 1 (orden 1): Polar / No polar
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'No polar'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario
WHERE e.orden = 1 AND a.orden = 1
UNION ALL SELECT a.id_actividad, 'Polar'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario
WHERE e.orden = 1 AND a.orden = 1;

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, 'Aceite de oliva', c.id_categoria
FROM actividad_interactiva a
JOIN escenario e ON a.id_escenario = e.id_escenario
JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'No polar'
WHERE e.orden = 1 AND a.orden = 1
UNION ALL SELECT a.id_actividad, 'Agua (H₂O)', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'Polar' WHERE e.orden = 1 AND a.orden = 1
UNION ALL SELECT a.id_actividad, 'Octano (C₈H₁₈)', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 1 AND a.orden = 1
UNION ALL SELECT a.id_actividad, 'Etanol (C₂H₅OH)', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'Polar' WHERE e.orden = 1 AND a.orden = 1
UNION ALL SELECT a.id_actividad, 'Hexano', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 1 AND a.orden = 1
UNION ALL SELECT a.id_actividad, 'Metanol (CH₃OH)', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'Polar' WHERE e.orden = 1 AND a.orden = 1;

-- Actividad 2 (orden 2): Tipos de fuerza
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'Fuerza en no polares'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 1 AND a.orden = 2
UNION ALL SELECT a.id_actividad, 'Fuerza en polares'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 1 AND a.orden = 2
UNION ALL SELECT a.id_actividad, 'Fuerza especial'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 1 AND a.orden = 2;

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, 'Dispersión de London', c.id_categoria
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Fuerza en no polares'
WHERE e.orden = 1 AND a.orden = 2
UNION ALL SELECT a.id_actividad, 'Dipolo-dipolo', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Fuerza en polares' WHERE e.orden = 1 AND a.orden = 2
UNION ALL SELECT a.id_actividad, 'Puentes de hidrógeno', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Fuerza especial' WHERE e.orden = 1 AND a.orden = 2;

-- ============================================================
-- DATOS PARA ESCENARIO 2 (Drag & Drop + Match Dipolos)
-- ============================================================
-- Drag & Drop
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'Polar'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario
WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP'
UNION ALL SELECT a.id_actividad, 'No polar'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario
WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP';

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, 'HCl (Ácido clorhídrico)', c.id_categoria
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Polar'
WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP'
UNION ALL SELECT a.id_actividad, 'CO₂ (Dióxido de carbono)', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP'
UNION ALL SELECT a.id_actividad, 'NH₃ (Amoniaco)', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Polar' WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP'
UNION ALL SELECT a.id_actividad, 'CH₄ (Metano)', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP';

-- Match Dipolos
INSERT INTO par_dipolo (id_actividad, extremo_positivo, extremo_negativo)
SELECT a.id_actividad, 'HCl δ⁺', 'HCl δ⁻'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario
WHERE e.orden = 2 AND a.tipo = 'MATCH_DIPOLOS'
UNION ALL SELECT a.id_actividad, 'HF δ⁺', 'HF δ⁻' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'MATCH_DIPOLOS'
UNION ALL SELECT a.id_actividad, 'H₂O δ⁺', 'H₂O δ⁻' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'MATCH_DIPOLOS'
UNION ALL SELECT a.id_actividad, 'NH₃ δ⁺', 'NH₃ δ⁻' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'MATCH_DIPOLOS';

-- ============================================================
-- DATOS PARA ESCENARIO 3 - MATCH_PUENTES_H
-- ============================================================
-- Insertar moléculas
INSERT INTO molecula_puente_h (id_actividad, nombre, atomo, tiene_h, puede_formar)
SELECT a.id_actividad, 'Agua (H₂O)', 'O', 1, 1
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Ácido fluorhídrico (HF)', 'F', 1, 1 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Amoníaco (NH₃)', 'N', 1, 1 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Metano (CH₄)', 'C', 0, 0 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Ácido clorhídrico (HCl)', 'Cl', 1, 0 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Dióxido de carbono (CO₂)', 'C', 0, 0 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3;

-- Pares correctos (puentes de hidrógeno)
INSERT INTO par_puente_h (id_actividad, id_molecula1, id_molecula2)
SELECT a.id_actividad, m1.id_molecula, m2.id_molecula
FROM actividad_interactiva a
JOIN escenario e ON a.id_escenario = e.id_escenario,
     molecula_puente_h m1,
     molecula_puente_h m2
WHERE e.orden = 3
  AND m1.id_actividad = a.id_actividad
  AND m2.id_actividad = a.id_actividad
  AND m1.nombre = 'Agua (H₂O)'   AND m2.nombre = 'Agua (H₂O)'
UNION ALL
SELECT a.id_actividad, m1.id_molecula, m2.id_molecula
FROM actividad_interactiva a
JOIN escenario e ON a.id_escenario = e.id_escenario,
     molecula_puente_h m1,
     molecula_puente_h m2
WHERE e.orden = 3
  AND m1.id_actividad = a.id_actividad
  AND m2.id_actividad = a.id_actividad
  AND m1.nombre = 'Agua (H₂O)'   AND m2.nombre = 'Ácido fluorhídrico (HF)'
UNION ALL
SELECT a.id_actividad, m1.id_molecula, m2.id_molecula
FROM actividad_interactiva a
JOIN escenario e ON a.id_escenario = e.id_escenario,
     molecula_puente_h m1,
     molecula_puente_h m2
WHERE e.orden = 3
  AND m1.id_actividad = a.id_actividad
  AND m2.id_actividad = a.id_actividad
  AND m1.nombre = 'Agua (H₂O)'   AND m2.nombre = 'Amoníaco (NH₃)'
UNION ALL
SELECT a.id_actividad, m1.id_molecula, m2.id_molecula
FROM actividad_interactiva a
JOIN escenario e ON a.id_escenario = e.id_escenario,
     molecula_puente_h m1,
     molecula_puente_h m2
WHERE e.orden = 3
  AND m1.id_actividad = a.id_actividad
  AND m2.id_actividad = a.id_actividad
  AND m1.nombre = 'Ácido fluorhídrico (HF)' AND m2.nombre = 'Ácido fluorhídrico (HF)'
UNION ALL
SELECT a.id_actividad, m1.id_molecula, m2.id_molecula
FROM actividad_interactiva a
JOIN escenario e ON a.id_escenario = e.id_escenario,
     molecula_puente_h m1,
     molecula_puente_h m2
WHERE e.orden = 3
  AND m1.id_actividad = a.id_actividad
  AND m2.id_actividad = a.id_actividad
  AND m1.nombre = 'Ácido fluorhídrico (HF)' AND m2.nombre = 'Amoníaco (NH₃)'
UNION ALL
SELECT a.id_actividad, m1.id_molecula, m2.id_molecula
FROM actividad_interactiva a
JOIN escenario e ON a.id_escenario = e.id_escenario,
     molecula_puente_h m1,
     molecula_puente_h m2
WHERE e.orden = 3
  AND m1.id_actividad = a.id_actividad
  AND m2.id_actividad = a.id_actividad
  AND m1.nombre = 'Amoníaco (NH₃)' AND m2.nombre = 'Amoníaco (NH₃)';

-- ============================================================
-- DATOS PARA ESCENARIO 4 - SIMULACION_ESTADOS
-- ============================================================
INSERT INTO pregunta_simulacion_estados (id_actividad, enunciado, opcion_a, opcion_b, opcion_c, opcion_d, respuesta_correcta, explicacion)
SELECT a.id_actividad,
       '¿En qué estado las partículas tienen mayor energía cinética?',
       'Sólido', 'Líquido', 'Gas', 'Todos igual', 3,
       'En el estado gaseoso las partículas se mueven con mayor velocidad y energía.'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad,
       'Al calentar hielo a 0°C, comienza a fundirse. ¿Qué ocurre con las fuerzas intermoleculares?',
       'Se fortalecen', 'Se debilitan', 'Desaparecen', 'Se mantienen igual', 2,
       'Durante la fusión, la energía térmica vence parcialmente las fuerzas que mantienen el sólido.'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad,
       '¿Por qué el hielo flota en el agua líquida?',
       'Porque es más frío', 'Porque su estructura cristalina es menos densa', 'Porque el agua líquida es más densa que cualquier sólido', 'Porque contiene aire atrapado', 2,
       'El hielo forma una red hexagonal abierta que lo hace menos denso que el agua líquida.'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad,
       '¿Qué determina el punto de fusión de una sustancia?',
       'Su color', 'La intensidad de las fuerzas intermoleculares', 'La presión atmosférica exclusivamente', 'La masa molecular únicamente', 2,
       'A mayor intensidad de fuerzas intermoleculares, mayor temperatura se necesita para fundir.'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad,
       'Si colocas un cubo de hielo en un vaso de agua, ¿qué sucede con el nivel del agua al derretirse?',
       'Aumenta', 'Disminuye', 'Permanece igual', 'Depende de la temperatura', 3,
       'El volumen de agua desplazado por el hielo es igual al volumen del agua líquida resultante (principio de Arquímedes).'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 4;

-- ============================================================
-- DATOS PARA ESCENARIO 5 - IDENTIFICACION_PROPIEDAD
-- ============================================================
INSERT INTO fenomeno_propiedad (id_actividad, descripcion, propiedad_correcta)
SELECT a.id_actividad,
       'Un insecto camina sobre la superficie del agua sin hundirse.',
       'TENSION_SUPERFICIAL'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 5
UNION ALL
SELECT a.id_actividad,
       'La miel fluye lentamente en comparación con el agua.',
       'VISCOSIDAD'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 5
UNION ALL
SELECT a.id_actividad,
       'El agua asciende espontáneamente por un tubo delgado de vidrio.',
       'CAPILARIDAD'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 5;

-- ============================================================
-- DATOS PARA ESCENARIO 6 - SIMULACION_EBULLICION
-- ============================================================
INSERT INTO pregunta_simulacion_ebullicion (id_actividad, parametro_altitud, parametro_presion, enunciado, opcion_a, opcion_b, opcion_c, opcion_d, respuesta_correcta, explicacion)
SELECT a.id_actividad, 0, 1.00,
       'A nivel del mar (1 atm), ¿a qué temperatura hierve el agua?',
       '90 °C', '100 °C', '110 °C', '120 °C', 2,
       'A 1 atmósfera, el agua hierve a 100 °C cuando su presión de vapor iguala la presión atmosférica.'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 6
UNION ALL
SELECT a.id_actividad, 3000, 0.70,
       'En una ciudad a 3000 metros de altitud, la presión atmosférica es menor. ¿El punto de ebullición del agua será?',
       'Mayor que 100 °C', 'Menor que 100 °C', 'Igual que a nivel del mar', 'Depende de la cantidad de agua', 2,
       'A menor presión externa, el agua hierve a menor temperatura, aproximadamente 90 °C a 3000 m.'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 6
UNION ALL
SELECT a.id_actividad, 0, 2.00,
       'En una olla a presión, la presión aumenta al doble de la atmosférica. ¿Qué ocurre con el punto de ebullición del agua?',
       'Disminuye', 'Permanece igual', 'Aumenta', 'El agua no hierve', 3,
       'Al aumentar la presión, se requiere mayor temperatura para que la presión de vapor del agua iguale la presión externa, por lo que el punto de ebullición sube (aprox. 120 °C).'
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 6;

-- ============================================================
-- VERIFICACIÓN FINAL (opcional)
-- ============================================================
SELECT '✅ Datos de actividades cargados correctamente.' AS Estado;
SELECT e.orden, e.nombre, COUNT(ai.id_actividad) AS total_actividades
FROM escenario e
LEFT JOIN actividad_interactiva ai ON e.id_escenario = ai.id_escenario
GROUP BY e.id_escenario
ORDER BY e.orden;