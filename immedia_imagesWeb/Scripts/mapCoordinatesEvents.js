(function (global, undefined) {
    var map, latitudeBox, longitudeBox, zoomBox;

    function map_load(sender, args) {
        map = sender.get_kendoWidget();
        logLoad(sender);
    }

    function latitudeBox_load(sender, args) {
        latitudeBox = sender;
    }
    function longitudeBox_load(sender, args) {
        longitudeBox = sender;
    }
    function zoomBox_load(sender, args) {
        zoomBox = sender;
    }

    function setZoomLevel(sender, args) {
        var zoom = args.get_item().get_value();
        map.zoom(zoom);
    }

    function setCenterPosition() {
        var latitude = latitudeBox.get_value();
        var longitude = longitudeBox.get_value();
        map.center([latitude, longitude]);
    }

    function logZoomEnd(eventArgs) {
        var map = eventArgs.sender;
        logEvent(String.format("<strong>ZoomEnd</strong>: zoomed to level {0}.", map.zoom()));
        syncConfigurationControls(map);
    }

    function logPanEnd(eventArgs) {
        var map = eventArgs.sender;
        logEvent(String.format("<strong>PanEnd</strong>: panned to {0}.", map.center().toString()));
        syncConfigurationControls(map);
    }

    // 1] First Useful method, populate coordinates
    function logClick(eventArgs) {

        var clickedLocation = eventArgs.location;

        var latDecimal =
            clickedLocation.lat;
        var lngDecimal =
            clickedLocation.lng;
        var cardinalityLAT =
            (latDecimal >= 0) ? 'N' : 'S';
        var cardinalityLON =
            (lngDecimal >= 0) ? 'E' : 'W';

        var latitude =
            document.getElementById("rtbLatitudeSTV");
        var longitude =
            document.getElementById("rtbLongitudeSTV");

        latitude.value =
            getDms(latDecimal) + cardinalityLAT;
        longitude.value =
            getDms(lngDecimal) + cardinalityLON;
    }
    function getDms(val) {

        // Required variables

        val = Math.abs(val);
        var valDeg = Math.floor(val);

        var result = valDeg + "º";
        var valMin = Math.floor((val - valDeg) * 60);
        result += valMin + "'";
        var valSec =
            Math.round(
                (val - valDeg - valMin / 60) * 3600 * 1000) / 1000;
        result += valSec + '"';

        return result;
    }
    function parseDMS(input) {
        var parts = input.split(/[^\d\w\.]+/);
        var coordinate =
            ConvertDMSToDD(parts[0], parts[2], parts[3], parts[4]);

        return coordinate;
    }
    function convertDMSToDD(degrees, minutes, seconds, direction) {
        var dd = Number(degrees) + Number(minutes) / 60 + Number(seconds) / (60 * 60);

        if (direction == "S" || direction == "W") {
            dd = dd * -1;
        } // Don't do anything for N or E
        return dd;
    }
    function logInitialize(sender, args) {
        logEvent(String.format("<strong>Initialize</strong>: RadMap with ID {0} is about to initialize.", sender.get_id()));
    }

    function logLoad(sender, args) {
        logEvent(String.format("<strong>Load</strong>: RadMap with ID {0} is created.", sender.get_id()));
    }

    function logPan(eventArgs) {
        logEvent(String.format("<strong>Pan</strong>: panning to {0}.", eventArgs.center.toString()));
    }

    function logZoomStart(eventArgs) {
        logEvent("<strong>ZoomStart</strong>: zoom is about to start.");
    }

    function logReset(eventArgs) {
        logEvent("<strong>Reset</strong>: RadMap is reset.");
    }

    function syncConfigurationControls(map) {
        var currCenter = map.center();
        var currZoom = map.zoom();
        //detach the textboxes and dropdown handlers to prevent them from firing when we change their values
        zoomBox.remove_itemSelected(setZoomLevel);
        latitudeBox.remove_valueChanged(setCenterPosition);
        longitudeBox.remove_valueChanged(setCenterPosition);

        zoomBox.findItemByValue(currZoom).set_selected(true);
        latitudeBox.set_value(currCenter.lat);
        longitudeBox.set_value(currCenter.lng);

        //restore the handlers to get the demo functionality working
        zoomBox.add_itemSelected(setZoomLevel);
        latitudeBox.add_valueChanged(setCenterPosition);
        longitudeBox.add_valueChanged(setCenterPosition);
    }

    global.setZoomLevel = setZoomLevel;
    global.setCenterPosition = setCenterPosition;
    global.logZoomEnd = logZoomEnd;
    global.logPanEnd = logPanEnd;
    global.logClick = logClick;
    global.logInitialize = logInitialize;
    global.logLoad = logLoad;
    global.logPan = logPan;
    global.logZoomStart = logZoomStart;
    global.logReset = logReset;

    global.map_load = map_load;
    global.latitudeBox_load = latitudeBox_load;
    global.longitudeBox_load = longitudeBox_load;
    global.zoomBox_load = zoomBox_load;
})(window);