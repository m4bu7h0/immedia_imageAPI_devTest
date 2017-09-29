using Dapper;
using System.Data;
using System.Linq;
using System.Collections.Generic;
using immedia_imagesDomain.business;
using immedia_imagesDomain.utilities;

namespace immedia_imagesDomain.data {
    internal static class VenuePhotoRepository {

        internal static bool SaveUserVenuePhoto(VenuePhoto image) {

            var rowsAffected = ConnectionUtil.Connection.Execute(
                "SaveUserVenuePhoto", new {
                    PhotoID = image.PhotoID, PhotoName = image.Name,
                    Photo = image.PhotoData,
                    VenueID = image.PhotoVenue.VenueID,
                    VenueName = image.PhotoVenue.VenueName,
                    PhoneNumber = image.PhotoVenue.Contact.PhoneNumber,
                    Twitter = image.PhotoVenue.Contact.Twitter,
                    Address = image.PhotoVenue.Location.Address,
                    Latitude = image.PhotoVenue.Location.Latitude,
                    Longitude = image.PhotoVenue.Location.Longitude,
                    Distance = image.PhotoVenue.Location.Distance,
                    City = image.PhotoVenue.Location.City,
                    Country = image.PhotoVenue.Location.Country,
                    Category = image.PhotoVenue.Category.Name,
                    CategoryPhoto = image.PhotoVenue.Category.Photo
                }, commandType: CommandType.StoredProcedure);

            return rowsAffected > 0;
        }
        internal static List<VenuePhoto> GetSavedVenuePhotos() {

            return ConnectionUtil.Connection.Query<VenuePhoto>(
                "GetSavedVenuePhotos",
                commandType: CommandType.StoredProcedure).ToList();
        }
    }
}
