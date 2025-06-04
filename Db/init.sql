-- SQL Server 2019 schema and index for Claims table
CREATE TABLE Claims (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ProviderID NVARCHAR(50),
    MemberSSN NVARCHAR(20),
    PaidAmount DECIMAL(18,2),
    IsFraud BIT
);

-- Optimized columnstore index as per instructions
CREATE NONCLUSTERED COLUMNSTORE INDEX IX_Claims_Columnstore 
ON Claims (ProviderID, MemberSSN, PaidAmount)
WHERE IsFraud IS NOT NULL;
