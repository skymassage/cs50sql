-- Find Cal Ripken's salary history. Return two columns, one for year and one for salary and sort by year in descending order.
SELECT "year", "salary" FROM "salaries" WHERE "player_id" = (
    SELECT "id" FROM "players" WHERE "first_name" = 'Cal' AND "last_name" = 'Ripken'
) ORDER BY "year" DESC;
