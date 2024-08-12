-- Find the names of schools (public or charter) in the Cambridge school district.
-- Keep in mind that Cambridge, the city, contains a few school districts,
-- but DESE is interested in the district whose name is "Cambridge".
SELECT "name" FROM "schools" WHERE "district_id" = (
    SELECT "id" FROM "districts" WHERE "name" = 'Cambridge'
);
