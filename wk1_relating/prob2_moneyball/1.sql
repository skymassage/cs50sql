-- Find the average player salary by year. Rturn two columns, one for year and one for average salary.
-- Round the average salary to two decimal places and call the column "average salary" and sort by year in descending order.
SELECT "year", ROUND(AVG("salary"),  2) AS "average salary" FROM "salaries"
JOIN "players" ON "players"."id" = "salaries"."player_id"
GROUP BY "year"
ORDER BY "year" DESC;
