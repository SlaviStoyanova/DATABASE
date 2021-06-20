#EX_2
INSERT INTO `coaches`(`first_name`, `last_name`,`salary`,`coach_level`)
SELECT `first_name`, `last_name`,`salary` * 2, CHAR_LENGTH(`first_name`)
FROM `players` 
WHERE `age` >= 45;
#EX_3
UPDATE `coaches`
SET `coach_level`= `coach_level` + 1
WHERE LEFT(`first_name`,1) = 'A'
AND `id` IN (SELECT `coach_id` FROM `players_coaches`);
#EX_4
DELETE FROM `players` WHERE `age`>=45;

#EX_5
SELECT `first_name`,`age`,`salary`
 FROM `players`
 ORDER BY `salary` DESC;
 
 #EX_6
 SELECT p.`id`,CONCAT_WS(' ',`first_name`,`last_name`) AS `full_name` , p.`age`, `position`,`hire_date`
 FROM `players` AS p
 JOIN `skills_data` AS sd
 ON sd.`id` = p.`skills_data_id`
 WHERE `age` < 23 AND `hire_date` IS NULL AND sd.`strength` > 50 AND `position` = 'A'
 ORDER BY `salary`, `age`;
 #EX_7
 SELECT t.`name`,t.`established`,t.`fan_base`,COUNT(p.`id`) AS `players_count`
 FROM `teams`AS t
  LEFT JOIN `players` AS p
  ON p.`team_id` = t.`id`
  GROUP BY t.`id`
  ORDER BY `players_count` DESC, t.`fan_base`DESC;
  
 # EX_8
 SELECT MAX(sd.`speed`) AS `max_speed`, t.`name`
 FROM `towns` AS t
 LEFT JOIN `stadiums` AS s
 ON t.`id` =s.`town_id`
 LEFT JOIN `teams` AS te
 ON s.`id` = te.`stadium_id`
 LEFT JOIN `players` AS p
 ON te.id =p.`team_id` 
 LEFT JOIN `skills_data` AS sd
 ON sd.`id` = p.`skills_data_id`
 WHERE te.`name` != 'Devify'
 GROUP BY t.`id`
 ORDER BY `max_speed` DESC, t.`name`;
 
 #EX_9
 SELECT c.name, COUNT(p.`id`)AS `total_count_of_players` ,SUM(p.`salary`) AS `total_sum_of_salaries`
 FROM `countries` AS c
 LEFT JOIN `towns` AS t
 ON c.`id`= t.`country_id`
 LEFT JOIN `stadiums` AS s
 ON t.`id` = `town_id`
 LEFT JOIN `teams` AS te
 ON s.`id` = te.`stadium_id`
 LEFT JOIN `players` AS p
 ON te.`id` = p .`team_id`
 GROUP BY c.id
 ORDER BY `total_count_of_players` DESC, c.`name`;
 
 #EX_10
DELIMITER $$ 
CREATE FUNCTION  udf_stadium_players_count (stadium_name VARCHAR(30)) 
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (SELECT  COUNT(p.id)
FROM stadiums AS s
LEFT JOIN `teams` AS te
 ON s.`id` = te.`stadium_id`
 LEFT JOIN `players` AS p
 ON te.`id` = p .`team_id`
 WHERE s.`name` = `stadium_name`);
END $$
DELIMITER ;
SELECT udf_stadium_players_count ('Jaxworks') as `count`; 

#EX_11
DELIMITER $$
CREATE PROCEDURE udp_find_playmaker (min_dribble_points INT,team_name VARCHAR(45))
BEGIN
SELECT  CONCAT(p.first_name, ' ', p.last_name) AS full_name,p.age,p.salary ,sd.dribbling,sd.speed,t.`name`
FROM `teams` AS t 
JOIN `players` AS p
  ON p.`team_id` = t.`id`
  JOIN `skills_data` AS sd
 ON sd.`id` = p.`skills_data_id`
 WHERE sd.dribbling > min_dribble_points AND t.`name` = team_name
 ORDER BY sd.speed DESC LIMIT 1;

END $$
DELIMITER ;
