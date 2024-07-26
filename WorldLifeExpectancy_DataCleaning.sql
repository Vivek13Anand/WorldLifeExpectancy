SELECT * FROM World_Life_Expectancy.worldlifexpectancy;

SELECT Country, Year, CONCAT(Country, Year)
FROM worldlifexpectancy;

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifexpectancy
GROUP BY Country, Year, CONCAT(Country, Year);

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1 
;

SELECT *
FROM(
		SELECT Row_ID,
        CONCAT(Country, Year),
        ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
        FROM worldlifexpectancy
	) AS Row_table
WHERE Row_Num > 1
;

DELETE FROM worldlifexpectancy
WHERE 
		Row_ID IN(
			SELECT Row_ID
		FROM(
			SELECT Row_ID,
            CONCAT(Country, Year),
            ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
            FROM worldlifexpectancy
            ) AS Row_table
		WHERE Row_Num > 1
);

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

SELECT t1.Country, t1.Year, t1.`Lifeexpectancy`,
	   t2.Country, t2.Year, t2.`Lifeexpectancy`,
       t3.Country, t3.Year, t3.`Lifeexpectancy`,
       ROUND(( t2.`Lifeexpectancy`+ t3.`Lifeexpectancy`)/2, 1)
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Lifeexpectancy` = ''
;

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Lifeexpectancy` = ROUND (( t2.`Lifeexpectancy`+ t3.`Lifeexpectancy`)/2, 1)
WHERE t1.`Lifeexpectancy` = ''
;

