#EX_1
SELECT `title`
 FROM `books`
WHERE  SUBSTR(`title`,1,3)='The';

#EX_2
SELECT REPLACE(`title`, 'The', '***') AS `title`
FROM `books`
WHERE SUBSTR(`title`, 1, 3)= 'The'
ORDER BY `id`;

#EX_3
SELECT ROUND(SUM(`cost`), 2) 
FROM `books`;

#EX_4
SELECT CONCAT_WS(' ',`first_name`, `last_name`) AS 'Full Name',
 TIMESTAMPDIFF (DAY,`born`, `died`) AS 'Days Lived'
FROM `authors`;

#EX_5
SELECT `title` FROM `books`
WHERE `title` LIKE '%HARRY%';
