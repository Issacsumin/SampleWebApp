/* ===== Login demo database (SQL Server) ===== */
--IF DB_ID('LoginDemoDb') IS NULL CREATE DATABASE LoginDemoDb;
--GO
--USE LoginDemoDb;
--GO
--IF OBJECT_ID('dbo.PasswordResetTokens') IS NOT NULL DROP TABLE dbo.PasswordResetTokens;
--IF OBJECT_ID('dbo.Users') IS NOT NULL DROP TABLE dbo.Users;
--GO
CREATE TABLE dbo.Users(
UserId INT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
Username NVARCHAR(50) NOT NULL CONSTRAINT UQ_Users_Username UNIQUE,
Email NVARCHAR(100) NOT NULL,
PasswordHash VARBINARY(32) NOT NULL,
PasswordSalt VARCHAR(36) NOT NULL,
IsActive BIT NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT (1),
LastLoginOn DATETIME2 NULL,
CreatedOn DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedOn DEFAULT (SYSUTCDATETIME())
);
CREATE TABLE dbo.PasswordResetTokens(
TokenId INT IDENTITY(1,1) CONSTRAINT PK_PasswordResetTokens PRIMARY KEY,
UserId INT NOT NULL CONSTRAINT FK_PRT_Users REFERENCES dbo.Users(UserId),
Token UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_PRT_Token DEFAULT (NEWID()),
ExpiresOn DATETIME2 NOT NULL,
IsUsed BIT NOT NULL CONSTRAINT DF_PRT_IsUsed DEFAULT (0)
);
GO
CREATE PROCEDURE dbo.usp_GetUserByUsername @Username NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT UserId, Username, PasswordHash, PasswordSalt, IsActive
    FROM dbo.Users WHERE Username = @Username;
END
GO
CREATE PROCEDURE dbo.usp_UpdateLastLogin @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Users SET LastLoginOn = SYSUTCDATETIME() WHERE UserId = @UserId;
END
GO
CREATE PROCEDURE dbo.usp_CreatePasswordResetToken @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserId INT = (SELECT TOP 1 UserId FROM dbo.Users WHERE Email = @Email AND IsActive = 1);
    IF @UserId IS NOT NULL
    BEGIN
        INSERT dbo.PasswordResetTokens (UserId, ExpiresOn) VALUES (@UserId, DATEADD(HOUR, 1, SYSUTCDATETIME()));
        SELECT Token FROM dbo.PasswordResetTokens WHERE TokenId = SCOPE_IDENTITY();
    END
END
GO
CREATE PROCEDURE dbo.usp_GetUsers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT UserId, Username, Email, IsActive, LastLoginOn, CreatedOn FROM dbo.Users ORDER BY UserId;
END
GO

CREATE OR ALTER PROCEDURE dbo.usp_ResetPassword
@Username NVARCHAR(50),
@Email NVARCHAR(100),
@PasswordHash VARBINARY(32),
@PasswordSalt VARCHAR(36)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Users SET PasswordHash = @PasswordHash, PasswordSalt = @PasswordSalt
	WHERE Username = @Username AND Email = @Email AND IsActive = 1;

	SELECT @@ROWCOUNT AS RowsUpdated;   -- 1 = reset done, 0 = details did not match
END
GO

/* Seed users. Password for both: Admin@123 (change after first login) */
DECLARE @s1 VARCHAR(36) = CONVERT(VARCHAR(36), NEWID());
DECLARE @s2 VARCHAR(36) = CONVERT(VARCHAR(36), NEWID());
INSERT dbo.Users (Username, Email, PasswordHash, PasswordSalt) VALUES
 ('admin', 'admin@example.com', HASHBYTES('SHA2_256', @s1 + 'Admin@123'), @s1),
 ('issac', 'issac@example.com', HASHBYTES('SHA2_256', @s2 + 'Admin@123'), @s2);
GO
