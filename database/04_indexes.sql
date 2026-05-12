-- ============================================================
-- ÍNDICES (usa el procedimiento create_index_safe)
-- ============================================================

USE chef_molecular;

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
CALL create_index_safe('actividad_interactiva', 'idx_actividad_tipo_orden', '(id_escenario, tipo, orden)');
CALL create_index_safe('respuesta_estudiante', 'idx_respuesta_pregunta', '(id_pregunta)');
CALL create_index_safe('insignia', 'idx_insignia_tipo', '(tipo_condicion, valor_condicion)');