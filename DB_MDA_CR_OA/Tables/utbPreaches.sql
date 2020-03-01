CREATE TABLE [ministry].[utbPreaches]
(
	[PreachID]		 INT			IDENTITY (1, 1) NOT NULL,
	[MinisterID]	 INT			NOT NULL,
    [Title]			 VARCHAR (200)	NOT NULL,
	[Description]	 VARCHAR (MAX)	NULL,
	[Tags]			 VARCHAR (MAX)	NULL,
	[FileData]		 VARBINARY(MAX)	NOT NULL,
	[FileType]	     VARCHAR(10)	NOT NULL,	
	[PreachingDate]	 DATE			NOT NULL,
    [ActiveFlag]     BIT			CONSTRAINT [utbPreachesDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
    [InsertDate]     DATETIME		CONSTRAINT [utbPreachesDefaultInsertDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [InsertUser]     VARCHAR (100)	CONSTRAINT [utbPreachesDefaultInsertUserSuser_sSame] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate] DATETIME		CONSTRAINT [utbPreachesDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser] VARCHAR (100)	CONSTRAINT [utbPreachesDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbPreachID] PRIMARY KEY CLUSTERED ([PreachID] ASC),
	CONSTRAINT [fk.ministry.utbMinisters.ministry.utbPreaches.MinisterID] FOREIGN KEY ([MinisterID]) REFERENCES [ministry].[utbMinisters] ([MinisterID])
);


GO
CREATE TRIGGER [ministry].[utrLogPreaches] ON [ministry].[utbPreaches]
FOR INSERT,UPDATE
AS
	BEGIN
		DECLARE @INSERTUPDATE VARCHAR(30)
		DECLARE @StartValues	XML = (SELECT [PreachID],[MinisterID],[Title],[Description],[Tags],[FileType],[PreachingDate],[ActiveFlag],[InsertDate],[InsertUser],[LastModifyDate],[LastModifyUser] FROM Deleted [Values] for xml AUTO, ELEMENTS XSINIL)
		DECLARE @EndValues		XML = (SELECT [PreachID],[MinisterID],[Title],[Description],[Tags],[FileType],[PreachingDate],[ActiveFlag],[InsertDate],[InsertUser],[LastModifyDate],[LastModifyUser] FROM Inserted [Values] for xml AUTO, ELEMENTS XSINIL)

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
				,'[ministry].[utbPreaches]'
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
@value = N'Esta tabla contiene el detalle de las diferentes predicas.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de la Predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'PreachID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID del ministro que realizo la Predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'MinisterID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Breve descripcion de la Predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Etiquetas que se pueden utilizar para la predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'Tags';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Metadata de la predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = 'FileData';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Tipo de formato en que se guardo la predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = 'FileType';

GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag indica si la predica esta activa o no.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de inserción de la Predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry',
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'InsertDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description',
@value = N'Usuario que inserto la Predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'InsertUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la ultima modificación realizada sobre la Predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del usuario que realizo la ultima modificación sobre la Predica.', 
@level0type = N'SCHEMA', @level0name = N'ministry', 
@level1type = N'TABLE', @level1name = N'utbPreaches', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

