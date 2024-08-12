-- Find the 10 cities with the most public schools. Return the names of the cities and the number of public schools within them,
-- ordered from greatest number of public schools to least.
-- If two cities have the same number of public schools, order them alphabetically.
SELECT "city", COUNT(*) AS "public_schools_per_city" FROM "schools" WHERE "type" = 'Public School'
GROUP BY "city"
ORDER BY "public_schools_per_city" DESC, "city" LIMIT 10;
