
USE [FileManager]
GO

DROP TABLE Action
GO
CREATE TABLE [dbo].[Action](
	[Id]            [tinyint] NULL,
	[Name]          [varchar](50) NULL
) ON [PRIMARY]
GO

INSERT [dbo].[Action] ([Id], [Name]) VALUES (0, N'None')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (1, N'Copy')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (2, N'Move')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (3, N'Rename')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (4, N'Delete')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (5, N'Zip')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (6, N'UnZip')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (7, N'Encrypt')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (8, N'Decrypt')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (9, N'Zip Password')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (10, N'UnZip Password')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (11, N'FTP Upload')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (12, N'FTP Download')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (13, N'FTP Move')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (14, N'FTP Rename')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (15, N'FTP Delete')

SELECT * FROM Action

Id   Name
---- --------------------------------------------------
0    None
1    Copy
2    Move
3    Rename
4    Delete
5    Zip
6    UnZip
7    Encrypt
8    Decrypt
9    Zip Password
10   UnZip Password
11   FTP Upload
12   FTP Download
13   FTP Move
14   FTP Rename
15   FTP Delete


/****** Object:  Table [dbo].[WatchTask]    Script Date: 3/5/2018 7:35:43 PM ******/
DROP TABLE WatchTask
GO
CREATE TABLE [dbo].[WatchTask](
	[Id]                [int] NOT NULL,
	[Name]              [varchar](50) NULL,
	[ProcessId]         [int] NULL,
	[JobId]             [int] NULL,
	[Sequence]          [tinyint] NULL,
	[isActive]          [bit] NULL,
	[WatchPattern]      [varchar](100) NULL,
	[isAND]             [bit] NULL,             --만일 true이면 WatchPattern에 나열된 Pattern이 모두 AND조건을 충족해야 한다. 
	[ActionId]          [tinyint] NULL,         --예를들어 "777*.txt, 888*.out, 999.txt"의 경우 3가지 Patter의 File이 모두 있어야 실행이 된다.
	[SourceFTPId]       [smallint] NULL,        --Default:null, Source FTP login information
	[SourcePath]        [varchar](100) NULL,    
	[SourceFileName]    [varbinary](50) NULL,   --Only One File
	[TargetFTPId]       [smallint] NULL,        --Default:null, Target FTP login information
	[TargetPath]        [varchar](100) NULL,    --Check TargetPath exist if not then create Folder
	[SubFolderPattern]  [varchar](50) NULL,     --Default:null, FileName has pattern then Create Folder as Pattern and copy the file to the folder
	[TargetFileName]    [varbinary](50) NULL,   --Only One File
	[isAppend]          [bit] NULL,             --if true then 'FileName + (Index)' and save
	[FilePassword]      [varchar](50) NULL,     --Zip/UnZip Password, Encrypt/Decrypt Password
	[EMail]             [varchar](50) NULL,
	[EMailGroupId]      [smallint] NULL,
	[StatusNotify]      [bit] NULL,
	[ResultNotify]      [bit] NULL,
 CONSTRAINT [PK_WatchTask] PRIMARY KEY CLUSTERED 
(	[Id] ASC  ) ON [PRIMARY]
) ON [PRIMARY]

SELECT * FROM WatchTask

