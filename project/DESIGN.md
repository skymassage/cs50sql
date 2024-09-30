# Design Document

By Jiahui Lin

Video overview: https://www.youtube.com/watch?v=32Lz4PZ53dc

## Scope

This database is specially designed for an online shop to store and track data related to basic customer information, items, orders, ratings and watchlists. The data can be used to conduct an analysis of the consumer behaviors and shopping habits.

* **Customers** includes basic customer information for system that can track their orders, watchlists, comments and customer ratings.
* **Items** includes item information for customers to browse.
* **Categories** includes different categories for items to help customers find items.
* **Orders** includes unique customer-order pairs that the system can track orders.
* **Order details** includes order-item pairs and their detailed information: price and number of items ordered.
* **Comments** includes customer-item pairs and comments corresponding to customer-item pairs.
* **Ratings** includes unique customer-item pairs and ratings corresponding to customer-item pairs.
* **Watchlists** includes customer-item pairs that can track which items customers are watching.

The goal of the database is to track customer's orders, ratings, comments, and items and categories of interest, and to analyze customer behavior and shopping habits. Some information including item description, customer's detailed information (like customer's name, contact information), or shipping status are not our concern for analysis, or some are sensitive such as income, biometric information. They are outside the scope of this database.

## Functional Requirements

This database can be used to:

* Create new customers with their information, which can be ustilized for analysis.
* Create new items for customers to browse, show the available items and find the items by category.
* Track orders and their detailed information. 
* Filter the items purchased by customers or items they are interested in based on their personal information.
* Compute the customer ratings for items.

The shop does not support replying to customer questions in comments and they can raise questions by sending emails. This database does not contain detailed information not related to analysis.

## Representation

This databse is built in SQLite with the following entities and relationship:

### Entities

#### Customers
The `customers` table includes:
* `id` represents the unique ID for each customer. This column has the `PRIMARY KEY` constraint applied, setting the ID to a unique `INTEGER`.
* `username` represents the unique username for each customer. Each field in this column is `UNIQUE` and set to `TEXT`.
* `gender` represents the customer's gender. Each field in this column is set to `TEXT`.
* `age` represents the customer's age. Each field in this column is set to an `INTEGER`.
* `city` represents the city where the customer lives.  Each field in this column is set to `TEXT`.

#### Items
The `items` table includes:
* `id` represents the unique ID for each item. This column has the `PRIMARY KEY` constraint applied, setting the ID to a unique `INTEGER`.
* `title` represents the item title. Each field in this column is set to `TEXT`.
* `category_id` uses the item category ID to represent the category of the item. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `categories` table.
* `price` represents the item price.  Each field in this column is set to `NUMERIC`, and has the `CHECK` constraint that only allows `price` above 0.
* `number` represents the number of each item. Each field in this column is set to `INTEGER`, and has the `CHECK` constraint that only allows `number` above 0.
* `creating_time` represents the time when the item was created at. By default, each field in this column is set to the timestamp when the item was created using `DEFAULT CURRENT_TIMESTAMP`.
* `avilable` represents the item status. Each field in this column is set to an `INTEGER`, but with the `CHECK` constraint to ensure that the values in the `avilable` column is 0 or 1, indicating that the item is avilable or not.

#### Categories
The `categories` table includes:
* `id` represents the unique ID for each category. This column has the `PRIMARY KEY` constraint applied, setting the ID to a unique `INTEGER`.
* `name` represents the item category name. Each field in this column is set to `TEXT`.

#### Orders
The `orders` table includes:
* `id` represents the unique ID for each order. This column has the `PRIMARY KEY` constraint applied, setting the ID to a unique `INTEGER`.
* `customer_id` uses the customer ID to track which customer own the order. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `customers` table.
* `creating_time` represents the time when the order was created at. By default, each field in this column is set to the timestamp when the order was created using `DEFAULT CURRENT_TIMESTAMP`.

#### Order details
The `order_details` table includes:
* `order_id` uses the order ID to represent the order. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `orders` table. This column also has the `PRIMARY KEY` constraint applied with the `item_id` column, which consists of unique `order_id`-`item_id` pairs.
* `item_id` uses the item ID to represent the item. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `items` table. This column also has the `PRIMARY KEY` constraint applied with the `order_id` column, which consists of unique `order_id`-`item_id` pairs.
* `price` represent the price of the item in the order. Each field in this column is set to `NUMERIC`, and has the `CHECK` constraint that only allows `price` above 0.
* `number` represent the number of the item in the order. Each field in this column is set to `INTEGER`, and has the `CHECK` constraint that only allows `number` above 0.

#### Comments
The `comments` table includes:
* `id` represents the unique ID for each comment. This column has the `PRIMARY KEY` constraint applied, setting the ID to a unique `INTEGER`.
* `customer_id` uses the customer ID to track which customer made the comment. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `customers` table.
* `item_id` uses the item ID to track which item was commented on. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `items` table.
* `content` represents the content of each comment made by the customer on the item. Each value in this column can correspond to the same `item_id`-`customer_id` pair, which means that a customer can make a comment on the same item again. Each field in this column is set to `TEXT`.
* `creating_time` represents the time when the comment was created at. By default, each field in this column is set to the timestamp when the comment was created using `DEFAULT CURRENT_TIMESTAMP`.

#### Rates
The `ratings` table includes:
* `item_id` uses the item ID to track which item was rated. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `items` table. This column also has the `PRIMARY KEY` constraint applied with the `customer_id` column, which consists of unique `item_id`-`customer_id` pairs.
* `customer_id` uses the customer ID to track which customer rated the item. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `customers` table. This column also has the `PRIMARY KEY` constraint applied with the `item_id` column, which consists of unique `item_id`-`customer_id` pairs.
* `rating` represents the rating of the item rated by the customer. Each value in this column corresponds to a unique `item_id`-`customer_id` pair, which means that a customer cannot rate the same item again. Each field in this column is set to an `INTEGER`, but with the `CHECK` constraint to ensure that the values in the `rating` column is 1, 2, 3, 4, or 5, indicating that the item's rating is high or low.

#### Watchlists
The `watchlists` table includes:
* `customer_id` uses the customer ID to track which customer watches the item. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `customers` table. This column also has the `PRIMARY KEY` constraint applied with the `item_id` column, which consists of unique `customer_id`-`item_id` pairs.
* `item_id` uses the item ID to track which item was watched. This column has the `FOEIGN KEY` constraint applied, referencing the `id` column in the `items` table. This column also has the `PRIMARY KEY` constraint applied with the `customer_id` column, which consists of unique `customer_id`-`item_id` pairs.

### Relationships

This relationships between the entities in this database are described in the fowllowing entity relationship diagram:

![ER Diagram](diagram.png)

* One customer's order can be associated with multiple items in detail.
* Customers are allowed to make mutiple comments on the same item.
* If a customer has rated the item, they are not allowed to rate the same item again.
* If a customer has already added the item to their watchlist, they are not allowed to add the same item to their watchlist again.

## Optimizations

This database create views, indexes, and triggers for optimization:

### Views
* `current_items` displays the current items for administrator to see which items are not yet sold.

### Indexing
* `customer_index` is created for the `gender`, `age`, `city` column in the `customers` table to speed up gender, age, and city searches.
* `item_index` is created for the `price`, `number`, `creating_time`, `avilable` column in the `items` table to speed up price, number, creating time, and avilable searches.
* `category_index` is created for the `name` column in the `categories` table to speed up category searches.
* `rating_index` is created for the `rating` column in the `ratings` table to speed up rating searches.

### Triggers
* `add_item` will insert a new rows into the `items` table to avoid errors when inserting it into the `current_items` view. 
* `update_item` will update the `number` column in the `items` table to avoid errors when updating the number of the item in the `current_items` view. 
* `delete_item` will perform a soft delete by updating the `avilable` column in the `items` table to avoid errors when deleting the item in the `current_items` view. 

## Limitations
* Other useful information may not be taken into account in the schema.
* Administrators should always be careful when using `TRANSACTION` to add multiple items to the order and reduce the number of items at the same time. They must ensure that the number of items ordered cannot be greater than the current number. Because SQLite does not have the command that has both `COMMIT` and `ROLLBACK` syntax, administrators should use `TRANSACTION` with `ROLLBACK` first to ensure that they can revert the database to the pre-transaction state if the number of items ordered is greater than the current number. And then fix the number of items ordered to maka sure that the number of items ordered is not greater than the current number. Finally, use `TRANSACTION` with `COMMIT` to add items to the order and reduce the number of items.