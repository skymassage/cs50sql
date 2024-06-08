-- Find the user IDs of the top 3 users to whom creativewisdom377 sends messages most frequently.
-- Order the user IDs by the number of messages creativewisdom377 has sent to those users, most to least.
-- Ensure your query uses the search_messages_by_from_user_id index, which is defined as follows.
SELECT "to_user_id" FROM "messages" WHERE "from_user_id" = (
    SELECT "id" FROM "users" WHERE "username" = 'creativewisdom377'
)
GROUP BY "to_user_id"
ORDER BY COUNT("to_user_id") DESC LIMIT 3;
