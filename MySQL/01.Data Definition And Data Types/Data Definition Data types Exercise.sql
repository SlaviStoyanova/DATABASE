
CREATE DATABASE `minions`;
USE `minions`;

#EX_1
CREATE TABLE `minions`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL,
`age` INT 
);

CREATE TABLE `towns`(
`town_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);

#EX_2
ALTER TABLE `towns`
DROP COLUMN `town_id`,
ADD COLUMN `id` INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE `minions`
ADD COLUMN `town_id` INT,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (`town_id`)
REFERENCES `towns`(id);

#EX_3
INSERT INTO `towns`(`id`, `name`)
VALUES
 (1, 'Sofia'),
 (2, 'Plovdiv'),
 (3, 'Varna');

INSERT INTO `minions` (`id`, `name`, `age`,`town_id`)
VALUES 
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

#EX_4
TRUNCATE `minions`;

#Ex_5
DROP TABLES `towns`, `minions`;

#Ex_6
CREATE TABLE `people`(
`id`INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(200) NOT NULL,
`picture` BLOB,
`height` FLOAT(5, 2),
`weight` FLOAT(5, 2),
`gender` CHAR(1) NOT NULL,
`birthdate` DATE NOT NULL,
`biography` TEXT
);
INSERT INTO `people`(`name`, `gender`, `birthdate`)
VALUES
( 'Ivo', 1, '1982-12-01'),
('Iva',2,'1983-04-02'),
('Ivan', 1,'1984-02-14'),
('Ina', 2,'1981-01-14'),
('Ani', 2,'1991-01-18');

#EX_7
CREATE TABLE `users`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`username` VARCHAR(30) NOT NULL,
`password` VARCHAR(26) NOT NULL,
`profile_picture` BLOB,
`last_login_time` DATETIME,
`is_deleted` BOOLEAN NOT NULL
);

INSERT INTO `users` (`username`, `password`, `is_deleted`)
VALUES 
('anika123', 'dnhj78_MT', true),
('Monnika127', 'Mij78_MD', false),
('nika1298', 'Jj78_12', false),
('Dani1998', 'Jki78_8', false),
('Dan1999', 'Jkihj8_8', false);

#EX_8
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (`id`, `username`);

#EX_9
ALTER TABLE `users`
MODIFY COLUMN `last_login_time` DATETIME DEFAULT CURRENT_TIMESTAMP;

#EX_10
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
 PRIMARY KEY(`id`),
 ADD CONSTRAINT `username` UNIQUE (`username`);
 
 #EX_11
 CREATE DATABASE `movies`;
 USE `movies`;
 
 CREATE TABLE `directors`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `director_name` VARCHAR (50) NOT NULL,
 `notes` TEXT
 );
 
 CREATE TABLE `genres`(
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `genre_name` VARCHAR(50) NOT NULL,
   `notes` TEXT
 );
 
 CREATE TABLE `categories`(
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `category_name` VARCHAR(50) NOT NULL,
   `notes` TEXT  
 );
 
 CREATE TABLE `movies`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `title` VARCHAR (50) NOT NULL,
 `director_id` INT,
 `copyright_year` INT,
 `length` INT,
 `genre_id` INT,
 `category_id` INT,
 `rating` INT,
 `notes` TEXT
 );
 
 INSERT INTO `directors` (`director_name`)
 VALUES
 ('Martin Scorsese'),
 ('Steven Spielberg'),
 ('Stanley Kubrick'),
 ('Quentin Tarantino'),
 ('Alfred Hitchcock');
 
 INSERT INTO `genres` (`genre_name`)
 VALUES 
 ('Comedy'),
 ('ACTION'),
 ('Mystery'),
 ('Romance'),
 ('Drama');
 
 INSERT INTO `categories` (`category_name`)
 VALUES
 ('animation'),
 ('musical'),
 ('western'),
 ('documentary'),
 ('history');
 
 INSERT INTO `movies` (`title`, `director_id`, `copyright_year`, `genre_id`, `category_id`,`rating`)
 VALUES 
 ('Django', 4, 1992,2,3,8),
 ('Goodfelass',1,1990,5,5,9),
 ('Killers kiss',3,1955,1,4,5),
 ('Psycho',5,1960, 3,2,7),
 ('Indiana Jones and the temple of Doom',2,1984,2,5,9);
 
 #EX_12
 CREATE DATABASE `car_rental`;
 USE `car_rental`;
 
 CREATE TABLE `categories`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `category` VARCHAR (50) NOT NULL,
 `daily_rate` DECIMAL(8,2),
 `weekly_rate` DECIMAL(8,2),
 `monthly_rate` DECIMAL(8,2),
 `weekend_rate` DECIMAL (8,2) 
 );
 
 CREATE TABLE `cars`(
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `plate_number` VARCHAR (50) NOT NULL,
  `make` VARCHAR (50),
  `model` VARCHAR (50),
  `car_year` INT (4),
  `category_id` INT (11),
	`doors` INT (1),
    `car_condition` VARCHAR (50),
    `available` BOOLEAN,
    CONSTRAINT fk_cars_categories FOREIGN KEY (`category_id`) 
    REFERENCES `categories`(`id`)  
 );
 
 CREATE TABLE `employees`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `first_name` VARCHAR (30),
 `last_name` VARCHAR (30),
 `title` VARCHAR (30),
 `notes` TEXT
 );
 
 CREATE TABLE `customers`( 
 `id`INT PRIMARY KEY AUTO_INCREMENT,
 `driver_licence_number` INT NOT NULL,
 `full_name` VARCHAR (50),
 `address` VARCHAR (50),
 `city` VARCHAR (30),
 `zip_code` VARCHAR(10), 
 `notes` TEXT
 );
 
 CREATE TABLE `rental_orders` (
 `id` INT PRIMARY KEY AUTO_INCREMENT,
`employee_id` INT,
 `customer_id` INT,
 `car_id` INT, 
 `car_condition`VARCHAR (50),
 `tank_level` INT,
 `kilometrage_start` INT,
 `kilometrage_end` INT,
 `total_kilometrage` INT,
 `start_date` DATE,
 `end_date` INT, 
 `total_days` INT,
 `rate_applied` INT(3),
 `tax_rate` DECIMAL(5,2),
 `order_status` VARCHAR (50),
 `notes` TEXT
 );
 
 INSERT INTO `categories`(`category`)
 VALUES
 ('Sport'),('Limuzine'),('Jeep');
 INSERT INTO `cars` (`plate_number`)
 VALUES
 ('1234'),
 ('3456'),
 ('232323');
INSERT INTO `customers`(`driver_licence_number`)
VALUES
('34456'),
('5567'),
('78987');
INSERT INTO `employees` (`first_name`,`last_name`)
VALUES
('Ivo','Ivanov'),
('Desi', 'Asenova'),
('Miro','Dobrev');
INSERT INTO `rental_orders`(`employee_id`, `car_id`)
VALUES
(1,1),
(1,2),
(2,3);
 
 
 
 
 
 
 
 #EX_13
 CREATE DATABASE `soft_uni`;
 USE `soft_uni`;
 
 CREATE TABLE `towns`(
`id`  INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
 );
 
 CREATE TABLE `addresses`(
 `id`  INT PRIMARY KEY AUTO_INCREMENT,
 `address_text` VARCHAR(100)NOT NULL,
 `town_id` INT NOT NULL,
 CONSTRAINT fk_addresses_towns
 FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`)
 );
 
 CREATE TABLE `departments`(
 `id`  INT PRIMARY KEY AUTO_INCREMENT,
 `name` VARCHAR (30) NOT NULL
 );
 
 CREATE TABLE `employees`(
  `id`  INT PRIMARY KEY AUTO_INCREMENT,
  `first_name` VARCHAR (30) NOT NULL,
  `middle_name` VARCHAR (30) NOT NULL,
  `last_name` VARCHAR (30) NOT NULL,
  `job_title` VARCHAR (30) ,
  `department_id` INT,
  `hire_date` DATE,
  `salary` DECIMAL (10,2),
  `address_id` INT,
  CONSTRAINT fk_employees_deparments
  FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`),
  CONSTRAINT fk_empolyees_addresses
  FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`)
 );
 
 INSERT INTO `towns`(`name`)
 VALUES 
 ('Sofia'), 
 ('Plovdiv'), 
 ('Varna'),
 ('Burgas');
  
 INSERT INTO `departments`(`name`)
 VALUES
 ('Engineering'),
 ('Sales'),
 ('Marketing'),
 ('Software Development'),
 ('Quality Assurance');
 
 INSERT INTO `employees`(`id`, `first_name`, `middle_name`, `last_name`, `job_title`,`department_id`, `hire_date`, `salary`)
 VALUES
 (1, 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer',4, '2013-02-01', '3500.00'),
 (2, 'Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', '4000.00'),
 (3, 'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', '525.25'),
 (4, 'Georgi', 'Terziev', 'Ivanov', 'CEO',2, '2007-12-09', '3000.00'),
 (5, 'Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', '599.88');
 
 #EX_14
 SELECT * FROM `towns`;
 SELECT * FROM `departments`;
 SELECT * FROM `employees`;
 
 #EX_15
 SELECT * FROM `towns` 
 ORDER BY `name` ASC;
 SELECT * FROM `departments`
 ORDER BY `name` ASC;
 SELECT * FROM employees
 ORDER BY `salary` DESC;
 
 #EX_16
  SELECT `name` FROM `towns` 
 ORDER BY `name`;
 SELECT `name` FROM `departments`
 ORDER BY `name` ASC;
 SELECT `first_name`, `last_name`, `job_title`, `salary` FROM employees
 ORDER BY `salary` DESC;
 
 #EX_17
 
 UPDATE `employees`
 SET `salary` = `salary`* 1.1;

SELECT `salary` FROM `employees`;








