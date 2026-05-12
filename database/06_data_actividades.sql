-- ============================================================
-- DATOS: ACTIVIDADES INTERACTIVAS Y SUS ELEMENTOS
-- ============================================================

USE chef_molecular;

-- ------------------------------------------------------------
-- ACTIVIDADES (DRAG_AND_DROP, MATCH_DIPOLOS)
-- ------------------------------------------------------------
-- Escenario 1: dos DRAG_AND_DROP
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'DRAG_AND_DROP', 1, 100 FROM escenario WHERE orden = 1;
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'DRAG_AND_DROP', 2, 100 FROM escenario WHERE orden = 1;

-- Escenario 2: DRAG_AND_DROP + MATCH_DIPOLOS
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'DRAG_AND_DROP', 1, 100 FROM escenario WHERE orden = 2;
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'MATCH_DIPOLOS', 2, 100 FROM escenario WHERE orden = 2;

-- Escenario 3: DRAG_AND_DROP
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'DRAG_AND_DROP', 1, 100 FROM escenario WHERE orden = 3;

-- Escenario 4: DRAG_AND_DROP
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'DRAG_AND_DROP', 1, 100 FROM escenario WHERE orden = 4;

-- Escenario 5: DRAG_AND_DROP
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'DRAG_AND_DROP', 1, 100 FROM escenario WHERE orden = 5;

-- Escenario 6: DRAG_AND_DROP
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'DRAG_AND_DROP', 1, 100 FROM escenario WHERE orden = 6;

-- ------------------------------------------------------------
-- ESCENARIO 1 - Actividad 1 (orden 1): Polar / No polar
-- ------------------------------------------------------------
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'No polar' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 1 AND a.orden = 1
UNION ALL
SELECT a.id_actividad, 'Polar'    FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 1 AND a.orden = 1;

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, 'Aceite de oliva',   c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 1 AND a.orden = 1
UNION ALL
SELECT a.id_actividad, 'Agua (H₂O)',        c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'Polar'    WHERE e.orden = 1 AND a.orden = 1
UNION ALL
SELECT a.id_actividad, 'Octano (C₈H₁₈)',   c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 1 AND a.orden = 1
UNION ALL
SELECT a.id_actividad, 'Etanol (C₂H₅OH)',  c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'Polar'    WHERE e.orden = 1 AND a.orden = 1
UNION ALL
SELECT a.id_actividad, 'Hexano',            c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 1 AND a.orden = 1
UNION ALL
SELECT a.id_actividad, 'Metanol (CH₃OH)',   c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON a.id_actividad = c.id_actividad AND c.nombre_categoria = 'Polar'    WHERE e.orden = 1 AND a.orden = 1;

-- ------------------------------------------------------------
-- ESCENARIO 1 - Actividad 2 (orden 2): Tipos de fuerza
-- ------------------------------------------------------------
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'Fuerza en no polares' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 1 AND a.orden = 2
UNION ALL
SELECT a.id_actividad, 'Fuerza en polares'    FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 1 AND a.orden = 2
UNION ALL
SELECT a.id_actividad, 'Fuerza especial'      FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 1 AND a.orden = 2;

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, 'Dispersión de London',  c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Fuerza en no polares' WHERE e.orden = 1 AND a.orden = 2
UNION ALL
SELECT a.id_actividad, 'Dipolo-dipolo',         c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Fuerza en polares'    WHERE e.orden = 1 AND a.orden = 2
UNION ALL
SELECT a.id_actividad, 'Puentes de hidrógeno',  c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Fuerza especial'      WHERE e.orden = 1 AND a.orden = 2;

-- ------------------------------------------------------------
-- ESCENARIO 2 - Actividad 1 (DRAG_AND_DROP): Polar / No polar
-- ------------------------------------------------------------
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'Polar'    FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP'
UNION ALL
SELECT a.id_actividad, 'No polar' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP';

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, 'HCl (Ácido clorhídrico)',    c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Polar'    WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP'
UNION ALL
SELECT a.id_actividad, 'CO₂ (Dióxido de carbono)',   c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP'
UNION ALL
SELECT a.id_actividad, 'NH₃ (Amoniaco)',              c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Polar'    WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP'
UNION ALL
SELECT a.id_actividad, 'CH₄ (Metano)',                c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'No polar' WHERE e.orden = 2 AND a.tipo = 'DRAG_AND_DROP';

-- ------------------------------------------------------------
-- ESCENARIO 2 - Actividad 2 (MATCH_DIPOLOS)
-- ------------------------------------------------------------
INSERT INTO par_dipolo (id_actividad, extremo_positivo, extremo_negativo)
SELECT a.id_actividad, 'HCl δ⁺',  'HCl δ⁻'  FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'MATCH_DIPOLOS'
UNION ALL
SELECT a.id_actividad, 'HF δ⁺',   'HF δ⁻'   FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'MATCH_DIPOLOS'
UNION ALL
SELECT a.id_actividad, 'H₂O δ⁺',  'H₂O δ⁻'  FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'MATCH_DIPOLOS'
UNION ALL
SELECT a.id_actividad, 'NH₃ δ⁺',  'NH₃ δ⁻'  FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 2 AND a.tipo = 'MATCH_DIPOLOS';

