-- Find the 50 players paid the least in 2001.
-- Return three columns, one for players'first names, one for their last names, and one for their salaries.
-- First, sort players by salary, lowest to highest. Second, sort alphabetically by first name and then by last name.
-- Finally, sort by player ID.
SELECT "first_name", "last_name", "salary" FROM "players"
JOIN "salaries" ON "salaries"."player_id" = "players"."id"
WHERE "year" = 2001 ORDER BY "salary", "first_name", "last_name", "player_id" LIMIT 50;
