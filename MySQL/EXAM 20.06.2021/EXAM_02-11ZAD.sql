#ZAD_2
INSERT INTO `clients`(`full_name`, `phone_number`)
SELECT 
    CONCAT_WS(' ', d.first_name, d.last_name) , CONCAT('(088) 9999',`id` * 2)
FROM
       drivers AS d
WHERE
    d.id BETWEEN 10 AND 20;
    
    
#ZAD_3
UPDATE `cars` 
SET 
    `condition` = 'C'
WHERE
    `mileage` >= 80000
        OR `mileage` IS NULL AND `year` <= 2010
        AND `make` NOT IN ('Mercedes-Benz');

#ZAD_4
DELETE FROM `clients` AS c
WHERE CHAR_LENGTH(`full_name`) >3
AND c.`id` NOT IN (SELECT `client_id` FROM `courses`);

#EX_5
    SELECT `make`,`model`,`condition` 
    FROM `cars`
    ORDER BY `id`;
    
    #EX_6
SELECT 
    d.`first_name`,
    d.`last_name`,
    c.`make`,
    c.`model`,
    c.`mileage`
FROM
    `drivers` AS d
        LEFT JOIN
    `cars_drivers` AS cd ON d.`id` = cd.`driver_id`
        LEFT JOIN
    `cars` AS c ON c.`id` = cd.`car_id`
WHERE
    `mileage` IS NOT NULL
ORDER BY c.`mileage` DESC , d.`first_name`;


    #ZAD_7
SELECT 
    c.id AS car_id,
    c.`make`,
    c.`mileage`,
    COUNT(co.`id`) AS `count_of_courses`,
    ROUND(AVG(co.`bill`), 2) AS `avg_bill`
FROM
    `cars` AS c
        LEFT JOIN
    `courses` AS co ON c.`id` = co.`car_id`
GROUP BY c.`id`
HAVING `count_of_courses` != 2
ORDER BY `count_of_courses` DESC , c.`id`;

   #EX_8
SELECT 
    cl.`full_name`,
    COUNT(c.`id`) AS `count_of_cars`,
    SUM(co.`bill`) AS `total_sum`
FROM
    `clients` AS cl
        JOIN
    `courses` AS co ON cl.`id` = co.`client_id`
        JOIN
    cars AS c ON co.`car_id` = c.`id`
GROUP BY cl.`id`
HAVING cl.`full_name` LIKE '_a%'
    AND `count_of_cars` > 1
ORDER BY cl.`full_name`;
 
    #EX_9
 SELECT ad.`name`,
   ( CASE
   WHEN HOUR(co.`start`) BETWEEN 6 AND 20 THEN 'Day'
   ELSE 'Night' END) AS `day_time`, 
   SUM(co.`bill`) AS `bill`, cl.`full_name`, c.`make`, c.`model`, cat.`name` AS `category_name`
FROM `addresses` AS ad
JOIN `courses` AS co
ON  co.`from_address_id` = ad.`id`
JOIN `clients` AS  cl
ON  cl.`id` = co.`client_id`
JOIN `cars` AS  c
ON  co.`car_id` = c.`id`
JOIN `categories` AS cat
ON cat.`id` = c.`category_id`
GROUP BY co.`id`
ORDER BY co.`id`;

#EX_10
DELIMITER $$
CREATE FUNCTION udf_courses_by_client  (phone_num VARCHAR (20)) 
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (SELECT COUNT(c.`client_id`)
FROM  `clients` AS cl
JOIN `courses` AS c
ON cl.`id` = c.`client_id`
WHERE cl.`phone_number` = phone_num);
END$$
DELIMITER ;
SELECT udf_courses_by_client ('(803) 6386812') as `count`; 
SELECT udf_courses_by_client ('(831) 1391236') as `count`;
SELECT udf_courses_by_client ('(704) 2502909') as `count`;

#EX_11
DELIMITER $$
CREATE PROCEDURE udp_courses_by_address (address_name VARCHAR(100))
BEGIN
    SELECT a.`name`, cl.`full_name`, ( CASE 
WHEN co.`bill` <= 20 THEN 'Low'
WHEN co.`bill` <= 30 THEN 'Medium'
ELSE 'High'  END) AS `level_of_bill`, c.`make`, c.`condition`,ca.`name` AS cat_name 
    FROM `addresses` AS a
    JOIN `courses` AS co
    ON a.`id` = co.`from_address_id`
    JOIN `clients` AS cl
    ON co.`client_id` = cl.`id`
    JOIN `cars` AS c
    ON c.`id`= co.`car_id`  
    JOIN `categories` AS ca
    ON ca.`id`= c.`category_id`  
    WHERE a.`name` = `address_name`
    ORDER BY c.`make`, cl.`full_name`; 
    
END $$
DELIMITER ;
CALL udp_courses_by_address('700 Monterey Avenue');
CALL udp_courses_by_address('66 Thompson Drive');