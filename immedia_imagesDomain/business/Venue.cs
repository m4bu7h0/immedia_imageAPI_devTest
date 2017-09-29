namespace immedia_imagesDomain.business {
    public class Venue {
        public string VenueID { get; set; }
        public string VenueName { get; set; }
        public VenueContact Contact { get; set; }
        public VenueLocation Location { get; set; }
        public VenueCategory Category { get; set; }
    }
}
