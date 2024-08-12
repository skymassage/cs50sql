-- Find the home run history of Ken Griffey, born in 1969.
-- Return two columns, one for year and one for home runs and sort by year in descending order.
SELECT "year", "HR" FROM "performances" WHERE "player_id" = (
    SELECT "id" FROM "players" WHERE "first_name" = 'Ken' AND "last_name" = 'Griffey' AND "birth_year" = 1969
) ORDER BY "year" DESC;
