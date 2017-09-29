using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace immedia_imagesDomain.business {
    public class VenueLocation {
        public int VenueLocationID { get; set; }
        public string Address { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public int Distance { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
    }
}
