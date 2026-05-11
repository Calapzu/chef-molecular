-- ============================================================
-- CHEF MOLECULAR - BASE DE DATOS DEFINITIVA
-- Actividades variadas para cada escenario
-- ============================================================

DROP DATABASE IF EXISTS chef_molecular;
CREATE DATABASE chef_molecular
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE chef_molecular;

-- ------------------------------------------------------------
-- PROCEDIMIENTO ÍNDICES SEGUROS
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS create_index_safe;
DELIMITER $$
CREATE PROCEDURE create_index_safe(
    IN p_table_name  VARCHAR(64),
    IN p_index_name  VARCHAR(64),
    IN p_index_def   TEXT
)
BEGIN
    DECLARE index_exists INT DEFAULT 0;
    SELECT COUNT(*) INTO index_exists
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_table_name
      AND INDEX_NAME = p_index_name;
    IF index_exists = 0 THEN
        SET @sql = CONCAT('CREATE INDEX ', p_index_name, ' ON ', p_table_name, ' ', p_index_def);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END $$
DELIMITER ;

-- ------------------------------------------------------------
-- TABLAS PRINCIPALES
-- ------------------------------------------------------------
CREATE TABLE estudiante (
    id_estudiante     INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo   VARCHAR(100) NOT NULL,
    correo            VARCHAR(100) NOT NULL UNIQUE,
    password_hash     VARCHAR(255) NOT NULL,
    rango             ENUM('APRENDIZ','SOUS_CHEF','CHEF','CHEF_MOLECULAR_ESTRELLA') NOT NULL DEFAULT 'APRENDIZ',
    total_estrellas   INT NOT NULL DEFAULT 0,
    fecha_registro    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_en         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    version           INT NOT NULL DEFAULT 0
);

CREATE TABLE sesion (
    id_sesion         INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante     INT NOT NULL,
    token             VARCHAR(255) NOT NULL UNIQUE,
    fecha_inicio      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion  DATETIME NOT NULL,
    activa            TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_sesion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante) ON DELETE CASCADE
);

CREATE TABLE escenario (
    id_escenario          INT AUTO_INCREMENT PRIMARY KEY,
    nombre                VARCHAR(100) NOT NULL,
    descripcion           TEXT,
    orden                 INT NOT NULL DEFAULT 1,
    estrellas_requeridas  INT NOT NULL DEFAULT 0
);

CREATE TABLE progreso_escenario (
    id_progreso       INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante     INT NOT NULL,
    id_escenario      INT NOT NULL,
    estrellas         INT NOT NULL DEFAULT 0,
    completado        TINYINT(1) NOT NULL DEFAULT 0,
    desbloqueado      TINYINT(1) NOT NULL DEFAULT 0,
    intentos          INT NOT NULL DEFAULT 0,
    fecha_completado  DATETIME,
    creado_en         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    version           INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_estrellas CHECK (estrellas >= 0 AND estrellas <= 3),
    CONSTRAINT fk_progreso_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    CONSTRAINT fk_progreso_escenario FOREIGN KEY (id_escenario)
        REFERENCES escenario(id_escenario) ON DELETE CASCADE,
    CONSTRAINT uq_progreso UNIQUE (id_estudiante, id_escenario)
);

CREATE TABLE actividad_interactiva (
    id_actividad  INT AUTO_INCREMENT PRIMARY KEY,
    id_escenario  INT NOT NULL,
    tipo          ENUM('EXPERIMENTO_VIRTUAL','DRAG_AND_DROP','CONSTRUCCION_MOLECULAR','CLASIFICACION',
                       'SIMULACION_DESLIZADOR','MATCH_DIPOLOS','MATCH_PUENTES_H',
                       'SIMULACION_ESTADOS','IDENTIFICACION_PROPIEDAD','SIMULACION_EBULLICION') NOT NULL,
    orden         INT NOT NULL DEFAULT 1,
    peso_puntaje  INT NOT NULL DEFAULT 100,
    CONSTRAINT fk_actividad_escenario FOREIGN KEY (id_escenario)
        REFERENCES escenario(id_escenario) ON DELETE CASCADE
);

