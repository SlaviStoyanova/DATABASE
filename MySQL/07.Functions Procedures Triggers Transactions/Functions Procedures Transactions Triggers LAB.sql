#EX_1
DELIMITER $$
CREATE FUNCTION `ufn_count_employees_by_town`(`town_name` VARCHAR(20)) 
RETURNS INTEGER
DETERMINISTIC
BEGIN
DECLARE `e_count` INT;
SET `e_count` := (SELECT COUNT(`employee_id`) 
FROM `employees`AS e
JOIN `addresses` AS a
USING(`address_id`)
JOIN `towns` AS t
USING (`town_id`)
WHERE t.`name` = `town_name`
GROUP BY t.`name`);
RETURN `e_count`;
END $$
DELIMITER ;
#EX_2
DELIMITER $$
CREATE PROCEDURE `usp_raise_salaries`(`department_name` VARCHAR(50)) 
BEGIN
UPDATE `employees`
JOIN `departments` AS d
USING (`department_id`)
SET `salary` = `salary` * 1.05
WHERE d.`name` = d.`name`;
END $$

#EX_3
CREATE PROCEDURE `usp_raise_salary_by_id`(`id` INT) 
BEGIN
START TRANSACTION;
IF ((SELECT COUNT(`employee_id`) FROM `employees`WHERE `employee_id` = `id`) = 1)
THEN
UPDATE `employees`
SET `salary` = `salary` * 1.05
WHERE `employee_id` = `id`;
COMMIT;
ELSE ROLLBACK;
END IF;
END;



#EX_4
CREATE TABLE `deleted_employees`(
	`employee_id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(20),
	`last_name` VARCHAR(20),
	`middle_name` VARCHAR(20),
	`job_title` VARCHAR(50),
	`department_id` INT,
	`salary` DOUBLE 
);
CREATE TRIGGER `tr_deleted_employees`
AFTER DELETE
ON `employees`
FOR EACH ROW
BEGIN
	INSERT INTO `deleted_employees` (`first_name`,`last_name`,`middle_name`,`job_title`,`department_id`,`salary`)
	VALUES(OLD.`first_name`,OLD.`last_name`,OLD.`middle_name`,OLD.`job_title`,OLD.`department_id`,OLD.`salary`);
END;




