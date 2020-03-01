CREATE TABLE [music].[utbSongsbyProgram]
(
	[SPID]				INT				IDENTITY (1,1) NOT NULL,
	[ProgramID]         INT				NOT NULL,
	[SongID]            INT				NOT NULL,
    [ActiveFlag]        BIT				CONSTRAINT [utbSongsbyProgramDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
    [InsertDate]		DATETIME		CONSTRAINT [utbSongsbyProgramDefaultInsertDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [InsertUser]		VARCHAR (100)	CONSTRAINT [utbSongsbyProgramDefaultInsertUserSuser_sSame] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]    DATETIME		CONSTRAINT [utbSongsbyProgramDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]    VARCHAR (100)	CONSTRAINT [utbSongsbyProgramDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbSPID] PRIMARY KEY CLUSTERED ([SPID] ASC),
    CONSTRAINT [fk.music.utbSongsbyProgram.music.utbPrograms.ProgramID] FOREIGN KEY ([ProgramID]) REFERENCES [music].[utbPrograms] ([ProgramID]),
	CONSTRAINT [fk.music.utbSongsbyProgram.music.utbSongs.SongID] FOREIGN KEY ([SongID]) REFERENCES [music].[utbSongs] ([SongID])
);
 
 
GO
CREATE TRIGGER [music].[utrLogSongsbyProgram] ON [music].[utbSongsbyProgram]
FOR INSERT,UPDATE
AS
    BEGIN
        DECLARE @INSERTUPDATE VARCHAR(30)
        DECLARE @StartValues    XML = (SELECT * FROM Deleted [Values] for xml AUTO, ELEMENTS XSINIL)
        DECLARE @EndValues      XML = (SELECT * FROM Inserted [Values] for xml AUTO, ELEMENTS XSINIL)
 
        CREATE TABLE #DBCC (EventType varchar(50), Parameters varchar(50), EventInfo nvarchar(max))
 
        INSERT INTO #DBCC
        EXEC ('DBCC INPUTBUFFER(@@SPID)')
 
        --Assume it is an insert
        SET @INSERTUPDATE ='INSERT'
        --If there's data in deleted, it's an update
        IF EXISTS(SELECT * FROM Deleted)
          SET @INSERTUPDATE='UPDATE'
 
        INSERT INTO [adm].[utbLogActivities] ([ActivityType],[TargetTable],[SQLStatement],[StartValues],[EndValues],[User],[LogActivityDate])
        SELECT  @INSERTUPDATE
                ,'[music].[utbSongsbyProgram]'
                ,(SELECT EventInfo FROM #DBCC)
                ,@StartValues
                ,@EndValues
                ,[LastModifyUser]
                ,GETDATE()
        FROM Inserted 
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esta tabla contiene toda la información de las canciones asignadas a cada programa.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram';
 
 
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID de identidad del record.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram', @level2type = N'COLUMN', @level2name = N'SPID';
 
 
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID de indentidad del programa.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram', @level2type = N'COLUMN', @level2name = N'ProgramID';
 
 
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID de la identidad de la canción.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram', @level2type = N'COLUMN', @level2name = N'SongID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Este flag indica si el record esta activo o no.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram', @level2type = N'COLUMN', @level2name = N'ActiveFlag';
 
 
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se inserto el registro.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram', @level2type = N'COLUMN', @level2name = N'InsertDate';
 
 
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Usuario que inserto el registro.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram', @level2type = N'COLUMN', @level2name = N'InsertUser';
 
 
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de la ultima modificación realizada sobre el registro.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram', @level2type = N'COLUMN', @level2name = N'LastModifyDate';
 
 
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre del usuario que realizo la ultima modificación sobre el registro.', @level0type = N'SCHEMA', @level0name = N'music', @level1type = N'TABLE', @level1name = N'utbSongsbyProgram', @level2type = N'COLUMN', @level2name = N'LastModifyUser';