/****** Object:  Table [dbo].[WatchJob]    Script Date: 3/5/2018 7:35:43 PM ******/
DROP TABLE WatchJob
GO
CREATE TABLE [dbo].[WatchJob](
	[Id]                [int] IDENTITY(1,1) NOT NULL,
	[Name]              [varchar](50) NULL,
	[ProcessId]         [int] NULL,
	[Sequence]          [tinyint] NULL,
	[isActive]          [bit] NULL,
	[GroupName]         [varchar](50) NULL,
	[GroupCondition]    [bit] NOT NULL,     
	[EMail]             [varchar](50) NULL,
	[EMailGroupId]      [smallint] NULL,
	[StatusNotify]      [bit] NULL,
	[ResultNotify]      [bit] NULL,
 CONSTRAINT [PK_WatchJob] PRIMARY KEY CLUSTERED 
(	[Id] ASC ) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[WatchProcess]    Script Date: 3/5/2018 7:35:43 PM ******/
DROP TABLE WatchProcess
GO
CREATE TABLE [dbo].[WatchProcess](
	[Id]                [int] IDENTITY(1,1) NOT NULL,
	[Name]              [varchar](50) NULL,
	[isActive]          [bit] NULL,
	[Priority]          [tinyint] NULL,         --0:Top Priority
	[OwnerId]           [int] NULL,
	[FolderPath]        [varchar](100) NULL,
 CONSTRAINT [PK_WatchProcess] PRIMARY KEY CLUSTERED 
(	[Id] ASC ) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[WatchOwner]    Script Date: 3/5/2018 7:35:43 PM ******/
DROP TABLE WatchOwner
GO
CREATE TABLE [dbo].[WatchOwner](
	[Id]                [int] NOT NULL,
	[Name]              [varchar](50) NULL,
	[isActive]          [bit] NULL,
	[Description]       [varchar](100) NULL,
	[Grade]             [tinyint] NULL,         --0:Administrator, 1:SuperUser, 
	[OwnerGroup]        [varchar](50) NULL,
 CONSTRAINT [PK_WatchOwner] PRIMARY KEY CLUSTERED 
(	[Id] ASC ) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[EMailAddress]    Script Date: 3/5/2018 11:17:06 PM ******/
DROP TABLE EMailAddress
GO
CREATE TABLE [dbo].[EMailAddress] (
	[Id]                [int] NOT NULL,
	[EMailAddress]      [varchar](50) NULL,
	[NickName]          [varchar](50) NULL,
	[PrintName]         [varchar](50) NULL,
	[FirstName]         [varchar](50) NULL,
	[MiddleName]        [varchar](50) NULL,
	[LastName]          [varchar](50) NULL,
 CONSTRAINT [PK_EMail] PRIMARY KEY CLUSTERED 
(	[Id] ASC ) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[EMailGroup]    Script Date: 3/5/2018 11:17:06 PM ******/
DROP TABLE EMailGroup
GO
CREATE TABLE [dbo].[EMailGroup](
	[Id]                [int] NULL,
	[Name]              [varchar](50) NULL,
	[Description]       [varchar](100) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[EMailGroupList]    Script Date: 3/5/2018 11:17:06 PM ******/
DROP TABLE EMailGroupList
GO
CREATE TABLE [dbo].[EMailGroupList](
	[Id]                [int] IDENTITY(1,1) NOT NULL,
	[EMailGroupId]      [int] NOT NULL,
	[EMailAddressId]    [int] NOT NULL,
 CONSTRAINT [PK_EMailGroupList] PRIMARY KEY CLUSTERED 
(	[EMailGroupId] ASC, [EMailAddressId] ASC  )  ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[FTPSite]    Script Date: 3/5/2018 11:17:06 PM ******/
CREATE TABLE [dbo].[FTPSite] (
	[Id]                [int] NOT NULL,
	[Name]              [varchar](50) NULL,
	[HostName]          [varchar](50) NULL,
	[UserName]          [varchar](50) NULL,
	[Password]          [varchar](50) NULL,
	[Protocol]          [varchar](10) NULL,
	[Port]              [smallint] NULL,
 CONSTRAINT [PK_FTPSite] PRIMARY KEY CLUSTERED 
(	[Id] ASC )  ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[WatchJob]  WITH CHECK 
    ADD  CONSTRAINT [FK_WatchJob_WatchProcess] FOREIGN KEY([ProcessId])     REFERENCES [dbo].[WatchProcess] ([Id])
GO

ALTER TABLE [dbo].[WatchJob] CHECK CONSTRAINT [FK_WatchJob_WatchProcess]
GO

ALTER TABLE [dbo].[WatchProcess]  WITH CHECK 
    ADD  CONSTRAINT [FK_WatchProcess_WatchOwner] FOREIGN KEY([OwnerId])     REFERENCES [dbo].[WatchOwner] ([Id])
GO

ALTER TABLE [dbo].[WatchProcess] CHECK CONSTRAINT [FK_WatchProcess_WatchOwner]
GO

ALTER TABLE [dbo].[WatchTask]  WITH CHECK 
    ADD  CONSTRAINT [FK_WatchTask_WatchJob] FOREIGN KEY([JobId])            REFERENCES [dbo].[WatchJob] ([Id])
GO

ALTER TABLE [dbo].[WatchTask] CHECK CONSTRAINT [FK_WatchTask_WatchJob]
GO
ALTER TABLE [dbo].[WatchTask]  WITH CHECK 
    ADD  CONSTRAINT [FK_WatchTask_WatchTask] FOREIGN KEY([Id])              REFERENCES [dbo].[WatchTask] ([Id])
GO

ALTER TABLE [dbo].[WatchTask] CHECK CONSTRAINT [FK_WatchTask_WatchTask]
GO


