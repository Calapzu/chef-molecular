USE chef_molecular;

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