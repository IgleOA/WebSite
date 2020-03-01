CREATE TABLE [ministry].[utbMinisters]
(
	[MinisterID]	 INT           IDENTITY (1, 1) NOT NULL,
    [MinisterName]	 VARCHAR (100) NOT NULL,
    [ActiveFlag]     BIT           CONSTRAINT [utbMinistersDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
    [InsertDate]     DATETIME      CONSTRAINT [utbMinistersDefaultInsertDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [InsertUser]     VARCHAR (100) CONSTRAINT [utbMinistersDefaultInsertUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate] DATETIME      CONSTRAINT [utbMinistersDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser] VARCHAR (100) CONSTRAINT [utbMinistersDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbMinisterID] PRIMARY KEY CLUSTERED ([MinisterID] ASC)
);


GO
CREATE TRIGGER [ministry].[utrLogMinisters] ON [ministry].[utbMinisters]
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
				,'[ministry].[utbMinisters]'
				,(SELECT EventInfo FROM #DBCC)
				,@StartValues
				,@EndValues
				,[LastModifyUser]
				,GETDATE()
		FROM Inserted
	END;


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Esta tabla contiene la informacion de todos los ministros que tienen algun material en la aplicación.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbMinisters';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID del Ministro.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbMinisters', 
@level2type = N'COLUMN', @level2name = N'MinisterID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del Ministro.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbMinisters', 
@level2type = N'COLUMN', @level2name = N'MinisterName';			 


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag indica si el ministro esta activo o no.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbMinisters', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de inserción del ministro.', 
@level0type = N'SCHEMA', @level0name = N'ministry',
@level1type = N'TABLE', @level1name = N'utbMinisters', 
@level2type = N'COLUMN', @level2name = N'InsertDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description',
@value = N'Usuario que inserto el ministro.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbMinisters', 
@level2type = N'COLUMN', @level2name = N'InsertUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la ultima modificación realizada sobre el ministro.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbMinisters', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del usuario que realizo la ultima modificación sobre el Ministro.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbMinisters', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

