-- The "LIKE" keyword is used to select data that roughly matches the specified string. 
-- For example, LIKE could be used to select books that have a certain word or phrase in their title.
-- "LIKE" is combined with the operators '%' (matches any characters around a given string) and '_' (matches a single character).

-- Find all books with "love" in the title
SELECT "title" FROM "longlist" WHERE "title" LIKE '%love%'; -- Note that by convention we tend to use '' for strings.

-- Find all books that begin with "The" (includes "There", "Their", "They", etc.)
SELECT "title" FROM "longlist" WHERE "title" LIKE 'The%';

-- Find all books that begin with "The "
SELECT "title" FROM "longlist" WHERE "title" LIKE 'The %';

-- Find all books whose titles begin with "The" and have "of" somewhere in the middle, i.e., "The...of..."
SELECT "title" FROM "longlist" WHERE "title" LIKE 'The%of%';

-- Find a book whose title unsure how to spell and have only four characters (includes "Pore" or "Pure", etc.)
SELECT "title" FROM "longlist" WHERE "title" LIKE 'P_re';

-- Find a book that begins with 'T' and has only four characters
SELECT "title" FROM "longlist" WHERE "title" LIKE 'T___';

-- Find all books titled "_h_..." using both '_' and '%'
SELECT "title" FROM "longlist" WHERE "title" LIKE '_h_%';

-- LIKE is "NOT" case-sensitive 
SELECT "title" FROM "longlist" WHERE "title" LIKE 'PYRE';
-- '=' is case-sensitve and has no effect with '%' and '_'
SELECT "title" FROM "longlist" WHERE "title" = 'PYRE';
