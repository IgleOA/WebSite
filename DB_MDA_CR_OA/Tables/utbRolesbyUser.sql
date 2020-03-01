CREATE TABLE [adm].[utbRolesbyUser] (
	[RoleUserID]		INT				IDENTITY (1, 1) NOT NULL,
	[UserID]			INT				NOT NULL,
	[RoleID]			INT				NOT NULL,
	[ActiveFlag]		BIT				CONSTRAINT [utbRolesbyUserDefaultActiveFlagTrue]			DEFAULT ((1)) NOT NULL,
    [CreationDate]		DATETIME		CONSTRAINT [utbRolesbyUserDefaultCreationDateSysDateTime]	DEFAULT (sysdatetime()) NOT NULL,
    [CreationUser]		VARCHAR(100)	CONSTRAINT [utbRolesbyUserDefaultCreationUserSuser_sSame]	DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]	DATETIME		CONSTRAINT [utbRolesbyUserDefaultLastModifyDateSysDateTime]	DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]	VARCHAR (100)	CONSTRAINT [utbRolesbyUserDefaultLastModifyUserSuser_Sname]	DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbRoleUserID]			PRIMARY KEY CLUSTERED ([RoleUserID] ASC),
	CONSTRAINT [fk.adm.utbRolesbyUser.adm.utbUsers.UserID]					FOREIGN KEY ([UserID])			REFERENCES [adm].[utbUsers] ([UserID]),
	CONSTRAINT [fk.adm.utbRolesbyUser.adm.utbRoles.RoleID]					FOREIGN KEY ([RoleID])			REFERENCES [adm].[utbRoles] ([RoleID])
);


GO
CREATE TRIGGER [adm].[utrRolesbyUser] ON [adm].[utbRolesbyUser]
FOR INSERT,UPDATE
AS
	BEGIN
		DECLARE @INSERTUPDATE VARCHAR(30)
		DECLARE @StartValues	XML = (SELECT * FROM Deleted [Values] for xml AUTO, ELEMENTS XSINIL)
		DECLARE @EndValues		XML = (SELECT * FROM Inserted [Values] for xml AUTO, ELEMENTS XSINIL)

		CREATE TABLE #DBCC (EventType varchar(50), Parameters varchar(50), EventInfo nvarchar(max))

		INSERT INTO #DBCC
		EXEC ('DBCC INPUTBUFFER(@@SPID)')

		--Assume it is an insert
		SET @INSERTUPDATE ='INSERT'
		--If there's data in deleted, it's an update
		IF EXISTS(SELECT * FROM Deleted)
		  SET @INSERTUPDATE='UPDATE'

		INSERT INTO [adm].[utbLogActivities] ([ActivityType],[TargetTable],[SQLStatement],[StartValues],[EndValues],[User],[LogActivityDate])
		SELECT	@INSERTUPDATE
				,'[adm].[utbUsers]'
				,(SELECT EventInfo FROM #DBCC)
				,@StartValues
				,@EndValues
				,[LastModifyUser]
				,GETDATE()
		FROM	Inserted
	END;