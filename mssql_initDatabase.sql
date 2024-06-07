-- Create a login at the server level
CREATE LOGIN openolat WITH PASSWORD = 'openolat';

-- Create a new database
CREATE DATABASE openolat;
GO

-- Switch to the new database
USE openolat;
GO

-- Create a user in the new database for the login
CREATE USER openolat FOR LOGIN openolat;

-- Grant db_owner privileges to the user
ALTER ROLE db_owner ADD MEMBER openolat;