CREATE TABLE [adm].[utbResetPasswords]
(
	[RSID]			  INT           IDENTITY (1,1) NOT NULL,			  
	[GUID]			  VARCHAR(MAX)  NOT NULL,
    [UserID]		  INT			NOT NULL,
    [ActiveFlag]      BIT			CONSTRAINT [utbResetPasswordsDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
    [InsertDate]      DATETIME		CONSTRAINT [utbResetPasswordsDefaultInsertDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [InsertUser]      VARCHAR (100)	CONSTRAINT [utbResetPasswordsDefaultInsertUserSuser_sSame] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]  DATETIME      CONSTRAINT [utbResetPasswordsDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]  VARCHAR (100) CONSTRAINT [utbResetPasswordsDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbRSID] PRIMARY KEY CLUSTERED ([RSID] ASC),
	CONSTRAINT [fk.adm.utbUsers.adm.utbResetPasswords.UserID] FOREIGN KEY ([UserID]) REFERENCES [adm].[utbUsers] ([UserID])
);

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Esta tabla contiene las autorizaciones para el cambio de contraseña de un usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID del registro.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords', @level2type = N'COLUMN', @level2name = N'RSID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID de validación para el cambio de contraseña.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords', @level2type = N'COLUMN', @level2name = N'GUID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID de identidad del usuario.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords', @level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Este flag indica si la autorización esta activa o no.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords', @level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha en que se solicito la autorización de cambio.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords', @level2type = N'COLUMN', @level2name = N'InsertDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Usuario que solicito la autorizacion de cambio.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords', @level2type = N'COLUMN', @level2name = N'InsertUser';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fecha de la ultima modificación realizada sobre la autorizacion.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords', @level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nombre del usuario que realizo la ultima modificación sobre la autorización.', @level0type = N'SCHEMA', @level0name = N'adm', @level1type = N'TABLE', @level1name = N'utbResetPasswords', @level2type = N'COLUMN', @level2name = N'LastModifyUser';

