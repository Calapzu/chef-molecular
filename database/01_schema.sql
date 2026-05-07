-- =============================================
-- CHEF MOLECULAR - Esquema de Base de Datos
-- MySQL 8.0
-- Fecha: 2024
-- =============================================

CREATE DATABASE IF NOT EXISTS chef_molecular
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE chef_molecular;

-- =============================================
-- TABLA: estudiante
-- =============================================
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

-- =============================================
-- TABLA: sesion
-- =============================================
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

-- =============================================
-- TABLA: escenario
-- =============================================
CREATE TABLE escenario (
    id_escenario          INT AUTO_INCREMENT PRIMARY KEY,
    nombre                VARCHAR(100) NOT NULL,
    descripcion           TEXT,
    orden                 INT NOT NULL DEFAULT 1,
    estrellas_requeridas  INT NOT NULL DEFAULT 0
);

-- [CONTINUAR CON EL RESTO DE TABLAS: 
--  progreso_escenario, actividad_interactiva, elemento_arrastrable,
--  pieza_molecular, resultado_actividad, cuestionario, pregunta,
--  retroalimentacion, intento_cuestionario, respuesta_estudiante,
--  insignia, insignia_estudiante, receta, receta_estudiante]

-- =============================================
-- INDICES DE RENDIMIENTO
-- =============================================
CREATE INDEX idx_sesion_token ON sesion(token);
CREATE INDEX idx_sesion_estudiante ON sesion(id_estudiante, activa);
CREATE INDEX idx_progreso_estudiante ON progreso_escenario(id_estudiante);
CREATE INDEX idx_estudiante_estrellas ON estudiante(total_estrellas DESC);

SELECT '✅ Esquema creado exitosamente' as Mensaje;