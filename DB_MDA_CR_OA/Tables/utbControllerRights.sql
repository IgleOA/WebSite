CREATE TABLE [adm].[utbControllerRights]
(
	[CTRRightID]	 INT           IDENTITY (1,1) NOT NULL,
    [RoleID]         INT           NOT NULL,
    [ControllerID]	 INT           NOT NULL,
	[ReadFlag]		 BIT		   CONSTRAINT [utbControllerRightsDefaultReadFlagIsTrue] DEFAULT ((1)) NOT NULL,
	[WriteFlag]		 BIT		   CONSTRAINT [utbControllerRightsDefaultWriteFlagIsFalse] DEFAULT ((0)) NOT NULL, 
    [ActiveFlag]     BIT           CONSTRAINT [utbControllerRightsDefaultActiveFlagIsTrue] DEFAULT ((1)) NOT NULL,
    [InsertDate]	 DATETIME      CONSTRAINT [utbControllerRightsDefaultInsertDatesysdatetime] DEFAULT (sysdatetime()) NOT NULL,
    [InsertUser]     VARCHAR (100) CONSTRAINT [utbControllerRightsDefaultInsertUsersuser_sname] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate] DATETIME      CONSTRAINT [utbControllerRightsDefaultLastModifyDatesysdatetime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser] VARCHAR (100) CONSTRAINT [utbControllerRightsDefaultLastModifyUsersuser_sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbCTRRightID] PRIMARY KEY CLUSTERED ([CTRRightID] ASC),
    CONSTRAINT [fk.adm.utbControllerRights.adm.utbControllerDirectory.ControllerID] FOREIGN KEY ([ControllerID]) REFERENCES [adm].[utbControllerDirectory] ([ControllerID]),
    CONSTRAINT [fk.adm.utbControllerRights.adm.utbRoles.RoleID] FOREIGN KEY ([RoleID]) REFERENCES [adm].[utbRoles] ([RoleID])
);


GO
CREATE TRIGGER [adm].[utrLogRolesControllersRights] ON [adm].[utbControllerRights]
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
				,'[adm].[utbControllerRights]'
				,(SELECT EventInfo FROM #DBCC)
				,@StartValues
				,@EndValues
				,[LastModifyUser]
				,GETDATE()
		FROM Inserted 
	END


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Esta tabla contiene metadata de los profiles de cada rol dentro de la aplicación.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'CTRRightID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad del rol.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'RoleID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad del controlador.', 
@level0type = N'SCHEMA', 
@level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'ControllerID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag es usado para identificar si el rol tiene derecho de lectura.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'ReadFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag es usado para identificar si el rol tiene derecho de escritura.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'WriteFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag es usado para identificar si la pagina esta active o no.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de inserción del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'InsertDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que inserto el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'InsertUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la última modificación sobre el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm',
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que realizo la última modificación del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbControllerRights', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

