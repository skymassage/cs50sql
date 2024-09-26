# Design Document

By Jiahui Lin

Video overview: <URL HERE>

## Scope

This database is specially designed for an online shop to track and store data related to basic user information, items, orders, item prices, customer rates and watchlists. The data can be used to conduct an analysis of the consumer behaviors and shopping habits.

* **Users** includes basic user information for system that can track their orders, watchlists, comments and user ratings.
* **Items** includes item information for customers to browse.
* **Orders** includes unique user-order pairs that the system can track orders.
* **Order details** includes order-item pairs and their detailed information: price and number of items ordered.
* **Categories** includes different categories for items to help customers find items.
* **Rates** includes unique user-item pairs and ratings corresponding to user-item pairs.
* **Comments** includes user-item pairs and comments corresponding to user-item pairs.
* **Watchlists** includes user-item pairs that can track which items customers are watching.

The goal of the database is to track user's orders, ratings, comments, and items and categories of interest, and to analyze customer behavior and shopping habits. Some information including item description, user's detailed information (like name, contact information), or shipping status are not our concern for analyst, or some are sensitive such as income, biometric information. They are outside the scope of this database.

## Functional Requirements

<!-- What should a user be able to do with your database? -->
* Create new customers with their information, which can be ustilized for analyst.
* Create new items for customers to browse, show the available items and find the items by category.
* Track orders and their detailed information. 
* Filter the items purchased by customers or items they are interested in based on their personal information.
* Compute the user ratings for items.

The shop does not support replying to customer questions in comments and they can raise questions by sending emails. This database does not contain detailed information not related to analyst.

## Representation

### Entities

<!-- * Which entities will you choose to represent in your database?
     * What attributes will those entities have?
     * Why did you choose the types you did?
     * Why did you choose the constraints you did? -->

### Relationships

<!-- Include your entity relationship diagram and describe the relationships between the entities in your database. -->

## Optimizations

<!-- * Which optimizations (e.g., indexes, views) did you create? Why? -->

## Limitations

<!-- * What are the limitations of your design?
     * What might your database not be able to represent very well? -->
Other useful information, such as which items customers viewed, is not considered in this database.
他們可能點錯商品只停留幾秒鐘並無興趣，或可能在沒興趣的商品掛機。
或許需要其他資訊來判別他們在停留的商品是否真的有興趣

Customers cannot reply to the specific user's comment in comment area 或許要用標記的
想要創建在評論區的評論再開一小塊評論讓用戶們互動，但有點複雜

在TRANSACTION中無法設置變數來重複使用
無法同時使用COMMIT與ROLLBACK

I want to the views to show the current orders and hisory orders (顧客已收到商品並沒問題)
所以要在trigger中加入