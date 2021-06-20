#EX_1
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
		SELECT `first_name`, `last_name`
        FROM `employees`
        WHERE `salary` > 35000
        ORDER BY `first_name`,`last_name`, `employee_id`;
END$$
DELIMITER ; 
CALL usp_get_employees_salary_above_35000();

#EX_2
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above (min_value DECIMAL(19,4))
BEGIN
		SELECT first_name, last_name
        FROM employees
        WHERE salary >= min_value
        ORDER BY first_name,last_name, employee_id;
END$$
DELIMITER ; 
CALL usp_get_employees_salary_above(40000);
CALL usp_get_employees_salary_above (47100);

#EX_3
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(str_string VARCHAR(20))
BEGIN
SELECT `name` 
 FROM `towns`
    WHERE `name` LIKE CONCAT(`str_string`, '%')
    ORDER BY `name`;
    END$$
    DELIMITER ; 
    CALL usp_get_towns_starting_with('b');
    
    #EX_4
    DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town (`town_name` VARCHAR(20))
BEGIN
SELECT e.`first_name`, e.`last_name`
 FROM employees AS e
    JOIN `addresses` AS a 
    USING (`address_id`)
    JOIN `towns` AS t
    ON a.`town_id`=t.`town_id`
    WHERE t.`name` = `town_name`
	ORDER BY e.`first_name`,e.`last_name`, e.`employee_id`;
END$$
DELIMITER ;
CALL usp_get_employees_from_town('Sofia');


#EX_5
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level (salary_emp DECIMAL(19,4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
     RETURN( CASE
		WHEN salary_emp < 30000 THEN 'Low'
		WHEN salary_emp BETWEEN 30000 AND 50000 THEN 'Average'
	    ELSE 'High'
	END );    

END$$
DELIMITER ; 
SELECT  ufn_get_salary_level(12000.00) ;
SELECT  ufn_get_salary_level(41300.00);
SELECT  ufn_get_salary_level(120000.00);

#EX_6
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level (sal_level VARCHAR(10))
BEGIN
	SELECT e.`first_name`, e.`last_name` FROM `employees` AS e
    WHERE `sal_level`= ufn_get_salary_level(e.salary)
    ORDER BY  e.`first_name` DESC, e.`last_name` DESC;
END$$
DELIMITER ;
CALL usp_get_employees_by_salary_level('High');

#EX_7
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))  
RETURNS BIT
DETERMINISTIC
BEGIN
	    RETURN ( SELECT word REGEXP(CONCAT('^[', set_of_letters, ']+$')));
END$$
DELIMITER ; 

SELECT ufn_is_word_comprised('oistmiahf', 'Sofia') ;
SELECT ufn_is_word_comprised('oistmiahf', 'halves');
SELECT ufn_is_word_comprised('bobr', 'Rob');
SELECT ufn_is_word_comprised('pppp', 'Guy');

#EX_8
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN
	SELECT CONCAT( first_name, ' ', last_name) AS full_name
    FROM  account_holders AS ah
    ORDER BY full_name, id;
END $$
DELIMITER ;

CALL usp_get_holders_full_name ();

#EX_9
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(param DOUBLE)
BEGIN
	SELECT first_name, last_name
    FROM account_holders AS ah
    JOIN accounts AS a 
    ON ah.id=a.account_holder_id
    GROUP BY a.account_holder_id
    HAVING SUM(a.balance) > param
    ORDER BY ah.id;
END $$
DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);

#EX_10
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(initial_sum DECIMAL (19,4) , interest_rate DOUBLE , years INT)
RETURNS DECIMAL (19,4)
DETERMINISTIC
BEGIN
RETURN initial_sum * POW((1 +interest_rate),years);
END $$
DELIMITER ;
    
SELECT ufn_calculate_future_value ( 1000, 0.5, 5);

    #EX_11
DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account (account_id INT, interest_rate DECIMAL(19,4))
 BEGIN
 SELECT 
		a.id AS account_id, first_name, last_name, a.balance AS current_balance, 
        (SELECT ufn_calculate_future_value(current_balance, interest_rate ,5))
		AS balance_in_5_years
	FROM accounts AS a
    JOIN account_holders AS ah
    ON a.account_holder_id=ah.id
    WHERE a.id=account_id;
 END $$
DELIMITER ;

CALL usp_calculate_future_value_for_account (1, 0.1);

#EX_12
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL (19,4))
BEGIN
START TRANSACTION;
IF (SELECT COUNT(*) FROM accounts WHERE id= account_id) = 0 OR(money_amount <=0)
 THEN ROLLBACK;
ELSE
UPDATE accounts SET balance = balance  + money_amount
WHERE  id = account_id;
END IF;
END$$
DELIMITER ;
CALL usp_deposit_money(1,10);

#EX_13
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money (account_id INT, money_amount DECIMAL (19,4))
BEGIN
START TRANSACTION;
IF (SELECT COUNT(*) FROM accounts WHERE id= account_id) = 0 OR(money_amount <=0)
 OR((SELECT balance FROM accounts WHERE id = account_id) < money_amount)
 THEN ROLLBACK;
ELSE
UPDATE accounts SET balance = balance  - money_amount
WHERE  id = account_id;
END IF;
END$$
DELIMITER;

#EX_14
DELIMITER $$
CREATE PROCEDURE usp_transfer_money (from_account_id INT,to_account_id INT, money_amount DECIMAL (19,4))
BEGIN
START TRANSACTION;
IF (SELECT COUNT(*) FROM accounts WHERE id= from_account_id) = 0 OR (money_amount <=0) 
 OR((SELECT balance FROM accounts WHERE id = from_account_id) >= money_amount) AND
 (SELECT COUNT(*) FROM accounts WHERE id= to_account_id) = 0 
 OR((SELECT balance FROM accounts WHERE id = to_account_id) < money_amount)
 THEN ROLLBACK;
ELSE
UPDATE accounts SET balance = balance  + money_amount
WHERE  id = to_account_id;
UPDATE accounts 
SET 
    balance = balance - money_amount
WHERE
    id = from_account_id;
END IF;
END$$
DELIMITER ;

CALL usp_transfer_money (1, 2, 20);
CALL usp_transfer_money (2, 1, 20);

#EX_15

CREATE TABLE 	`logs`(
log_id INT AUTO_INCREMENT PRIMARY KEY,
account_id INT ,
old_sum DECIMAL (19,4) ,
new_sum DECIMAL (19,4)
);

DELIMITER $$
CREATE TRIGGER tr_update_accounts
AFTER UPDATE ON `accounts`
FOR EACH ROW
BEGIN
	INSERT INTO `logs`
    (account_id, old_sum, new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);
   
END$$
DELiMITER ;




