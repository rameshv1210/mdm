DROP PROCEDURE IF EXISTS `user`.`spTest_Array`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `user`.`spTest_Array`(
    v_id_arr TEXT
)
BEGIN
    DECLARE v_cur_position INT; 
    DECLARE v_remainder TEXT; 
    DECLARE v_cur_string VARCHAR(255); 
    CREATE TEMPORARY TABLE tmp_test
    ( 
        id INT
    ) ENGINE=MEMORY; 

    SET v_remainder = v_id_arr; 
    SET v_cur_position = 1;

    WHILE CHAR_LENGTH(v_remainder) > 0 AND v_cur_position > 0 DO 
        SET v_cur_position = INSTR(v_remainder, '|'); 
        IF v_cur_position = 0 THEN 
            SET v_cur_string = v_remainder; 
        ELSE 
            SET v_cur_string = LEFT(v_remainder, v_cur_position - 1); 
        END IF; 

        IF TRIM(v_cur_string) != '' THEN 
            INSERT INTO tmp_test
                (id)
            VALUES 
                (v_cur_string);                 
        END IF; 

        SET v_remainder = SUBSTRING(v_remainder, v_cur_position + 1); 
    END WHILE; 

    SELECT 
        id
    FROM 
    tmp_test;

    DROP TEMPORARY TABLE tmp_test;
END$$
DELIMITER ;