CREATE TABLE categoria_actividad (
    id_categoria     INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad     INT NOT NULL,
    nombre_categoria VARCHAR(100) NOT NULL,
    CONSTRAINT fk_categoria_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE,
    UNIQUE KEY uq_categoria_actividad (id_actividad, nombre_categoria)
);

CREATE TABLE elemento_arrastrable (
    id_elemento   INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad  INT NOT NULL,
    nombre        VARCHAR(100) NOT NULL,
    id_categoria  INT NOT NULL,
    CONSTRAINT fk_elemento_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE,
    CONSTRAINT fk_elemento_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria_actividad(id_categoria) ON DELETE CASCADE
);

CREATE TABLE pieza_molecular (
    id_pieza      INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad  INT NOT NULL,
    nombre        VARCHAR(100) NOT NULL,
    formula       VARCHAR(50),
    color         VARCHAR(20),
    CONSTRAINT fk_pieza_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE
);

CREATE TABLE resultado_actividad (
    id_resultado      INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad      INT NOT NULL,
    id_estudiante     INT NOT NULL,
    id_progreso       INT NOT NULL,
    correctos         INT NOT NULL DEFAULT 0,
    incorrectos       INT NOT NULL DEFAULT 0,
    puntaje_obtenido  INT NOT NULL DEFAULT 0,
    completado        TINYINT(1) NOT NULL DEFAULT 0,
    creado_en         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_resultado_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE,
    CONSTRAINT fk_resultado_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    CONSTRAINT fk_resultado_progreso FOREIGN KEY (id_progreso)
        REFERENCES progreso_escenario(id_progreso) ON DELETE CASCADE
);

CREATE TABLE cuestionario (
    id_cuestionario        INT AUTO_INCREMENT PRIMARY KEY,
    id_escenario           INT NOT NULL UNIQUE,
    total_preguntas        INT NOT NULL DEFAULT 0,
    intentos_permitidos    INT NOT NULL DEFAULT 3,
    tiempo_limite_minutos  INT NOT NULL DEFAULT 30,
    CONSTRAINT fk_cuestionario_escenario FOREIGN KEY (id_escenario)
        REFERENCES escenario(id_escenario) ON DELETE CASCADE
);

CREATE TABLE pregunta (
    id_pregunta        INT AUTO_INCREMENT PRIMARY KEY,
    id_cuestionario    INT NOT NULL,
    enunciado          TEXT NOT NULL,
    opcion_a           VARCHAR(255) NOT NULL,
    opcion_b           VARCHAR(255) NOT NULL,
    opcion_c           VARCHAR(255) NOT NULL,
    opcion_d           VARCHAR(255) NOT NULL,
    respuesta_correcta TINYINT NOT NULL COMMENT '1=A 2=B 3=C 4=D',
    explicacion        TEXT,
    peso_puntaje       INT NOT NULL DEFAULT 25,
    CONSTRAINT fk_pregunta_cuestionario FOREIGN KEY (id_cuestionario)
        REFERENCES cuestionario(id_cuestionario) ON DELETE CASCADE
);

CREATE TABLE retroalimentacion (
    id_retroalimentacion   INT AUTO_INCREMENT PRIMARY KEY,
    id_pregunta            INT NOT NULL UNIQUE,
    explicacion_correcta   TEXT NOT NULL,
    explicacion_incorrecta TEXT NOT NULL,
    CONSTRAINT fk_retroalimentacion_pregunta FOREIGN KEY (id_pregunta)
        REFERENCES pregunta(id_pregunta) ON DELETE CASCADE
);

