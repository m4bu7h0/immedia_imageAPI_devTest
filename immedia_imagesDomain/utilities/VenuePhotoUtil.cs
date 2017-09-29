using System;
using System.IO;
using System.Net;
using Newtonsoft.Json.Linq;
using immedia_imagesDomain.data;
using System.Collections.Generic;
using immedia_imagesDomain.business;

namespace immedia_imagesDomain.utilities {

    public static class VenuePhotoUtil {

        private static string searchURL;
        private static HttpWebRequest req;
        private static WebClient webClient;
        private static HttpWebResponse resp;
        private static StreamReader reader;
        private static string json;
        private static JToken token;
        public static List<string> GetLocationsAutoComplete(string searchText) {

            var myLocations = new List<string>();

            searchURL =
                @"https://api.foursquare.com/v2/geo/geocode?" +
                "locale=en&explicit-lang=false&v=20170508&query=" + searchText +
                "&autocomplete=true&allowCountry=false&" +
                "ll=-29.883333,31.05&maxInterpretations=3&" +
                "wsid=FWXBIDQKZCQ0SQDCWTDB21K2CWWI4H&" +
                "oauth_token=RCWWE42CGARPMTT3BSCR4AZFIFQ35WJ2WME4OXFBRHXSLVDZ&v=20170921";

            req = (HttpWebRequest)WebRequest.Create(searchURL);

            req.Proxy = VenueProxy;

            using (resp = (HttpWebResponse)req.GetResponse()) {

                using (reader =
                    new StreamReader(resp.GetResponseStream())) {

                    json = reader.ReadToEnd();
                    token = JToken.Parse(json);
                    var locationItems =
                        (JArray)token.SelectToken(
                            "response.geocode.interpretations.items");

                    foreach (var location in locationItems) {
                        myLocations.Add(
                            location["feature"]["name"].ToString());
                    }
                }
            }

            return myLocations;
        }
        public static List<VenuePhoto> GetVenues(string coordinates) {

            var venuesList = new List<Venue>();

            var venuePhotoList = new List<VenuePhoto>();
            searchURL =
                @"https://api.foursquare.com/v2/venues/search?" +
                "ll=" + coordinates +
                "&oauth_token=RCWWE42CGARPMTT3BSCR4AZFIFQ35WJ2WME4OXFBRHXSLVDZ&v=20170921";

            var req =
              (HttpWebRequest)WebRequest.Create(searchURL);

            req.Proxy = VenueProxy;

            using (resp = (HttpWebResponse)req.GetResponse()) {

                using (reader =
                    new StreamReader(resp.GetResponseStream())) {

                    json = reader.ReadToEnd();
                    token = JToken.Parse(json);
                    var venues =
                        (JArray)token.SelectToken("response.venues");

                    // if there are venues for this location
                    if (venues != null) {

                        foreach (var venue in venues) {

                            var newVenue = new Venue {

                                VenueID = venue["id"].ToString(),
                                VenueName = venue["name"].ToString(),
                                Location = new VenueLocation {
                                    Country =
                                            venue["location"]["country"].ToString(),
                                    Latitude =
                                            Convert.ToDecimal(
                                                venue["location"]["lat"]),
                                    Longitude =
                                            Convert.ToDecimal(
                                                venue["location"]["lng"])
                                }
                            };

                            webClient = new WebClient {
                                Proxy = VenueProxy
                            };

                            var categories =
                                (JArray)token.SelectToken(
                                    "response.venues.categories");
                            if (categories != null) {
                                newVenue.Category = new VenueCategory {
                                    VenueCategoryID =
                                        categories[0]["id"].ToString(),
                                    Name =
                                        categories[0]["name"].ToString(),
                                    Photo =
                                        webClient.DownloadData(
                                            categories[0]["icon"]["prefix"] +
                                            categories[0]["icon"]["suffix"]
                                                .ToString())
                                };
                            }

                            if (venue["location"]["address"] != null) {

                                newVenue.Location.Address =
                                    venue["location"]["address"].ToString();
                            }

                            if (venue["location"]["distance"] != null) {

                                newVenue.Location.Distance =
                                    Convert.ToInt32(
                                        venue["location"]["distance"]);
                            }

                            if (venue["location"]["city"] != null) {

                                newVenue.Location.City =
                                    venue["location"]["city"].ToString();
                            }

                            venuesList.Add(newVenue);
                        }
                    }


                    // Get and add a photo for a venue (is there are venues)
                    if (venuesList.Count > 0) {
                        foreach (var v in venuesList) {
                            venuePhotoList.Add(GetVenuePhoto(v));
                        }
                    }
                }
            }

            return venuePhotoList;
        }
        public static void SaveVenuePhoto(VenuePhoto venuePhoto) {

            VenuePhotoRepository.SaveUserVenuePhoto(venuePhoto);
        }
        public static List<VenuePhoto> GetSavedVenuePhotos() {

            return VenuePhotoRepository.GetSavedVenuePhotos();
        }
        static VenuePhoto GetVenuePhoto(Venue venue) {

            var vPhoto = new VenuePhoto { PhotoVenue = venue };

            // Get Photos
            searchURL =
                @"https://api.foursquare.com/v2/venues/" +
                venue.VenueID + "/photos?v=20170512" +
                "&oauth_token=RCWWE42CGARPMTT3BSCR4AZFIFQ35WJ2WME4OXFBRHXSLVDZ&v=20170921";

            var req =
             (HttpWebRequest)WebRequest.Create(searchURL);

            req.Proxy = VenueProxy;

            using (resp = (HttpWebResponse)req.GetResponse()) {

                using (reader =
                    new StreamReader(resp.GetResponseStream())) {

                    json = reader.ReadToEnd();
                    token = JToken.Parse(json);

                    // Taking the first photo of an array
                    var photo =
                        (JObject)token.SelectToken("response.photos.items[0]");

                    if (photo != null) {
                        var photoURL = photo["prefix"].ToString() +
                                          photo["width"] + "x" + photo["height"] +
                                          photo["suffix"];

                        vPhoto.PhotoID = photo["id"].ToString();
                        vPhoto.Name =
                            photo["source"]["name"].ToString();

                        webClient = new WebClient {
                            Proxy = VenueProxy
                        };


                        vPhoto.PhotoData =
                            webClient.DownloadData(photoURL);


                    } else {

                        // Read a placeholder photo (no_16x16.png)
                        //photoURL = "../images/no_16x16.png";
                        //vPhoto.Photo = File.ReadAllBytes(photoURL);
                    }
                }
            }

            return vPhoto;
        }
        static IWebProxy VenueProxy {
            get {
                // A] INSTRUCTION - 001
                // This was specifically for my network proxy purposes.
                // Please change this to the credentials you use for your proxy
                // or just comment this block out if not using a proxy
                ///////////////////////////////////////////////////////////////
                //return new WebProxy {
                //    Address =
                //    new Uri("http://PL4N3T-X.proxy.co.za:3128"),
                //    Credentials =
                //    new NetworkCredential("sibongelenim", "4nnuki2017")
                //};

                // Uncomment this block if you not using a proxy
                return null;
            }
        }
    }
}
