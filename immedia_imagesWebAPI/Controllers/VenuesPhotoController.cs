using System.Web.Http;
using System.Collections.Generic;
using immedia_imagesDomain.business;
using immedia_imagesDomain.utilities;


namespace immedia_imagesWebAPI.Controllers {
    public class VenuesPhotoController : ApiController {
        [HttpGet]
        [Route("VenuesAutocomplete/{searchText}")]
        public List<string> GetAutoCompleteList(string searchText) {

            return VenuePhotoUtil.GetLocationsAutoComplete(
                searchText);
        }

        [HttpGet]
        [Route("VenuesSearch/{coordinates}")]
        public List<VenuePhoto> GetVenues(
           string coordinates) {

            return VenuePhotoUtil.GetVenues(coordinates);
        }
        [HttpPost]
        [Route("VenuePhotoSave")]
        public void Post([FromBody] VenuePhoto photo) {

            VenuePhotoUtil.SaveVenuePhoto(photo);
        }

        [HttpGet]
        [Route("SavedVenuesPhotos")]
        public List<VenuePhoto> GetVenuesPhotos() {

            return VenuePhotoUtil.GetSavedVenuePhotos();
        }
    }
}