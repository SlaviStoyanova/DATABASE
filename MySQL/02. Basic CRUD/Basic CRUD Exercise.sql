#EX_1
SELECT * FROM soft_uni.departments
ORDER BY `department_id`;

#EX_2
SELECT `name` FROM `departments`
ORDER BY `department_id`;

#EX_3
SELECT `first_name`, `last_name`, `salary`
 FROM `employees`;
 
 #EX_4
 SELECT `first_name`, `middle_name`, `last_name` FROM `employees`;
 
 #EX_5
 SELECT CONCAT(`first_name`, '.',`last_name`, '@softuni.bg') 
 AS 'full_email_address'
 FROM `employees`;
 
 #EX_6
 SELECT DISTINCT `salary` FROM `employees`;
 
 #EX_7
 SELECT * FROM `employees`
 WHERE `job_title` = 'Sales Representative';
 
 #EX_8
 SELECT `first_name`, `last_name`, `job_title`
 FROM `employees`
 WHERE `salary` BETWEEN 20000 AND 30000;
 
 #EX_9
 SELECT CONCAT_WS(' ',`first_name`, `middle_name`,`last_name`) AS `Full_Name`
 FROM `employees`
 WHERE `salary` IN (25000, 14000, 12500, 23600);
 
 #EX_10
 SELECT `first_name`,`last_name` FROM `employees`
 WHERE `manager_id` IS NULL;
 
 #EX_11
 SELECT `first_name`, `last_name`, `salary`
 FROM `employees`
 WHERE `salary` > 50000 
 ORDER BY `salary` DESC;
 
 #EX_12
 SELECT `first_name`, `last_name`
 FROM `employees`
 ORDER BY `salary` DESC
 LIMIT 5;
 
 #EX_13
 SELECT `first_name`, `last_name`
  FROM `employees`
  WHERE `department_id` != 4;
  
  #EX_14
  SELECT * FROM `employees`
  ORDER BY `salary` DESC, `first_name`,`last_name` DESC, `middle_name`;
  
  #EX_15
  CREATE VIEW `v_employees_salaries` AS
  SELECT `first_name`, `last_name` ,`salary`
  FROM `employees`;
  SELECT * FROM  `v_employees_salaries`;

#EX_16
CREATE VIEW v_employees_job_titles AS
SELECT CONCAT_WS(' ',`first_name`,`middle_name`, `last_name`) AS 'full_name',
`job_title` FROM `employees`;
SELECT * FROM v_employees_job_titles ;

#EX-17
SELECT DISTINCT `job_title`
 FROM `employees`
 ORDER BY `job_title` ;
 
 #EX_18
 SELECT * FROM `projects`
 ORDER BY `start_date`, `name`,`project_id`
 LIMIT 10;
 
 #EX_19
 SELECT `first_name`,`last_name`, `hire_date` FROM `employees`
 ORDER BY `hire_date` DESC
 limit 7;
 
 #EX_20
 UPDATE `employees`
 SET `salary` = `salary` * 1.12
 WHERE `department_id` IN (1,2,4,11);
 SELECT `salary` FROM `employees`;
 
 #EX_21
 SELECT `peak_name` FROM `peaks`
 ORDER BY `peak_name`;
 
 
 #EX_22
 SELECT `country_name`, `population`
 FROM `countries`
 WHERE `continent_code` = 'EU'
 ORDER BY `population` DESC, `country_name`
 LIMIT 30 ;
 
 #EX_23
  SELECT `country_name`, `country_code`,
  IF(`currency_code` ='EUR', 'Euro', 'Not Euro') AS `currency`
 FROM `countries`
 ORDER BY `country_name`;
 
 #EX_24
 SELECT `name` FROM `characters`
 ORDER BY `name`;
 
 
 
 
 
 



  
 

