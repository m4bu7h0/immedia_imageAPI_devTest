use [immedia_venuePhotosWebAPI]
go

-- A] Save User's Photo
create proc [dbo].[SaveUserVenuePhoto]
	@UserID varchar(40) = null, @PhotoID varchar(40),
	@PhotoName varchar(100), @Photo varbinary(MAX),
	@VenueID varchar(40), @VenueName varchar(100),
	@PhoneNumber varchar(20), @Twitter varchar(50), 
	@Address varchar(100), @Latitude decimal(8), 
	@Longitude decimal(8), @Distance int null, 
	@City varchar(100), @Country varchar(100), 
	@Category varchar(100), 
	@CategoryPhoto varbinary(MAX) = null
as

begin
	
	declare @ContactID as int
	declare @CategoryID as int
	declare @LocationID as int

	-- 1. Insert the Category (if not existing)
	if not exists(
		select [Name] from [dbo].[VenueCategory]
		where [Name] = @Category)
	begin
		
		insert into [dbo].[VenueCategory]([Name], [Photo])
		values(@Category, @CategoryPhoto)
	end

	-- 2. Insert Contact (if not existing)
	if not exists(
		select [PhoneNumber] from [dbo].[VenueContact]
		where [PhoneNumber] = @PhoneNumber)
	begin
		
		insert into [dbo].[VenueContact](
			[PhoneNumber], [Twitter])
		values(
			@PhoneNumber, @Twitter)
	end

	-- 3. Insert Venue Location
	insert into [dbo].[VenueLocation](
		[Address] ,[City] ,[Country] ,[Distance],
		[Latitude] ,[Longitude])
	values(
		@Address, @City, @Country, @Distance,
		@Latitude, @Longitude)
	
	-- 4. Set ID's
	set @CategoryID = (
		select [CategoryID] from [dbo].[VenueCategory]
		where [Name] = @Category)

	set @ContactID = (
		select [ContactID] 
		from [dbo].[VenueContact]
		where [PhoneNumber] = @PhoneNumber)

	set @LocationID = (
		select [LocationID]
		from [dbo].[VenueLocation]
		where [Latitude] = @Latitude
		and [Longitude] = @Longitude)

	-- 5. Insert Venue
	insert into [Venue](
		[VenueID], [ContactID], [LocationID],
		[CategoryID])
	values(
		@VenueID, @ContactID, 
		@LocationID, @CategoryID)
		
	
	-- 6. Insert User's Photo if user not null
	if(@UserID <> null)
	begin
		
		insert into [dbo].[UsersPhotos](
			[UserID], [PhotoID])
		values(@UserID, @PhotoID)
	end
end
go

-- B] Save User
create proc [dbo].[SaveUser]
	@UserName varchar(100), @Password varchar(100),
	@FirstName varchar(100), @Surname varchar(100),
	@EmailAddress varchar(100), @Gender varchar(5)
as
begin
	
	insert into [dbo].[User](
		[UserID], [Username], [Password],
		[FirstName], [Surname],
		[EmailAddress],[Gender])
	values(
		newid(), @UserName, @Password, @FirstName,
		@Surname, @EmailAddress, @Gender)
end
go

-- C] User's Login
create proc [dbo].[UserLogin]
	@UserName varchar(100),
	@Password varchar(100)
as
begin
	
	select [Username], [Password]
	from [dbo].[User]
	where [Username] = @UserName
	and [Password] = @Password
end
go

-- D] Get User's Venue Photos
create proc [dbo].[GetUserVenuePhotos]
	@UserID varchar(40)
as
begin
	
	select [UserID], (
		select [Name] from [dbo].[VenuePhoto]
		where [PhotoID] = up.PhotoID) as [Name],
		(select [Name] from [dbo].[Venue]
		 where [VenueID] = (
			select [VenueID] 
			from [dbo].[VenuePhoto] 
			where [PhotoID] = up.[PhotoID])) as [VenueName],
		(select [Photo] from [dbo].[VenuePhoto]
		 where [PhotoID] = up.PhotoID) as [Photo]
	from [dbo].[UsersPhotos] up
	where [UserID] = @UserID
end
go

-- E] Get Saved Photos
create proc [dbo].[GetSavedPhotos]
as
begin
	select vp.[Photo], v.[Name], 
		(select [Name] from [dbo].[VenueCategory]
		 where [CategoryID] = v.CategoryID) as [Category],
		(select [Address] 
		 from [dbo].[VenueLocation] 
		 where LocationID = v.LocationID) as [Address] 
	from [dbo].[VenuePhoto]  vp
	inner join [dbo].[Venue] v 
	on v.[VenueID] = vp.[VenueID]
end
go