CREATE TABLE intento_cuestionario (
    id_intento            INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante         INT NOT NULL,
    id_cuestionario       INT NOT NULL,
    numero_intento        INT NOT NULL DEFAULT 1,
    puntaje_obtenido      INT NOT NULL DEFAULT 0,
    respuestas_correctas  INT NOT NULL DEFAULT 0,
    tiempo_utilizado      INT NOT NULL DEFAULT 0 COMMENT 'en segundos',
    fecha_inicio          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin             DATETIME,
    completado            TINYINT(1) NOT NULL DEFAULT 0,
    creado_en             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    version               INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_intento_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    CONSTRAINT fk_intento_cuestionario FOREIGN KEY (id_cuestionario)
        REFERENCES cuestionario(id_cuestionario) ON DELETE CASCADE
);

CREATE TABLE respuesta_estudiante (
    id_respuesta         INT AUTO_INCREMENT PRIMARY KEY,
    id_intento           INT NOT NULL,
    id_pregunta          INT NOT NULL,
    opcion_seleccionada  TINYINT NOT NULL COMMENT '1=A 2=B 3=C 4=D',
    es_correcta          TINYINT(1) NOT NULL DEFAULT 0,
    tiempo_respuesta     INT NOT NULL DEFAULT 0 COMMENT 'en segundos',
    fecha_respuesta      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_respuesta_intento FOREIGN KEY (id_intento)
        REFERENCES intento_cuestionario(id_intento) ON DELETE CASCADE,
    CONSTRAINT fk_respuesta_pregunta FOREIGN KEY (id_pregunta)
        REFERENCES pregunta(id_pregunta) ON DELETE CASCADE
);

CREATE TABLE insignia (
    id_insignia            INT AUTO_INCREMENT PRIMARY KEY,
    nombre                 VARCHAR(100) NOT NULL,
    descripcion            TEXT,
    icono_url              VARCHAR(255),
    tipo_condicion         ENUM('ESTRELLAS_TOTALES','ESCENARIOS_COMPLETADOS','RANGO','RECETAS_DESBLOQUEADAS','PERFECTO_ESCENARIO') NOT NULL,
    valor_condicion        INT NOT NULL DEFAULT 0,
    id_escenario_asociado  INT,
    CONSTRAINT fk_insignia_escenario FOREIGN KEY (id_escenario_asociado)
        REFERENCES escenario(id_escenario) ON DELETE SET NULL
);

CREATE TABLE insignia_estudiante (
    id_insignia_estudiante  INT AUTO_INCREMENT PRIMARY KEY,
    id_insignia             INT NOT NULL,
    id_estudiante           INT NOT NULL,
    fecha_obtencion         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notificada              TINYINT(1) NOT NULL DEFAULT 0,
    creado_en               DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    version                 INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_insignia_est_insignia FOREIGN KEY (id_insignia)
        REFERENCES insignia(id_insignia) ON DELETE CASCADE,
    CONSTRAINT fk_insignia_est_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    CONSTRAINT uq_insignia_estudiante UNIQUE (id_insignia, id_estudiante)
);

CREATE TABLE receta (
    id_receta     INT AUTO_INCREMENT PRIMARY KEY,
    id_escenario  INT NOT NULL,
    nombre        VARCHAR(100) NOT NULL,
    descripcion   TEXT,
    ingredientes  TEXT,
    pasos         TEXT,
    imagen_url    VARCHAR(255),
    es_opcional   TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_receta_escenario FOREIGN KEY (id_escenario)
        REFERENCES escenario(id_escenario) ON DELETE CASCADE
);

CREATE TABLE receta_estudiante (
    id_receta_estudiante   INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante          INT NOT NULL,
    id_receta              INT NOT NULL,
    fecha_desbloqueo       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_consulta  DATETIME,
    veces_vista            INT NOT NULL DEFAULT 0,
    creado_en              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    version                INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_receta_est_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    CONSTRAINT fk_receta_est_receta FOREIGN KEY (id_receta)
        REFERENCES receta(id_receta) ON DELETE CASCADE,
    CONSTRAINT uq_receta_estudiante UNIQUE (id_estudiante, id_receta)
);

