-- Create a login at the server level
CREATE LOGIN elearning WITH PASSWORD = 'elearning';

-- Create a new database
CREATE DATABASE elearning;
GO

-- Switch to the new database
USE elearning;
GO

-- Create a user in the new database for the login
CREATE USER elearning FOR LOGIN elearning;

-- Grant db_owner privileges to the user
ALTER ROLE db_owner ADD MEMBER elearning;
