
USE [FileManager]
GO

IF OBJECT_ID('dbo.Action', 'U') IS NOT NULL 
    DROP TABLE Action;
GO
CREATE TABLE [dbo].[Action] (
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
INSERT [dbo].[Action] ([Id], [Name]) VALUES (9, N'New Folder')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (10, N'Zip Password')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (11, N'UnZip Password')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (12, N'FTP Upload')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (13, N'FTP Download')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (14, N'FTP Move')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (15, N'FTP Rename')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (16, N'FTP Delete')

SELECT * FROM Action

--Id   Name
------ --------------------------------------------------
--0    None
--1    Copy
--2    Move
--3    Rename
--4    Delete
--5    Zip
--6    UnZip
--7    Encrypt
--8    Decrypt
--9    New Folder
--9    Zip Password
--10   UnZip Password
--11   FTP Upload
--12   FTP Download
--13   FTP Move
--14   FTP Rename
--15   FTP Delete

IF OBJECT_ID('dbo.FileEvent', 'U') IS NOT NULL 
    DROP TABLE FileEvent;
GO
--Task Table의 Child Table이다.
CREATE TABLE [dbo].[FileEvent] (
	[Id]                [int] NOT NULL,
	[TaskId]            [int] NULL,
	[Serial]            [tinyint] NULL,
	[Name]              [varchar](50) NULL,
	[isActive]          [bit] NULL,
	[FileNamePattern]   [varchar](50) NULL,     --999*.txt, 888*.txt, 777-YYYYMMDD*.txt (기본적으로 OR조건으로 하나만 Pattern이 Match되어도 된다)
	[isAND]             [bit] NULL DEFAULT 0    --만일 TRUE이면 같은 TaskId의 FIleNamePattern은 모두 만족해야 Task를 실행 할수 있다.
) ON [PRIMARY]                                  --여러개의 FIle이 있어야만 실행할 수 있는 작업의 경우 사용할 수 있다.
GO

/****** Object:  Table [dbo].[Task]    Script Date: 3/5/2018 7:35:43 PM ******/
IF OBJECT_ID('dbo.Task', 'U') IS NOT NULL 
    DROP TABLE Task
GO
--Job Table의 Child Table이다.
CREATE TABLE [dbo].[Task] (
	[Id]                [int] NOT NULL,
	[Name]              [varchar](50) NULL,
  --[ProcessId]         [int] NULL,
	[JobId]             [int] NULL,
	[Serial]            [tinyint] NULL,
	[ActionId]          [tinyint] NULL,
	[isActive]          [bit] NULL,
	[FileNamePattern]   [varchar](1000) NULL,   --[FileEvent].[FileNamePattern]를 모두 comma로 연결하여 1개의 String으로 보관한다
	[SourceFTPId]       [smallint] NULL,        --Default:null, Source FTP login information
	[SourcePath]        [varchar](100) NULL,    
	[SourceFileName]    [varbinary](50) NULL,   --Only One File
	[TargetFTPId]       [smallint] NULL,        --Default:null, Target FTP login information
	[TargetPath]        [varchar](100) NULL,    --Check TargetPath exist if not then create Folder
	[SubFolderPattern]  [varchar](50) NULL,     --Default:null, FileName has pattern then Create Folder as Pattern and copy the file to the folder
	[TargetFileName]    [varbinary](50) NULL,   --Only One File
	[isOverwrite]       [bit] NULL DEFAULT 1,   --if false then 'FileName + (Index)' and save
	[FilePassword]      [varchar](50) NULL,     --Zip/UnZip Password, Encrypt/Decrypt Password
	[EMail]             [varchar](50) NULL,
	[EMailGroupId]      [smallint] NULL,
	[StatusNotify]      [bit] NULL,
	[ResultNotify]      [bit] NULL,
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(	[Id] ASC  ) ON [PRIMARY]
) ON [PRIMARY]

--ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Job] FOREIGN KEY([JobId])   REFERENCES [dbo].[Job] ([Id])
--ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_Job]
--ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Task] FOREIGN KEY([Id])     REFERENCES [dbo].[Task] ([Id])
--ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_Task]
--GO

SELECT * FROM Task


/****** Object:  Table [dbo].[Job]    Script Date: 3/5/2018 7:35:43 PM ******/
IF OBJECT_ID('dbo.Job', 'U') IS NOT NULL 
    DROP TABLE Job
