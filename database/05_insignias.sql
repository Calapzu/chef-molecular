-- =============================================
-- INSIGNIAS DEL SISTEMA
-- =============================================

USE chef_molecular;

INSERT INTO insignia (nombre, descripcion, icono_url, tipo_condicion, valor_condicion, id_escenario_asociado) VALUES
('Primer Paso',       'Completa tu primer escenario.',         '/img/insignias/primer_paso.png',      'ESCENARIOS_COMPLETADOS', 1,  NULL),
('Coleccionista',     'Desbloquea 3 recetas.',                 '/img/insignias/coleccionista.png',    'RECETAS_DESBLOQUEADAS',  3,  NULL),
('Perfeccionista',    'Obtiene 3 estrellas en el escenario 1.','/img/insignias/perfeccionista.png',   'PERFECTO_ESCENARIO',     3,  1),
('Sous Chef',         'Alcanza el rango Sous Chef.',           '/img/insignias/sous_chef.png',        'RANGO',                  2,  NULL),
('Chef Estrella',     'Acumula 15 estrellas en total.',        '/img/insignias/chef_estrella.png',    'ESTRELLAS_TOTALES',      15, NULL);

SELECT '✅ Insignias insertadas' as Mensaje;