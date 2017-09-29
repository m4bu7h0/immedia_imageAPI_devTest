use [immedia_venuePhotosWebAPI]
go

create table [dbo].[User](
	[UserID] varchar(40) not null,
	[Username] varchar(100),
	[Password] varchar(100),
	[FirstName] varchar(100),
	[Surname] varchar(100),
	[EmailAddress] varchar(100) null,
	[Gender] varchar(5),
	constraint [PK_VenueUser] 
	primary key clustered (
		[UserID] asc
	)with (
		pad_index = off, statistics_norecompute = off,
		ignore_dup_key = off, allow_row_locks = on, 
		allow_page_locks = on
	) on [PRIMARY]
) on [PRIMARY]
go

-- 2. Contact
create table [dbo].[VenueContact](
	[ContactID] int identity(1,1),
	[PhoneNumber] [varchar](20) null,
	[Twitter] [varchar](50) null
	constraint [PK_VenueContact] 
	primary key clustered (
		[ContactID] asc
	)with (
		pad_index = off, statistics_norecompute = off,
		ignore_dup_key = off, allow_row_locks = on, 
		allow_page_locks = on
	) on [PRIMARY]
) on [PRIMARY]
go

-- 3. Location
create table [dbo].[VenueLocation](
	[LocationID] int identity(1,1),
	[Address] [varchar](100) null,
	[Latitude] decimal(8),
	[Longitude] decimal(8),
	[Distance] int,
	[City] varchar(100),
	[Country] varchar(100)
	constraint [PK_VenueLocation] 
	primary key clustered (
		[LocationID] asc
	)with (
		pad_index = off, statistics_norecompute = off,
		ignore_dup_key = off, allow_row_locks = on, 
		allow_page_locks = on
	) on [PRIMARY]
) on [PRIMARY]
go

-- 4 Category
create table [dbo].[VenueCategory](
	[CategoryID] int identity(1,1),
	[Name] [varchar](500) null,
	[Photo] varbinary(MAX)
	constraint [PK_VenueCategory] 
	primary key clustered (
		[CategoryID] asc
	)with (
		pad_index = off, statistics_norecompute = off,
		ignore_dup_key = off, allow_row_locks = on, 
		allow_page_locks = on
	) on [PRIMARY]
) on [PRIMARY]
go

-- 5. Venue
create table [dbo].[Venue](
	[VenueID] varchar(50) not null,
	[Name] [varchar](500) null,
	[ContactID] int,
	[LocationID] int,
	[CategoryID] int,
	constraint [PK_Venue] 
	primary key clustered (
		[VenueID] asc
	)with (
		pad_index = off, statistics_norecompute = off,
		ignore_dup_key = off, allow_row_locks = on, 
		allow_page_locks = on
	) on [PRIMARY],
	constraint [FK_Contact] 
	foreign key([ContactID])
	references [dbo].[VenueContact] ([ContactID]),
	constraint [FK_Location] 
	foreign key([LocationID])
	references [dbo].[VenueLocation] ([LocationID]),
	foreign key([CategoryID])
	references [dbo].[VenueCategory] ([CategoryID])
)	on [PRIMARY]
go

-- 6. Photo
create table [dbo].[VenuePhoto](
	[PhotoID] varchar(40) not null,
	[Name] varchar(500),
	[Photo] varbinary(MAX) not null,
	[VenueID] varchar(50)
	constraint [PK_VenuePhoto] 
	primary key clustered (
		[PhotoID] asc
	)with (
		pad_index = off, statistics_norecompute = off,
		ignore_dup_key = off, allow_row_locks = on, 
		allow_page_locks = on
	) on [PRIMARY],
	constraint [FK_Venue] 
	foreign key([VenueID])
	references [dbo].[Venue] ([VenueID])
)	on [PRIMARY]
go

-- 7. User's Photos
create table [dbo].[UsersPhotos](
	[UserID] varchar(40) not null,
	[PhotoID] varchar(40) not null,
	constraint [FK_User] 
	foreign key([UserID])
	references [dbo].[User] ([UserID]),
	constraint [FK_Photo] 
	foreign key([PhotoID])
	references [dbo].[VenuePhoto] ([PhotoID])
)	on [PRIMARY]
go