CREATE TABLE [adm].[utbAppDirectory] (
    [ApplicationID]  INT           IDENTITY (1, 1) NOT NULL,
	[MainAppName]	 VARCHAR (50)  NOT NULL,
	[ViewPage]       VARCHAR (50)  NOT NULL,
    [Controller]     VARCHAR (50)  NOT NULL,
    [Order]			 INT		   NOT NULL,
	[Description]	 VARCHAR (MAX) NULL,
    [ActiveFlag]     BIT           CONSTRAINT [utbAppDirectoryDefaultActiveFlagIsTrue] DEFAULT ((1)) NOT NULL,
    [CreationDate]   DATETIME      CONSTRAINT [utbAppDirectoryDefaultCreationDateSysDatetime] DEFAULT (sysdatetime()) NOT NULL,
    [CreationUser]   VARCHAR (100) CONSTRAINT [utbAppDirectoryDefaultCreationUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate] DATETIME      CONSTRAINT [utbAppDirectoryDefaultLastModifyDatesysdatetime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser] VARCHAR (100) CONSTRAINT [utbAppDirectoryDefaultLastModifyUsersuser_sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbApplicationID] PRIMARY KEY CLUSTERED ([ApplicationID] ASC)
);
GO

CREATE TRIGGER [adm].[utrLogAppDirectory] ON [adm].[utbAppDirectory]
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
				,'[adm].[utbAppDirectory]'
				,(SELECT EventInfo FROM #DBCC)
				,@StartValues
				,@EndValues
				,[LastModifyUser]
				,GETDATE()
		FROM	Inserted
	END

GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Esta tabla contiene metadata de los diferente sites que hay dentro de una applicacion.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'ApplicationID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre de la aplicación Principal (en caso de que se utilice esta base de datos para mas de una aplicación).', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'MainAppName';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre de la página principal.', 
@level0type = N'SCHEMA', 
@level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'ViewPage';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del controlador a la que pertenece.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory',
@level2type = N'COLUMN', @level2name = N'Controller';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Valor que determina el orden en que deben aparecer los links.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'Order';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Breve descripción de la aplicación.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag es usado para identificar si la pagina esta active o no.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de creation del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'CreationDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que inserto el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'CreationUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la última modificación sobre el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm',
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que realizo la última modificación del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbAppDirectory', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

