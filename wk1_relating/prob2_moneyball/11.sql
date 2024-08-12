-- Find the 10 least expensive players per hit in 2001.
-- Return three columns, one for the players' first names, one of their last names, and one called "dollars per hit"
SELECT "first_name", "last_name", ("salary"/"H") AS "dollars per hit" FROM "players"
JOIN "salaries" ON "salaries"."player_id" = "players"."id"
-- Ensure that the salary's year and the performance's year match.
JOIN "performances" ON "performances"."player_id" = "players"."id" AND "salaries"."year" = "performances"."year"
-- You may assume, for simplicity, that a player will only have one salary and one performance in 2001.
-- You can calculate the "dollars per hit" column by dividing a player's 2001 salary by the number of hits they made in 2001.
-- Dividing a salary by 0 hits will result in a NULL value. Avoid the issue by filtering out players with 0 hits.
WHERE "performances"."year" = 2001 AND "dollars per hit" IS NOT NULL
-- Sort the table by the "dollars per hit" column, least to most expensive. If two players have the same "dollars per hit",
-- order by first name, followed by last name, in alphabetical order.
ORDER BY "dollars per hit", "first_name", "last_name" LIMIT 10;

-- Or join tables only with "player_id" and exclude deplicate parts by filtering 2001 on the year column in the "Performance" and "Salary" tables
SELECT "first_name", "last_name", ("salary"/"H") AS "dollars per hit" FROM "players"
JOIN "salaries" ON "salaries"."player_id" = "players"."id"
JOIN "performances" ON "performances"."player_id" = "players"."id"
WHERE "performances"."year" = 2001 AND "salaries"."year" = 2001 AND "dollars per hit" IS NOT NULL
ORDER BY "dollars per hit", "first_name", "last_name" LIMIT 10;