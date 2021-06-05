#EXERCISE 1

CREATE TABLE `employees`(
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `first_name` VARCHAR(250) NOT NULL,
  `last_name` VARCHAR(250) NOT NULL
);

CREATE TABLE `categories`(
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(250) NOT NULL
);

CREATE TABLE `products`(
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(50) NOT NULL,
`category_id` INT NOT NULL
);

#EXERCISE 2

INSERT INTO `employees` (first_name,last_name) VALUES
('IVO', 'IVANOV'),
('DANI','PETROVA'),
('RENI','DENCHEVA');

#EXERCISE 3

ALTER TABLE `employees` 
ADD COLUMN `middle_name` VARCHAR(50);

#EXERCISE 4

ALTER TABLE `products` 
ADD CONSTRAINT  fk_products_categories 
FOREIGN KEY (`category_id`)
REFERENCES `categories`(`id`);

 #EXERCISE 5

ALTER TABLE `employees`
MODIFY COLUMN `middle_name` VARCHAR(100);
