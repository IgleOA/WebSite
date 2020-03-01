CREATE TABLE [adm].[utbEventTypes]
(
	[EventTypeID]		INT				IDENTITY(1,1) NOT NULL,
	[EventTypeName]		VARCHAR(100)	NOT NULL,
	[ThemeColor]		VARCHAR(100)	NULL,
	[ActiveFlag]		BIT				CONSTRAINT [utbEventTypesDefaultActiveFlagIsTrue] DEFAULT ((1)) NOT NULL,
    [CreationDate]		DATETIME		CONSTRAINT [utbEventTypesDefaultCreationDateSysDatetime] DEFAULT (sysdatetime()) NOT NULL,
    [CreationUser]		VARCHAR (100)	CONSTRAINT [utbEventTypesDefaultCreationUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]	DATETIME		CONSTRAINT [utbEventTypesDefaultLastModifyDatesysdatetime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]	VARCHAR (100)	CONSTRAINT [utbEventTypesDefaultLastModifyUsersuser_sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbEventTypeID] PRIMARY KEY CLUSTERED ([EventTypeID] ASC)
);
GO

CREATE TRIGGER [adm].[utrLogEventTypes] ON [adm].[utbEventTypes]
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
				,'[adm].[utbEventTypes]'
				,(SELECT EventInfo FROM #DBCC)
				,@StartValues
				,@EndValues
				,[LastModifyUser]
				,GETDATE()
		FROM Inserted I
	END

GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Esta tabla contiene metadata de los diferente sites que hay dentro de una applicacion.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEventTypes';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEventTypes', 
@level2type = N'COLUMN', @level2name = N'EventTypeID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Tipo de evento.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEventTypes', 
@level2type = N'COLUMN', @level2name = N'EventTypeName';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Color de identificación para el tipo de evento.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEventTypes', 
@level2type = N'COLUMN', @level2name = N'ThemeColor';



GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag es usado para identificar si la pagina esta active o no.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEventTypes', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de creation del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEventTypes', 
@level2type = N'COLUMN', @level2name = N'CreationDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que inserto el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEventTypes', 
@level2type = N'COLUMN', @level2name = N'CreationUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la última modificación sobre el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm',
@level1type = N'TABLE', @level1name = N'utbEventTypes', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que realizo la última modificación del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEventTypes', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