GO
--Process Table의 Child Table이다.
CREATE TABLE [dbo].[Job](
	[Id]                [int] IDENTITY(1,1) NOT NULL,
	[Name]              [varchar](50) NULL,
	[ProcessId]         [int] NULL,
	[Serial]            [tinyint] NULL,
	[isActive]          [bit] NULL,
	[GroupName]         [varchar](50) NULL,
	[GroupCondition]    [bit] NOT NULL,     
	[EMail]             [varchar](50) NULL,
	[EMailGroupId]      [smallint] NULL,
	[StatusNotify]      [bit] NULL,
	[ResultNotify]      [bit] NULL,
 CONSTRAINT [PK_Job] PRIMARY KEY CLUSTERED 
(	[Id] ASC ) ON [PRIMARY]
) ON [PRIMARY]

--ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_Job_Process] FOREIGN KEY([ProcessId])  REFERENCES [dbo].[Process] ([Id])
--ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_Job_Process]
--GO


/****** Object:  Table [dbo].[Process]    Script Date: 3/5/2018 7:35:43 PM ******/

IF OBJECT_ID('dbo.Process', 'U') IS NOT NULL 
  --SELECT * FROM sys.foreign_keys WHERE referenced_object_id = object_id('Process')
  --ALTER TABLE [dbo].[Process] DROP CONSTRAINT [FK_Process_Owner]
    DROP TABLE Process
GO

CREATE TABLE [dbo].[Process](
	[Id]                [int] IDENTITY(1,1) NOT NULL,
	[Name]              [varchar](50) NULL,
	[isActive]          [bit] NULL,
	[Priority]          [tinyint] NULL DEFAULT 255,         --1 byte:0-255, 0:Top Priority
	[OwnerId]           [int] NULL,
	[FolderPath]        [varchar](100) NULL,
 CONSTRAINT [PK_Process] PRIMARY KEY CLUSTERED 
(	[Id] ASC ) ON [PRIMARY]
) ON [PRIMARY]

--ALTER TABLE [dbo].[Process]  WITH CHECK ADD  CONSTRAINT [FK_Process_Owner] FOREIGN KEY([OwnerId])  REFERENCES [dbo].[Owner] ([Id])
--ALTER TABLE [dbo].[Process] CHECK CONSTRAINT [FK_Process_Owner]
--GO


/****** Object:  Table [dbo].[Owner]    Script Date: 3/5/2018 7:35:43 PM ******/
IF OBJECT_ID('dbo.Owner', 'U') IS NOT NULL 
    DROP TABLE Owner
GO
CREATE TABLE [dbo].[Owner](
	[Id]                [int] NOT NULL,
	[Name]              [varchar](50) NULL,
	[isActive]          [bit] NULL,
	[Description]       [varchar](100) NULL,
	[Grade]             [tinyint] NULL,         --0:Administrator, 1:SuperUser, 
	[OwnerGroup]        [varchar](50) NULL,
 CONSTRAINT [PK_Owner] PRIMARY KEY CLUSTERED 
(	[Id] ASC ) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[EMailAddress]    Script Date: 3/5/2018 11:17:06 PM ******/
IF OBJECT_ID('dbo.EMailAddress', 'U') IS NOT NULL 
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
IF OBJECT_ID('dbo.EMailGroup', 'U') IS NOT NULL 
    DROP TABLE EMailGroup
GO
CREATE TABLE [dbo].[EMailGroup](
	[Id]                [int] NULL,
	[Name]              [varchar](50) NULL,
	[Description]       [varchar](100) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[EMailGroupList]    Script Date: 3/5/2018 11:17:06 PM ******/
IF OBJECT_ID('dbo.EMailGroupList', 'U') IS NOT NULL 
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
IF OBJECT_ID('dbo.FTPSite', 'U') IS NOT NULL 
    DROP TABLE FTPSite
GO
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


ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Job] FOREIGN KEY([JobId])   REFERENCES [dbo].[Job] ([Id])
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_Job]
GO

ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_Job_Process] FOREIGN KEY([ProcessId])  REFERENCES [dbo].[Process] ([Id])
ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_Job_Process]
GO

ALTER TABLE [dbo].[Process]  WITH CHECK ADD  CONSTRAINT [FK_Process_Owner] FOREIGN KEY([OwnerId])  REFERENCES [dbo].[Owner] ([Id])
ALTER TABLE [dbo].[Process] CHECK CONSTRAINT [FK_Process_Owner]
GO



