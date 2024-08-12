-- If this is your first time logging into your mysql server, you'll need to create a new database on the server:
CREATE DATABASE IF NOT EXISTS `linkedin`;

-- Run on your the "linkedin" database:
USE `linkedin`;

-- check50 cs50/problems/2024/sql/sentimental/connect

CREATE TABLE `Users` (
    `first_name` VARCHAR(32) NOT NULL,
    `last_name` VARCHAR(32) NOT NULL,
    `username` VARCHAR(32) NOT NULL UNIQUE,
    `password` VARCHAR(32) NOT NULL
);

CREATE TABLE `schools` (

);

CREATE TABLE `companies` (

);

CREATE TABLE `connections` (

);