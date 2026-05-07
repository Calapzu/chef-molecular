-- =============================================
-- ACTUALIZACIÓN: Renombrar escenarios a nombres de cocina molecular
-- Ejecutar DESPUÉS de los INSERT iniciales
-- =============================================

USE chef_molecular;

UPDATE escenario SET 
    nombre = 'La Cocina Fría — Dispersión de London',
    descripcion = 'Aprende las fuerzas de dispersión de London en aceites e hidrocarburos.'
WHERE orden = 1;

UPDATE escenario SET 
    nombre = 'La Sala de Salsas — Dipolo-dipolo',
    descripcion = 'Comprende cómo las moléculas polares se atraen entre sí.'
WHERE orden = 2;

UPDATE escenario SET 
    nombre = 'El Taller del Merengue — Puentes de hidrógeno',
    descripcion = 'Explora los puentes de hidrógeno en agua y proteínas del huevo.'
WHERE orden = 3;

UPDATE escenario SET 
    nombre = 'El Horno y el Congelador — Estados de la materia',
    descripcion = 'Observa cómo las fuerzas intermoleculares determinan el estado físico.'
WHERE orden = 4;

UPDATE escenario SET 
    nombre = 'El Bar Molecular — Propiedades de los líquidos',
    descripcion = 'Comprende tensión superficial, viscosidad y capilaridad.'
WHERE orden = 5;

-- Insertar escenario 6 si no existe
INSERT INTO escenario (nombre, descripcion, orden, estrellas_requeridas)
SELECT 'La Olla a Presión — Presión de vapor y ebullición',
       'Aprende cómo la presión de vapor determina el punto de ebullición.',
       6, 15
WHERE NOT EXISTS (SELECT 1 FROM escenario WHERE orden = 6);

SELECT '✅ Escenarios actualizados correctamente' as Mensaje;