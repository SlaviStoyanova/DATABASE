
#EX_1
CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40)
);
CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40),
`mountain_id` INT
);
ALTER TABLE `peaks`
ADD CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES `mountains`(`id`);

#EX_2
SELECT 
    c.`id` AS `driver_id`,
    v.`vehicle_type`,
    CONCAT(`first_name`, ' ', `last_name`) AS `driver_name`
FROM
    `campers` AS c
        JOIN
    `vehicles` AS v ON v.`driver_id` = c.`id`;

#EX_3
SELECT 
    r.`starting_point` AS `route_starting_point`,
    r.`end_point` AS `route_ending_point`,
    r.`leader_id`,
    CONCAT(c.`first_name`, ' ', c.`last_name`) AS `leader_name`
FROM
    `routes` AS r
        JOIN
    `campers` AS c ON c.`id` = r.`leader_id`;
    
#EX_4
CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40)
);
CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40),
`mountain_id` INT
);
ALTER TABLE `peaks`
ADD CONSTRAINT `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES `mountains`(`id`)
ON DELETE CASCADE;
