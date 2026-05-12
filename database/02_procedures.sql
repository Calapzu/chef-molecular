-- ============================================================
-- PROCEDURES
-- ============================================================

USE chef_molecular;

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
END$$
DELIMITER ;