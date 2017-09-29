namespace immedia_imagesDomain.business {
    public class VenuePhoto {
        public string PhotoID { get; set; }
        public string Name { get; set; }
        public byte[] PhotoData { get; set; }
        public Venue PhotoVenue { get; set; }
    }
}
