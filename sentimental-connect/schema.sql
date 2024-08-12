-- If this is your first time logging into your mysql server, you'll need to create a new database on the server:
CREATE DATABASE IF NOT EXISTS `linkedin`;

-- Run on your the "linkedin" database:
USE `linkedin`;

-- check50 cs50/problems/2024/sql/sentimental/connect

CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT,
    `first_name` VARCHAR(32) NOT NULL,
    `last_name` VARCHAR(32) NOT NULL,
    `username` VARCHAR(32) NOT NULL UNIQUE,
    `password` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `schools` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    `type` ENUM('Primary', 'Secondary', 'Higher Education'),
    `location` VARCHAR(32) NOT NULL,
    `year_founded` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `companies` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    `industry` ENUM('Technology', 'Education', 'Business'),
    `location` VARCHAR(32) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `people_connections` (
    `id` INT AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `following_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`following_id`) REFERENCES `users`(`id`),
    CONSTRAINT `unique_connection` UNIQUE (`user_id`, `following_id`)
);

CREATE TABLE `school_connections` (
    `id` INT AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `school_id` INT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `degree_type` VARCHAR(32),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`),
    CONSTRAINT `unique_school_connection` UNIQUE (`user_id`, `school_id`)
);

CREATE TABLE `company_connections` (
    `id` INT AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `company_id` INT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `Users`(`id`),
    FOREIGN KEY (`company_id`) REFERENCES `Companies`(`id`),
    CONSTRAINT `unique_company_connection` UNIQUE (`user_id`, `company_id`)
);