-- ============================================================
-- NUEVAS TABLAS PARA LAS ACTIVIDADES VARIADAS
-- ============================================================

-- Para MATCH_PUENTES_H (Escenario 3)
CREATE TABLE molecula_puente_h (
    id_molecula  INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad INT NOT NULL,
    nombre       VARCHAR(100) NOT NULL,
    atomo        VARCHAR(10) NOT NULL COMMENT 'Átomo electronegativo (O, N, F, Cl, C...)',
    tiene_h      TINYINT(1) NOT NULL DEFAULT 0,
    puede_formar TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Si cumple condiciones para puente H',
    CONSTRAINT fk_molecula_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE
);

CREATE TABLE par_puente_h (
    id_par       INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad INT NOT NULL,
    id_molecula1 INT NOT NULL,
    id_molecula2 INT NOT NULL,
    CONSTRAINT fk_par_actividad_puente FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE,
    CONSTRAINT fk_par_mol1 FOREIGN KEY (id_molecula1)
        REFERENCES molecula_puente_h(id_molecula) ON DELETE CASCADE,
    CONSTRAINT fk_par_mol2 FOREIGN KEY (id_molecula2)
        REFERENCES molecula_puente_h(id_molecula) ON DELETE CASCADE
);

-- Para MATCH_DIPOLOS (Escenario 2) – ya existía, pero asegurémonos
CREATE TABLE IF NOT EXISTS par_dipolo (
    id_par INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad INT NOT NULL,
    extremo_positivo VARCHAR(100) NOT NULL,
    extremo_negativo VARCHAR(100) NOT NULL,
    CONSTRAINT fk_par_dipolo_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE
);

-- Para SIMULACION_ESTADOS (Escenario 4)
CREATE TABLE pregunta_simulacion_estados (
    id_pregunta        INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad       INT NOT NULL,
    enunciado          TEXT NOT NULL,
    opcion_a           VARCHAR(255) NOT NULL,
    opcion_b           VARCHAR(255) NOT NULL,
    opcion_c           VARCHAR(255) NOT NULL,
    opcion_d           VARCHAR(255) NOT NULL,
    respuesta_correcta TINYINT NOT NULL COMMENT '1=A 2=B 3=C 4=D',
    explicacion        TEXT,
    CONSTRAINT fk_pregunta_estados_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE
);

-- Para IDENTIFICACION_PROPIEDAD (Escenario 5)
CREATE TABLE fenomeno_propiedad (
    id_fenomeno        INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad       INT NOT NULL,
    descripcion        TEXT NOT NULL,
    propiedad_correcta ENUM('TENSION_SUPERFICIAL','VISCOSIDAD','CAPILARIDAD') NOT NULL,
    CONSTRAINT fk_fenomeno_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE
);

