CREATE TABLE [music].[utbMusicSheetTypes]
(
	[MSTypeID]		 INT           IDENTITY (1, 1) NOT NULL,
    [MSTypeName]     VARCHAR (100) NOT NULL,
    [ActiveFlag]     BIT           CONSTRAINT [utbMusicSheetTypesDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
    [InsertDate]     DATETIME      CONSTRAINT [utbMusicSheetTypesDefaultInsertDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [InsertUser]     VARCHAR (100) CONSTRAINT [utbMusicSheetTypesDefaultInsertUserSuser_sSame] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate] DATETIME      CONSTRAINT [utbMusicSheetTypesDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser] VARCHAR (100) CONSTRAINT [utbMusicSheetTypesDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbMSTypeID] PRIMARY KEY CLUSTERED ([MSTypeID] ASC)
);


GO
CREATE TRIGGER [music].[utrLogMusicSheetTypes] ON [music].[utbMusicSheetTypes]
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
				,'[music].[utbMusicSheetTypes]'
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
@value = N'Esta tabla contiene el detalle de las diferentes tipos de documentos que hay (Cifrados, Partituras, etc).', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMusicSheetTypes';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID del Tipo de documento.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMusicSheetTypes', 
@level2type = N'COLUMN', @level2name = N'MSTypeID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del tipo de documento.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMusicSheetTypes', 
@level2type = N'COLUMN', @level2name = N'MSTypeName';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag indica si el tipo de documento esta activo o no.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMusicSheetTypes', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de creacion del tipo de documento.', 
@level0type = N'SCHEMA', @level0name = N'music',
@level1type = N'TABLE', @level1name = N'utbMusicSheetTypes', 
@level2type = N'COLUMN', @level2name = N'InsertDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description',
@value = N'Usuario que creo el tipo de documento.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMusicSheetTypes', 
@level2type = N'COLUMN', @level2name = N'InsertUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la ultima modificación realizada sobre el tipo de documento.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMusicSheetTypes', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del usuario que realizo la ultima modificación sobre el tipo de documento.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMusicSheetTypes', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

