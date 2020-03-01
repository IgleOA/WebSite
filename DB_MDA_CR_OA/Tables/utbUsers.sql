CREATE TABLE [adm].[utbUsers] (
    [UserID]			INT           IDENTITY (1, 1) NOT NULL,
    [FullName]			VARCHAR (50)  NOT NULL,
    [UserName]			VARCHAR (50)  NOT NULL,
	[Email]				VARCHAR	(50)  NOT NULL,
	[PasswordHash]		BINARY (64)	  NOT NULL,
    [ActiveFlag]		BIT           CONSTRAINT [utbUsersDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
	[AuthorizationFlag]	BIT			  CONSTRAINT [utbUsersDefaultAuthorizationFlagFalse] DEFAULT ((0)) NOT NULL,
    [CreationDate]		DATETIME      CONSTRAINT [utbUsersDefaultCreationDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [CreationUser]		VARCHAR (100) CONSTRAINT [utbUsersDefaultCreationUserSuser_sSame] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]	DATETIME      CONSTRAINT [utbUsersDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]	VARCHAR (100) CONSTRAINT [utbUsersDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbUserID] PRIMARY KEY CLUSTERED ([UserID] ASC)
);


GO
CREATE TRIGGER [adm].[utrLogUsers] ON [adm].[utbUsers]
FOR INSERT,UPDATE
AS
	BEGIN
		DECLARE @INSERTUPDATE VARCHAR(30)
		DECLARE @StartValues	XML = (SELECT [UserID],[FullName],[UserName],[Email],[ActiveFlag],[AuthorizationFlag],[CreationDate],[CreationUser],[LastModifyDate],[LastModifyUser] FROM Deleted [Values] for xml AUTO, ELEMENTS XSINIL)
		DECLARE @EndValues		XML = (SELECT [UserID],[FullName],[UserName],[Email],[ActiveFlag],[AuthorizationFlag],[CreationDate],[CreationUser],[LastModifyDate],[LastModifyUser] FROM Inserted [Values] for xml AUTO, ELEMENTS XSINIL)

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
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esta tabla contiene toda la información referente a los diferentes usuarios.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID de identidad del usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre completo del usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'FullName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre de usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'UserName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Email del usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Password encriptado del usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'PasswordHash';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Este flag indica si el usuario esta activo o no.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Este flag indica si el usuario esta autorizado o no.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'AuthorizationFlag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de creacion del usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'CreationDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Usuario que creo el nuevo usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'CreationUser';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de la ultima modificación realizada sobre el usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre del usuario que realizo la ultima modificación sobre el usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbUsers', @level2type = N'COLUMN', @level2name = N'LastModifyUser';

