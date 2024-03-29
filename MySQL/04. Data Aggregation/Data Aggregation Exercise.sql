#EX_1
SELECT  COUNT(*)
FROM `wizzard_deposits`;

#EX_2
SELECT MAX(`magic_wand_size`) AS 'longest_magoc_wand'
 FROM `wizzard_deposits`;
 
 #EX_3
 SELECT `deposit_group`,MAX(`magic_wand_size`) AS 'longest_magic_wand'
 FROM `wizzard_deposits`
 GROUP BY `deposit_group`
 ORDER BY `longest_magic_wand`,`deposit_group`;
 
 #EX_4
 SELECT `deposit_group`
 FROM `wizzard_deposits`
 GROUP BY `deposit_group`
 ORDER BY  AVG (`magic_wand_size`)
 LIMIT 1;

#EX_5
SELECT `deposit_group`,SUM(`deposit_amount`) AS 'total_sum'
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum`;

#EX_6
SELECT 
    `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM
    `wizzard_deposits`
WHERE
    `magic_wand_creator` LIKE 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;

#EX_7
SELECT 
    `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
FROM
    `wizzard_deposits`
WHERE
    `magic_wand_creator` LIKE 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

#EX_8
SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS `min_deposit_charge`
FROM `wizzard_deposits`
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator`,`deposit_group` ;

#EX_9
SELECT 
    (CASE
        WHEN `age` BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN `age` BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN `age` BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN `age` BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN `age` BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN `age` BETWEEN 51 AND 60 THEN '[51-60]'
        ELSE '[61+]'
    END) AS `age group`,
    COUNT(*) AS `wizzard_count`
FROM
    `wizzard_deposits`
GROUP BY `age group`
ORDER BY `age group`;

#EX_10
SELECT LEFT (`first_name`,1) AS `first letter`
FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first letter`
ORDER BY `first letter`;

#EX_11
SELECT 
    `deposit_group`,
    `is_deposit_expired`,
    AVG(`deposit_interest`) AS `average_interest`
FROM
    `wizzard_deposits`
WHERE
    `deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group` , `is_deposit_expired`
ORDER BY `deposit_group` DESC , `is_deposit_expired`;

#EX_12
SELECT `department_id`,MIN(`salary`) AS `minimum_salary`
FROM `employees`
WHERE `department_id` IN (2,5,7) AND  YEAR(`hire_date`) > '2000-01-01'
GROUP BY `department_id`
ORDER BY `department_id`;

#EX_13
CREATE TABLE `high_paied` AS SELECT * FROM
    `employees`
WHERE
    `salary` > 30000 AND `manager_id` != 42;
UPDATE `high_paied` 
SET 
    `salary` = `salary` + 5000
WHERE
    `department_id` = 1;

SELECT 
    `department_id`, AVG(`salary`)
FROM
    `high_paied`
GROUP BY `department_id`
ORDER BY `department_id`;

#EX_14
SELECT `department_id`, MAX(`salary`) AS `max_salary`
FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id`;

#EX_15
SELECT COUNT(`salary`)
FROM `employees`
WHERE `manager_id` IS NULL;

#EX_16
SELECT e.`department_id`, (
SELECT DISTINCT e2.`salary` FROM `employees` AS e2
WHERE e2.`department_id` = e.`department_id`
ORDER BY e2.`salary` DESC
LIMIT 1 OFFSET 2
) AS `third_highest_salary`
FROM `employees` AS e
GROUP BY e.`department_id`
HAVING `third_highest_salary` IS NOT NULL
ORDER BY e.`department_id` ;

#EX_17
  SELECT e.`first_name`, e.`last_name`,e.`department_id`
 FROM `employees` AS e
 WHERE  e.`salary` > (
 SELECT AVG(e2.`salary`)
 FROM `employees` AS e2
 WHERE e2.`department_id` = e.`department_id`
) 
 ORDER BY `department_id`,`employee_id`
 LIMIT 10;

#EX_18
SELECT `department_id`,SUM(`salary`) AS `total_salary`
 FROM `employees`
 GROUP BY `department_id`
 ORDER BY `department_id`;