-- Para SIMULACION_EBULLICION (Escenario 6)
CREATE TABLE pregunta_simulacion_ebullicion (
    id_pregunta        INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad       INT NOT NULL,
    parametro_altitud  INT DEFAULT 0 COMMENT 'Altitud en metros',
    parametro_presion  DECIMAL(6,2) DEFAULT 1.00 COMMENT 'Presión en atm',
    enunciado          TEXT NOT NULL,
    opcion_a           VARCHAR(255) NOT NULL,
    opcion_b           VARCHAR(255) NOT NULL,
    opcion_c           VARCHAR(255) NOT NULL,
    opcion_d           VARCHAR(255) NOT NULL,
    respuesta_correcta TINYINT NOT NULL,
    explicacion        TEXT,
    CONSTRAINT fk_pregunta_ebullicion_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- ÍNDICES INICIALES
-- ------------------------------------------------------------
CALL create_index_safe('sesion', 'idx_sesion_token', '(token)');
CALL create_index_safe('sesion', 'idx_sesion_estudiante', '(id_estudiante, activa)');
CALL create_index_safe('progreso_escenario', 'idx_progreso_estudiante', '(id_estudiante)');
CALL create_index_safe('progreso_escenario', 'idx_progreso_escenario', '(id_escenario)');
CALL create_index_safe('intento_cuestionario', 'idx_intento_estudiante', '(id_estudiante, id_cuestionario)');
CALL create_index_safe('intento_cuestionario', 'idx_intento_puntaje', '(puntaje_obtenido DESC)');
CALL create_index_safe('respuesta_estudiante', 'idx_respuesta_intento', '(id_intento)');
CALL create_index_safe('insignia_estudiante', 'idx_insignia_estudiante', '(id_estudiante)');
CALL create_index_safe('receta_estudiante', 'idx_receta_estudiante', '(id_estudiante)');
CALL create_index_safe('estudiante', 'idx_estudiante_estrellas', '(total_estrellas DESC)');

-- ------------------------------------------------------------
-- TRIGGER
-- ------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_progreso_completado;
DELIMITER $$
CREATE TRIGGER trg_progreso_completado
BEFORE UPDATE ON progreso_escenario
FOR EACH ROW
BEGIN
    IF NEW.completado = 1 AND OLD.completado = 0 THEN
        SET NEW.fecha_completado = NOW();
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- DATOS: ESCENARIOS
-- ============================================================
INSERT INTO escenario (nombre, descripcion, orden, estrellas_requeridas) VALUES
('La Cocina Fría — Dispersión de London', 'Aprende las fuerzas de dispersión de London en aceites e hidrocarburos.', 1, 0),
('La Sala de Salsas — Dipolo-dipolo', 'Comprende cómo las moléculas polares se atraen entre sí.', 2, 3),
('El Taller del Merengue — Puentes de hidrógeno', 'Explora los puentes de hidrógeno en agua y proteínas del huevo.', 3, 6),
('El Horno y el Congelador — Estados de la materia', 'Observa cómo las fuerzas intermoleculares determinan el estado físico.', 4, 9),
('El Bar Molecular — Propiedades de los líquidos', 'Comprende tensión superficial, viscosidad y capilaridad.', 5, 12),
('La Olla a Presión — Presión de vapor y ebullición', 'Aprende cómo la presión de vapor determina el punto de ebullición.', 6, 15);

-- ============================================================
-- ACTIVIDADES INTERACTIVAS
-- ============================================================

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

-- Escenario 3: MATCH_PUENTES_H
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'MATCH_PUENTES_H', 1, 100 FROM escenario WHERE orden = 3;

-- Escenario 4: SIMULACION_ESTADOS
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'SIMULACION_ESTADOS', 1, 100 FROM escenario WHERE orden = 4;

-- Escenario 5: IDENTIFICACION_PROPIEDAD
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'IDENTIFICACION_PROPIEDAD', 1, 100 FROM escenario WHERE orden = 5;

-- Escenario 6: SIMULACION_EBULLICION
INSERT INTO actividad_interactiva (id_escenario, tipo, orden, peso_puntaje)
SELECT id_escenario, 'SIMULACION_EBULLICION', 1, 100 FROM escenario WHERE orden = 6;

-- ============================================================
-- DATOS PARA ESCENARIO 1 (Drag & Drop Polar/No polar + Fuerzas)
-- ============================================================
-- ============================================================
-- DATOS: RECETAS, INSIGNIAS, ACTIVIDADES
-- ============================================================

-- ------------------- RECETAS ---------------------------------
INSERT INTO receta (id_escenario, nombre, descripcion, ingredientes, pasos, imagen_url, es_opcional)
SELECT e.id_escenario, 'Huevo a Baja Temperatura',
       'Técnica de cocción precisa que preserva la textura sedosa de la yema.',
       '1 huevo fresco\nAgua a 63 °C',
       '1. Calentar agua a exactamente 63 °C.\n2. Sumergir el huevo durante 45 min.\n3. Retirar y servir.',
       '/img/recetas/huevo_baja_temperatura.png', 0
FROM escenario e WHERE e.orden = 1
UNION ALL SELECT e.id_escenario, 'Mayonesa Molecular',
       'Emulsión perfecta con técnicas de cocina molecular.',
       '2 yemas de huevo\n200 ml aceite de oliva\n10 ml jugo de limón\n2 g lecitina de soja\nSal',
       '1. Mezclar yemas con lecitina.\n2. Agregar aceite en hilo fino batiendo.\n3. Incorporar limón y sal.\n4. Emulsionar con batidora.',
       '/img/recetas/mayonesa_molecular.png', 0
FROM escenario e WHERE e.orden = 2
UNION ALL SELECT e.id_escenario, 'Gel de Mango con Agar',
       'Gel transparente de mango con textura firme y sabor intenso.',
       '300 ml jugo de mango\n3 g agar-agar\n20 g azúcar',
       '1. Calentar jugo con azúcar.\n2. Disolver el agar-agar en caliente.\n3. Verter en moldes, enfriar.\n4. Refrigerar 30 min.',
       '/img/recetas/gel_mango.png', 0
FROM escenario e WHERE e.orden = 3
UNION ALL SELECT e.id_escenario, 'Esferas de Aceite de Oliva',
       'Esferas de aceite de oliva virgen extra con membrana de alginato.',
       '100 ml aceite de oliva\n2 g alginato de sodio\n500 ml agua\n5 g cloruro de calcio',
       '1. Mezclar aceite con alginato.\n2. Disolver cloruro de calcio en agua fría.\n3. Con jeringa, gotear mezcla en baño de calcio.\n4. Reposar 2 min y enjuagar.',
       '/img/recetas/esferas_aceite.png', 0
FROM escenario e WHERE e.orden = 4
UNION ALL SELECT e.id_escenario, 'Helado Instantáneo de Vainilla',
       'Helado cremoso preparado al instante con nitrógeno líquido.',
       '500 ml crema de leche\n100 ml leche entera\n80 g azúcar\n1 vaina de vainilla\n500 ml nitrógeno líquido',
       '1. Mezclar crema, leche, azúcar y vainilla en bol metálico.\n2. Verter nitrógeno líquido poco a poco revolviendo.\n3. Continuar hasta obtener textura deseada.\n4. Servir inmediatamente.',
       '/img/recetas/helado_nitrogeno.png', 0
FROM escenario e WHERE e.orden = 5
UNION ALL SELECT e.id_escenario, 'Caldos Concentrados a Presión',
       'Caldos ricos en colágeno cocinados en olla a presión para extraer sabores profundos.',
       '500 g huesos de res\n1 cebolla\n2 zanahorias\nAgua hasta cubrir\nSal y especias',
       '1. Colocar todos los ingredientes en olla a presión.\n2. Cocinar a alta presión por 45 min.\n3. Liberar presión, colar y reducir si se desea.',
       '/img/recetas/caldo_presion.png', 0
FROM escenario e WHERE e.orden = 6;

-- ------------------- INSIGNIAS --------------------------------
INSERT INTO insignia (nombre, descripcion, icono_url, tipo_condicion, valor_condicion, id_escenario_asociado) VALUES
('Primer Paso',       'Completa tu primer escenario.',         '/img/insignias/primer_paso.png',      'ESCENARIOS_COMPLETADOS', 1,  NULL),
('Coleccionista',     'Desbloquea 3 recetas.',                 '/img/insignias/coleccionista.png',    'RECETAS_DESBLOQUEADAS',  3,  NULL),
('Perfeccionista',    'Obtiene 3 estrellas en el escenario 1.','/img/insignias/perfeccionista.png',   'PERFECTO_ESCENARIO',     3,  1),
('Sous Chef',         'Alcanza el rango Sous Chef.',           '/img/insignias/sous_chef.png',        'RANGO',                  2,  NULL),
('Chef Estrella',     'Acumula 15 estrellas en total.',        '/img/insignias/chef_estrella.png',    'ESTRELLAS_TOTALES',      15, NULL),
('Explorador',        'Completa 3 escenarios.',                '/img/insignias/explorador.png',       'ESCENARIOS_COMPLETADOS', 3,  NULL),
('Maestro Molecular', 'Completa todos los escenarios.',        '/img/insignias/maestro.png',          'ESCENARIOS_COMPLETADOS', 5,  NULL),
('Perfecto 2',        'Obtiene 3 estrellas en el escenario 2.','/img/insignias/perfecto2.png',        'PERFECTO_ESCENARIO',     3,  2),
('Perfecto 3',        'Obtiene 3 estrellas en el escenario 3.','/img/insignias/perfecto3.png',        'PERFECTO_ESCENARIO',     3,  3),
('Perfecto 4',        'Obtiene 3 estrellas en el escenario 4.','/img/insignias/perfecto4.png',        'PERFECTO_ESCENARIO',     3,  4),
('Perfecto 5',        'Obtiene 3 estrellas en el escenario 5.','/img/insignias/perfecto5.png',        'PERFECTO_ESCENARIO',     3,  5);

-- ------------------------------------------------------------
-- DATOS PARA ESCENARIO 1 (Drag & Drop)
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- DATOS PARA ESCENARIO 2 (Drag & Drop + Match Dipolos)
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- DATOS PARA ESCENARIO 3 - MATCH_PUENTES_H
-- ------------------------------------------------------------
-- Insertar moléculas
INSERT INTO molecula_puente_h (id_actividad, nombre, atomo, tiene_h, puede_formar)
SELECT a.id_actividad, 'Agua (H₂O)', 'O', 1, 1
FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Ácido fluorhídrico (HF)', 'F', 1, 1 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Amoníaco (NH₃)', 'N', 1, 1 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Metano (CH₄)', 'C', 0, 0 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Ácido clorhídrico (HCl)', 'Cl', 1, 0 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3
UNION ALL SELECT a.id_actividad, 'Dióxido de carbono (CO₂)', 'C', 0, 0 FROM actividad_interactiva a JOIN escenario e ON a.id_escenario = e.id_escenario WHERE e.orden = 3;

-- Insertar pares correctos (combinaciones con puente de H real)
-- Usamos los IDs generados automáticamente: necesitamos referenciarlos por nombre.
-- Formamos pares entre las moléculas que pueden formar puente de H (id 1,2,3)
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

-- ------------------------------------------------------------
-- DATOS PARA ESCENARIO 4 - SIMULACION_ESTADOS (preguntas)
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- DATOS PARA ESCENARIO 5 - IDENTIFICACION_PROPIEDAD
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- DATOS PARA ESCENARIO 6 - SIMULACION_EBULLICION
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
-- ÍNDICES ADICIONALES
-- ------------------------------------------------------------
CALL create_index_safe('actividad_interactiva', 'idx_actividad_tipo_orden', '(id_escenario, tipo, orden)');
CALL create_index_safe('respuesta_estudiante', 'idx_respuesta_pregunta', '(id_pregunta)');
CALL create_index_safe('insignia', 'idx_insignia_tipo', '(tipo_condicion, valor_condicion)');

-- ------------------------------------------------------------
-- VERIFICACIÓN FINAL
-- ------------------------------------------------------------
SELECT '✅ Base de datos definitiva lista.' AS Estado;
SELECT e.orden, e.nombre, COUNT(ai.id_actividad) AS total_actividades
FROM escenario e
LEFT JOIN actividad_interactiva ai ON e.id_escenario = ai.id_escenario
GROUP BY e.id_escenario
ORDER BY e.orden;