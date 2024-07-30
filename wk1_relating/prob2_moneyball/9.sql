-- Find the 5 lowest paying teams (by average salary) in 2001.
-- Return two columns, one for the teams' names and one for their average salary.
-- Round the average salary column to two decimal places and call it "average salary".
-- Sort the teams by average salary, least to greatest.
SELECT "name", ROUND(AVG("salary"), 2) AS "average salary" FROM "salaries"
JOIN "teams" ON "salaries"."team_id" = "teams"."id"
WHERE "salaries"."year" = 2001
GROUP BY "team_id"
ORDER BY "average salary" LIMIT 5;