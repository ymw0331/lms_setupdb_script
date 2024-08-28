USE elearning;
GO

-- Disable all foreign key constraints
EXEC sp_MSforeachtable @command1="ALTER TABLE ? NOCHECK CONSTRAINT ALL";
GO

-- Drop all foreign key constraints
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += 'ALTER TABLE [' + OBJECT_SCHEMA_NAME(parent_object_id) + '].[' + OBJECT_NAME(parent_object_id) + '] DROP CONSTRAINT [' + name + '];' + CHAR(13)
FROM sys.foreign_keys;
EXEC sp_executesql @sql;
GO

-- Drop all tables
EXEC sp_MSforeachtable @command1="DROP TABLE ?";
GO

-- Drop all views
DECLARE @viewName NVARCHAR(128);
DECLARE viewCursor CURSOR FOR
SELECT [name] FROM sys.views;
OPEN viewCursor;
FETCH NEXT FROM viewCursor INTO @viewName;
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('DROP VIEW [' + @viewName + ']');
    FETCH NEXT FROM viewCursor INTO @viewName;
END
CLOSE viewCursor;
DEALLOCATE viewCursor;
GO

-- Drop all stored procedures
DECLARE @procName NVARCHAR(128);
DECLARE procCursor CURSOR FOR
SELECT [name] FROM sys.objects WHERE type = 'P';
OPEN procCursor;
FETCH NEXT FROM procCursor INTO @procName;
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('DROP PROCEDURE [' + @procName + ']');
    FETCH NEXT FROM procCursor INTO @procName;
END
CLOSE procCursor;
DEALLOCATE procCursor;
GO

-- Drop all functions
DECLARE @funcName NVARCHAR(128);
DECLARE funcCursor CURSOR FOR
SELECT [name] FROM sys.objects WHERE type IN ('FN', 'TF', 'IF');
OPEN funcCursor;
FETCH NEXT FROM funcCursor INTO @funcName;
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('DROP FUNCTION [' + @funcName + ']');
    FETCH NEXT FROM funcCursor INTO @funcName;
END
CLOSE funcCursor;
DEALLOCATE funcCursor;
GO

-- Drop all triggers
DECLARE @triggerName NVARCHAR(128);
DECLARE triggerCursor CURSOR FOR
SELECT [name] FROM sys.triggers;
OPEN triggerCursor;
FETCH NEXT FROM triggerCursor INTO @triggerName;
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('DROP TRIGGER [' + @triggerName + ']');
    FETCH NEXT FROM triggerCursor INTO @triggerName;
END
CLOSE triggerCursor;
DEALLOCATE triggerCursor;
GO

-- Drop all indexes
DECLARE @indexName NVARCHAR(128);
DECLARE @tableName NVARCHAR(128);
DECLARE indexCursor CURSOR FOR
SELECT i.name AS IndexName, t.name AS TableName
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.is_primary_key = 0 AND i.is_unique_constraint = 0; -- Exclude primary keys and unique constraints
OPEN indexCursor;
FETCH NEXT FROM indexCursor INTO @indexName, @tableName;
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('DROP INDEX [' + @indexName + '] ON [' + @tableName + ']');
    FETCH NEXT FROM indexCursor INTO @indexName, @tableName;
END
CLOSE indexCursor;
DEALLOCATE indexCursor;
GO
