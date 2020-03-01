CREATE TABLE [adm].[utbEvents]
(
	[EventID]			INT				IDENTITY(1,1) NOT NULL,
	[EventTypeID]		INT				NOT NULL,				
	[Subject]			VARCHAR(1000)	NOT NULL,
	[Description]		VARCHAR(MAX)	NULL,
	[StartDate]			DATETIME		NOT NULL,
	[EndDate]			DATETIME		NULL,
	[IsFullDay]			BIT				CONSTRAINT [utbEventsDefaultIsFullDayFalse] DEFAULT ((0)) NOT NULL,
	[ActiveFlag]		BIT				CONSTRAINT [utbEventsDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
    [CreationDate]		DATETIME		CONSTRAINT [utbEventsDefaultCreationDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [CreationUser]		VARCHAR (100)	CONSTRAINT [utbEventsDefaultCreationUserSuser_sSame] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]	DATETIME		CONSTRAINT [utbEventsDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]	VARCHAR (100)	CONSTRAINT [utbEventsDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbEventID] PRIMARY KEY CLUSTERED ([EventID] ASC),
	CONSTRAINT [fk.adm.utbEvents.adm.utbEventTypes.EventTypeID] FOREIGN KEY ([EventTypeID]) REFERENCES [adm].[utbEventTypes] ([EventTypeID])
);

GO
CREATE TRIGGER [adm].[utrLogEvents] ON [adm].[utbEvents]
FOR INSERT,UPDATE
AS
    BEGIN
        DECLARE @INSERTUPDATE VARCHAR(30)
        DECLARE @StartValues    XML = (SELECT * FROM Deleted [Values] FOR XML AUTO, ELEMENTS XSINIL)
        DECLARE @EndValues      XML = (SELECT * FROM Inserted [Values] FOR XML AUTO, ELEMENTS XSINIL)
 
        CREATE TABLE #DBCC (EventType VARCHAR(50), Parameters VARCHAR(50), EventInfo NVARCHAR(MAX))
 
        INSERT INTO #DBCC
        EXEC ('DBCC INPUTBUFFER(@@SPID)')
 
        --Assume it is an insert
        SET @INSERTUPDATE ='INSERT'
        --If there's data in deleted, it's an update
        IF EXISTS(SELECT * FROM Deleted)
          SET @INSERTUPDATE='UPDATE'
 
        INSERT INTO [adm].[utbLogActivities] ([ActivityType],[TargetTable],[SQLStatement],[StartValues],[EndValues],[User],[LogActivityDate])
        SELECT  @INSERTUPDATE
                ,'[adm].[utbEvents]'
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
@value = N'Esta tabla contiene metadata de los diferentes eventos del Ministerio.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'EventID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad del tipo de evento.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'EventTypeID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Titulo del evento.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'Subject';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Breve descripción del evento.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha en que empieza el evento.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'StartDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha en que termina el evento.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'EndDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag indica si el evento es del todo el dia.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'IsFullDay';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag es usado para identificar si la pagina esta active o no.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de creation del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'CreationDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que inserto el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'CreationUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la última modificación sobre el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm',
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que realizo la última modificación del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbEvents', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

