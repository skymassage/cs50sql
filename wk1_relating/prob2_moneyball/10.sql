-- Return a table with five columns:
-- All player's first names, last names, salaries, home runs, and the year in which the player was paid that salary and hit those home runs.
-- The salary's year and the performance's year match.
-- Order the results by player's IDs (least to greatest) and then by year in descending order.
-- A player may have multiple salaries or performances for a given year.
-- Order them first by number of home runs, in descending order, followed by salary, in descending order.
SELECT "first_name", "last_name", "salary", "HR", "performances"."year" FROM "players"
JOIN "performances" ON "performances"."player_id" = "players"."id"
JOIN "salaries" ON "salaries"."player_id" = "players"."id" AND "salaries"."year" = "performances"."year"
ORDER BY "players"."id" ASC,"salaries"."year" DESC,"HR" DESC, "salary" DESC;