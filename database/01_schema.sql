-- ============================================================
-- SCHEMA: TABLAS Y ESTRUCTURA
-- ============================================================

DROP DATABASE IF EXISTS chef_molecular;
CREATE DATABASE chef_molecular
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE chef_molecular;

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

CREATE TABLE par_dipolo (
    id_par           INT AUTO_INCREMENT PRIMARY KEY,
    id_actividad     INT NOT NULL,
    extremo_positivo VARCHAR(100) NOT NULL,
    extremo_negativo VARCHAR(100) NOT NULL,
    CONSTRAINT fk_par_dipolo_actividad FOREIGN KEY (id_actividad)
        REFERENCES actividad_interactiva(id_actividad) ON DELETE CASCADE
);