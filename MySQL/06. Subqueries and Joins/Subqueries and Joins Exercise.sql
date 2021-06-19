
#EX_1
SELECT 
    e.`employee_id`,
    e.`job_title`,
    a.`address_id`,
    a.`address_text`
FROM
    `employees` AS e
        JOIN
    `addresses` AS a ON e.`address_id` = a.`address_id`
ORDER BY `address_id`
LIMIT 5;

#EX_2
SELECT e.`first_name`,e.`last_name`,t.`name`,a.`address_text`
FROM `employees` AS e
JOIN `addresses` AS a
ON e.`address_id` = a.`address_id`
JOIN `towns` AS t
ON a.`town_id` = t.`town_id`
ORDER BY e.`first_name`,e.`last_name` LIMIT 5;

#EX_3
SELECT 
    e.`employee_id`, e.`first_name`, e.`last_name`, d.`name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d USING (`department_id`)
WHERE
    d.`name` = 'Sales'
ORDER BY e.`employee_id` DESC;

#EX_4
SELECT 
    e.`employee_id`, e.`first_name`, e.`salary`, d.`name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d USING (`department_id`)
WHERE
    e.`salary` > 15000
ORDER BY d.`department_id` DESC
LIMIT 5;

#EX_5
SELECT 
    e.`employee_id`, e.`first_name`
FROM
    `employees` AS e
        LEFT JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
WHERE
    ep.`project_id` IS NULL
ORDER BY e.`employee_id` DESC
LIMIT 3;

#EX_6
SELECT 
    e.`first_name`,
    e.`last_name`,
    e.`hire_date` employees,
    d.`name`
FROM
    `employees` AS e
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
WHERE
    DATE(e.`hire_date`) > '1999-01-01'
        AND d.`name` IN ('Sales' , 'Finance')
ORDER BY e.`hire_date`;

#EX_7
SELECT 
    e.`employee_id`, e.`first_name`, p.`name`
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
        JOIN
    `projects` AS p USING (`project_id`)
WHERE
    DATE(p.`start_date`) > '2002-08-13'
        AND p.`end_date` IS NULL
ORDER BY e.`first_name` , p.`name`
LIMIT 5;

#EX_8
SELECT 
    e.`employee_id`,
    e.`first_name`,
    IF(YEAR(p.`start_date`) > 2004,
        NULL,
        p.`name`) AS `project_name`
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep ON e.`employee_id` = ep.`employee_id`
        JOIN
    `projects` AS p USING (`project_id`)
WHERE
    e.`employee_id` = 24
ORDER BY p.`name`;

#EX_9
SELECT 
    e.`employee_id`,
    e.`first_name`,
    e.`manager_id`,
    m.`first_name` AS `manager_name`
FROM
    `employees` AS e
        JOIN
    `employees` AS m ON e.`manager_id` = m.`employee_id`
WHERE
    e.`manager_id` IN (3 , 7)
ORDER BY e.`first_name`;



#EX_10
SELECT 
    e.`employee_id`,
    CONCAT_WS(' ', e.`first_name`, e.`last_name`) AS `employee_name`,
    CONCAT_WS(' ', m.`first_name`, m.`last_name`) AS `manager_name`,
    d.`name`
FROM
    `employees` AS e
        JOIN
    `employees` AS m ON e.`manager_id` = m.`employee_id`
        JOIN
    `departments` AS d ON e.`department_id` = d.`department_id`
ORDER BY e.`employee_id`
LIMIT 5;

#EX_11
SELECT  AVG(`salary`)AS `avg`
FROM  `employees`
GROUP BY `department_id`
ORDER BY `avg`
LIMIT 1;

#EX_12
SELECT 
    c.`country_code`,
    m.`mountain_range`,
    p.`peak_name`,
    p.`elevation`
FROM
    `countries` AS c
        JOIN
    `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
        JOIN
    `mountains` AS m ON mc.`mountain_id` = m.`id`
        JOIN
    `peaks` AS p ON p.`mountain_id` = m.`id`
WHERE
    c.`country_code` = 'BG'
        AND p.`elevation` > 2835
ORDER BY p.`elevation` DESC;

#EX_13
SELECT 
    mc.`country_code`, COUNT(m.`id`) AS `mountain_range`
FROM
    `mountains` AS m
        JOIN
    `mountains_countries` AS mc ON mc.`mountain_id` = m.`id`
WHERE
    mc.`country_code` IN ('BG' , 'RU', 'US')
GROUP BY mc.`country_code`
ORDER BY `mountain_range` DESC;

#EX_14
SELECT 
    c.`country_name`, r.`river_name`
FROM
    `countries` AS c
        LEFT JOIN
    `countries_rivers` AS cr ON c.`country_code` = cr.`country_code`
        LEFT JOIN
    `rivers` AS r ON cr.`river_id` = r.`id`
WHERE
    c.`continent_code` = 'AF'
ORDER BY c.`country_name`
LIMIT 5;

#EX_15
SELECT 
    c.`continent_code`,
    c.`currency_code`,
    COUNT(*) AS `currency_usage`
FROM
    `countries` AS c
GROUP BY c.`continent_code` , c.`currency_code`
HAVING `currency_usage` = (SELECT 
        COUNT(`country_code`) AS `coun`
    FROM
        `countries` AS c1
    WHERE
        c1.`continent_code` = c.`continent_code`
    GROUP BY `currency_code`
    ORDER BY `coun` DESC
    LIMIT 1)
    AND `currency_usage` > 1
ORDER BY c.`continent_code` , c.`currency_code`;

#EX_16
SELECT COUNT(*)
FROM `countries` AS c
WHERE c.`country_code` NOT IN (SELECT `country_code` FROM `mountains_countries`);

#EX_17
SELECT 
    c.`country_name`,
    MAX(p.`elevation`) AS `highest_peak_elevation`,
    MAX(r.`length`) AS `longest_river_length`
FROM
    `countries` AS c
        JOIN
    `countries_rivers` AS cr ON c.`country_code` = cr.`country_code`
        JOIN
    `rivers` AS r ON cr.`river_id` = r.`id`
        JOIN
    `mountains_countries` AS mc ON c.`country_code` = mc.`country_code`
        JOIN
    `mountains` AS m ON mc.`mountain_id` = m.`id`
        JOIN
    `peaks` AS p ON p.`mountain_id` = m.`id`
GROUP BY c.`country_code`
ORDER BY `highest_peak_elevation` DESC , `longest_river_length` DESC , c.`country_name`
LIMIT 5;