-- ------------------------------------------------------------
-- ESCENARIO 3 - DRAG_AND_DROP: Forma / No forma puentes de H
-- ------------------------------------------------------------
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'Forma puentes de hidrógeno'    FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL
SELECT a.id_actividad, 'No forma puentes de hidrógeno' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3;

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, '💧 Agua (H₂O)',          c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Forma puentes de hidrógeno'    WHERE e.orden = 3
UNION ALL
SELECT a.id_actividad, '🥚 Proteínas del huevo', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Forma puentes de hidrógeno'    WHERE e.orden = 3
UNION ALL
SELECT a.id_actividad, '🍬 Sacarosa (azúcar)',   c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Forma puentes de hidrógeno'    WHERE e.orden = 3
UNION ALL
SELECT a.id_actividad, '🫒 Aceite vegetal',      c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'No forma puentes de hidrógeno' WHERE e.orden = 3
UNION ALL
SELECT a.id_actividad, '🕯️ Cera de abeja',      c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'No forma puentes de hidrógeno' WHERE e.orden = 3
UNION ALL
SELECT a.id_actividad, '🧴 Parafina',            c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'No forma puentes de hidrógeno' WHERE e.orden = 3;

-- ------------------------------------------------------------
-- ESCENARIO 4 - DRAG_AND_DROP: Alto / Bajo punto de ebullición
-- ------------------------------------------------------------
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'Alto punto de ebullición' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad, 'Bajo punto de ebullición' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 4;

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, '💧 Agua (H₂O)',         c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alto punto de ebullición' WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad, '🫒 Aceite de oliva',    c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alto punto de ebullición' WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad, '🧪 Glicerina',          c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alto punto de ebullición' WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad, '🍷 Etanol (C₂H₅OH)',   c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Bajo punto de ebullición' WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad, '💊 Acetona',            c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Bajo punto de ebullición' WHERE e.orden = 4
UNION ALL
SELECT a.id_actividad, '⚗️ Éter dietílico',    c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Bajo punto de ebullición' WHERE e.orden = 4;

-- ------------------------------------------------------------
-- ESCENARIO 5 - DRAG_AND_DROP: Alta / Baja viscosidad
-- ------------------------------------------------------------
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'Alta viscosidad' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 5
UNION ALL
SELECT a.id_actividad, 'Baja viscosidad' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 5;

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, '🍯 Miel',              c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alta viscosidad' WHERE e.orden = 5
UNION ALL
SELECT a.id_actividad, '🍁 Jarabe de arce',   c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alta viscosidad' WHERE e.orden = 5
UNION ALL
SELECT a.id_actividad, '🍫 Licor de chocolate', c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alta viscosidad' WHERE e.orden = 5
UNION ALL
SELECT a.id_actividad, '💧 Agua',             c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Baja viscosidad' WHERE e.orden = 5
UNION ALL
SELECT a.id_actividad, '🍋 Jugo de limón',    c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Baja viscosidad' WHERE e.orden = 5
UNION ALL
SELECT a.id_actividad, '🥃 Ron blanco',       c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Baja viscosidad' WHERE e.orden = 5;

-- ------------------------------------------------------------
-- ESCENARIO 6 - DRAG_AND_DROP: Alto / Bajo punto de ebullición
-- ------------------------------------------------------------
INSERT INTO categoria_actividad (id_actividad, nombre_categoria)
SELECT a.id_actividad, 'Alto punto de ebullición' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 6
UNION ALL
SELECT a.id_actividad, 'Bajo punto de ebullición' FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 6;

INSERT INTO elemento_arrastrable (id_actividad, nombre, id_categoria)
SELECT a.id_actividad, '💧 Agua (H₂O)',         c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alto punto de ebullición' WHERE e.orden = 6
UNION ALL
SELECT a.id_actividad, '🫒 Aceite de oliva',    c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alto punto de ebullición' WHERE e.orden = 6
UNION ALL
SELECT a.id_actividad, '🧪 Glicerina',          c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Alto punto de ebullición' WHERE e.orden = 6
UNION ALL
SELECT a.id_actividad, '🍷 Etanol (C₂H₅OH)',   c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Bajo punto de ebullición' WHERE e.orden = 6
UNION ALL
SELECT a.id_actividad, '💊 Acetona',            c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Bajo punto de ebullición' WHERE e.orden = 6
UNION ALL
SELECT a.id_actividad, '⚗️ Éter dietílico',    c.id_categoria FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario JOIN categoria_actividad c ON c.id_actividad = a.id_actividad AND c.nombre_categoria = 'Bajo punto de ebullición' WHERE e.orden = 6;