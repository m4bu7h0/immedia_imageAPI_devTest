using System;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;
using System.Net.Http.Headers;

namespace immedia_imagesDomain.docking
{
    public static class DockingHub
    {
        private static HttpClient client;
        private static HttpResponseMessage response;
        private static JArray jsonArray;

        // INSTRUCTION 002 
        // Make a call to an API method 
        // Change this to your deployment server, I used localhost
        private static readonly string url =
            "http://localhost/immedia_imagesWebAPI/";
        public static JArray GetAutocomplete(
            string searchText)
        {

            using (client = new HttpClient())
            {

                BuildClientObj(client);
                return GetResponseMessage(
                    "VenuesAutocomplete/{0}", searchText).Result;
            }
        }
        public static JArray GetVenues(string coordinates)
        {
            using (client = new HttpClient())
            {

                BuildClientObj(client);
                return GetResponseMessage(
                    "VenuesSearch/{0}/", coordinates).Result;
            }
        }

        /////////// Pack them up and ship them out ////////////////////////////
        static void BuildClientObj(HttpClient client)
        {

            client.BaseAddress = new Uri(url);
            client.Timeout = TimeSpan.FromMinutes(30);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/json"));
        }
        static async Task<JArray> GetResponseMessage(
            string apiMethod, string paramStr)
        {

            jsonArray = new JArray();
            response = client.GetAsync(
                   string.Format(apiMethod, paramStr)).Result;

            if (response.IsSuccessStatusCode)
            {
                jsonArray =
                    await response.Content.ReadAsAsync<JArray>();
            }

            return jsonArray;
        }
        //////////////////////////////////////////////////////////////
    }
}
