-- Find the name of the player who's been paid the highest salary, of all time.
-- Return a table with two columns, one for the player's first name and one for their last name.
SELECT "first_name", "last_name" FROM "players" WHERE "id" = (
    SELECT "player_id" FROM "salaries" WHERE "salary" = (
        SELECT MAX("salary") FROM "salaries"
    )
);
