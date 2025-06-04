-- Test to verify Claims table and index
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Claims';
SELECT * FROM sys.indexes WHERE name = 'IX_Claims_Columnstore';
