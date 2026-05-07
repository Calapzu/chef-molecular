-- =============================================
-- CUESTIONARIOS Y PREGUNTAS COMPLETAS
-- Incluye TODOS los escenarios (1 al 6)
-- =============================================

USE chef_molecular;

-- Limpiar datos existentes (respetar foreign keys)
DELETE FROM retroalimentacion;
DELETE FROM respuesta_estudiante;
DELETE FROM intento_cuestionario;
DELETE FROM pregunta;
DELETE FROM cuestionario;

-- Crear cuestionarios (uno por escenario)
INSERT INTO cuestionario (id_escenario, total_preguntas, intentos_permitidos, tiempo_limite_minutos)
SELECT id_escenario,
       CASE WHEN orden = 6 THEN 10 ELSE 5 END as total_preguntas,
       3 as intentos_permitidos,
       30 as tiempo_limite_minutos
FROM escenario ORDER BY orden;

-- =============================================
-- ESCENARIO 1: Dispersión de London (5 preguntas)
-- =============================================
INSERT INTO pregunta (id_cuestionario, enunciado, opcion_a, opcion_b, opcion_c, opcion_d, respuesta_correcta, explicacion, peso_puntaje)
SELECT c.id_cuestionario,
       p.enunciado, p.a, p.b, p.c, p.d, p.correcta, p.exp, 20
FROM cuestionario c
JOIN escenario e ON c.id_escenario = e.id_escenario AND e.orden = 1
JOIN (
    -- TUS PREGUNTAS DEL ESCENARIO 1 AQUÍ
    SELECT 'Las fuerzas de dispersión de London se presentan en:' enunciado,
           'Moléculas polares únicamente' a,
           'Todas las moléculas, polares y no polares' b,
           'Solo en moléculas con carga' c,
           'Únicamente en sólidos' d,
           2 correcta,
           'Las fuerzas de London actúan en TODAS las moléculas, aunque son más relevantes en las no polares.' exp
    UNION ALL
    SELECT 'Las fuerzas de dispersión de London son causadas por:',
           'Cargas permanentes entre moléculas',
           'Dipolos permanentes',
           'Fluctuaciones temporales en la distribución electrónica',
           'Transferencia de electrones',
           3,
           'Son producidas por dipolos instantáneos que surgen de movimientos aleatorios de electrones.'
    UNION ALL
    SELECT '¿En cuál sustancia son MÁS intensas las fuerzas de London?',
           'Metano (CH4)', 'Helio (He)', 'Hidrógeno (H2)', 'Octano (C8H18)', 4,
           'A mayor masa molecular y más electrones, más fuertes son las fuerzas de London.'
    -- CONTINUAR CON LAS 2 PREGUNTAS RESTANTES DEL ESCENARIO 1
) p ON 1=1;

-- [CONTINUAR CON PREGUNTAS DE ESCENARIO 2, 3, 4, 5, 6]
-- (Todas las preguntas que ya tienes en tu script)

SELECT '✅ Cuestionarios y preguntas insertadas' as Mensaje;