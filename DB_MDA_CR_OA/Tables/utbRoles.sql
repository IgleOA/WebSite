CREATE TABLE [adm].[utbRoles] (
    [RoleID]          INT           IDENTITY (1, 1) NOT NULL,
	[ApplicationID]	  INT			NOT NULL,
    [RoleName]        VARCHAR (50)  NOT NULL,
    [RoleDescription] VARCHAR (MAX) NOT NULL,
    [ActiveFlag]      BIT           CONSTRAINT [utbRolesDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
    [CreationDate]    DATETIME      CONSTRAINT [utbRolesDefaultCreationDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [CreationUser]    VARCHAR (100) CONSTRAINT [utbRolesDefaultCreationUserSuser_sSame] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]  DATETIME      CONSTRAINT [utbRolesDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]  VARCHAR (100) CONSTRAINT [utbRolesDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbRoleID] PRIMARY KEY CLUSTERED ([RoleID] ASC),
	CONSTRAINT [fk.adm.utbRoles.adm.utbAppDirectory.ApplicationID] FOREIGN KEY ([ApplicationID]) REFERENCES [adm].[utbAppDirectory] ([ApplicationID])
);


GO
CREATE TRIGGER [adm].[utrLogRoles] ON [adm].[utbRoles]
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
				,'[adm].[utbRoles]'
				,(SELECT EventInfo FROM #DBCC)
				,@StartValues
				,@EndValues
				,[LastModifyUser]
				,GETDATE()
		FROM	Inserted
	END
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esta tabla contiene toda la información referente a los diferentes roles.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID de identidad del rol.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'RoleID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID de identidad de la aplicación a la que pertenece el rol.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'ApplicationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre del Rol.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'RoleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Breve descripción del Rol.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'RoleDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Este flag indica si el rol esta activo o no.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de creacion del rol.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'CreationDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Usuario que creo el Rol.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'CreationUser';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de la ultima modificación realizada sobre el rol.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre del usuario que realizo la ultima modificación sobre el rol.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbRoles', @level2type = N'COLUMN', @level2name = N'LastModifyUser';

