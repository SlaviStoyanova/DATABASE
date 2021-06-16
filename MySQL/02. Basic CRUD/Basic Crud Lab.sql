USE  `hotel`;

#EX_1 
SELECT id, first_name, last_name , job_title 
FROM `employees`
ORDER BY `id`;

#EX_2
SELECT `id`, concat(`first_name`,' ', `last_name`) AS 'full_name', `job_title`, `salary`
FROM `employees`
WHERE `salary` > 1000
ORDER BY `id`;

#EX_3
UPDATE `employees`
SET `salary` = `salary` + 100
WHERE `job_title` = 'Manager';
SELECT `salary` FROM `employees`;

#EX_4
CREATE VIEW `v_top_paid_employee` AS
SELECT * FROM `employees`
ORDER BY `salary` DESC LIMIT 1;
SELECT  * FROM  `v_top_paid_employee`;

#EX_5
SELECT * FROM `employees`
WHERE `department_id` IN (4) AND `salary` > 1000
ORDER BY `id`;

#EX_6
DELETE FROM `employees`
WHERE `department_id` IN (2,1);
SELECT * FROM `employees` 
ORDER BY `id`;




