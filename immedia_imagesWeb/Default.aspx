<%@ Page Title="Home Page" Language="C#"
    AutoEventWireup="true"
    CodeBehind="Default.aspx.cs"
    Inherits="immedia_imagesWeb._Default" %>

<%@ Register Assembly="AjaxControlToolkit"
    Namespace="AjaxControlToolkit"
    TagPrefix="ajaxToolkit" %>
<%@ Register TagPrefix="telerik"
    Namespace="Telerik.Web.UI"
    Assembly="Telerik.Web.UI" %>
<%@ Register Assembly="System.Web.Ajax"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <script type="text/javascript"
        src="/Scripts/jquery-1.7.1.min.js">
    </script>
    <script type="text/javascript"
        src="/Scripts/geopoint.js">
    </script>
    <script type="text/javascript"
        src="/Scripts/jquery-ui-1.8.17.custom.min.js">
    </script>
    <script type="text/javascript"
        src="/Scripts/mapCoordinatesEvents.js">
    </script>
    <link href="/Content/jquery-ui-1.8.17.custom.css"
        rel="stylesheet" type="text/css" />
    <link href="/Content/Site.css" rel="stylesheet" />
    <title>Venue Photo Finder</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server">
        </asp:ScriptManager>
        <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
            <script type="text/javascript">

                function OnClientRequesting(sender, args) {
                    var context = args.get_context();
                }

                function OnClientClicked() {
                    var $ = $telerik.$;

                    alert("... before!");
                    var searchValue =
                        $find("<%= racLocation.ClientID %>").get_entries().getEntry(0).get_text();

                    alert(searchValue);

                    //Retrieve the list of locations from Bing Locations Service
                    $.ajax({
                        url: "http://dev.virtualearth.net/REST/v1/Locations/",
                        dataType: "jsonp",
                        data: {
                            q: searchValue,
                            key: "Alo-pb5cZ9eeMuhwBpnSZLQsbT2q6wHwiGO4Wd0W1m6sBEiyAsBGHI1qkk5FPWzm"
                        },
                        jsonp: "jsonp",
                        success: loadResults
                    });
                }

                function loadResults(data) {
                    var resourceSets = data.resourceSets;
                    var resources = resourceSets.length > 0 ?
                        resourceSets[0].resources : [];
                    var map = $find("<%= RadMap1.ClientID %>");
                    var listBox = $find("<%= rlbLocations.ClientID %>");
                    var kendoMap = map.kendoWidget;

                    //Clearing previous markers and RadListBox items
                    kendoMap.markers.clear();
                    listBox.get_items().clear();

                    //If there are no locations found, zoom out and center RadMap
                    if (resources.length < 1) {
                        kendoMap.center([0, 0]);
                        kendoMap.zoom(1);
                        return;
                    }

                    for (var i = 0; i < resources.length; i++) {

                        //Create RadListBoxItem and add it to the RadListBox control
                        var item =
                            new Telerik.Web.UI.RadListBoxItem;
                        
                        item.set_text(resources[i].name);
                        item.set_value(resources[i].point.coordinates);
                        listBox.get_items().add(item);

                        //Add marker to RadMap
                        kendoMap.markers.add({
                            location: resources[i].point.coordinates,
                            title: resources[i].name
                        });
                    }
                }

                function centerItem(sender, args) {

                    /* Using the RadListBoxItem value
                     * we are centering RadMap to the location coordinates
                     */
                    var coordinates = args.get_item().get_value();
                    var map = $find("<%= RadMap1.ClientID %>");
                    map.kendoWidget.center(coordinates);
                    map.kendoWidget.zoom(8);

                    var searchVal =
                        "{\"coordinates\":\"" + coordinates + "\"}";

                    //Retrieve Venue Photos from Web API
                    $.ajax({
                        url: "http://localhost/immedia_imagesWebAPI/VenuesSearch/",
                        dataType: "jsonp",
                        data: JSON.stringify(searchVal),
                        jsonp: "jsonp",
                        success: loadResults
                    });
                }
            </script>
        </telerik:RadCodeBlock>
        <div class="jumbotron">
            <h1>VENUE PHOTOS FINDER</h1>
            <p class="lead">This application searches venues for certain location and ultimately get photos.</p>
        </div>
        <table style="padding: 0; border-spacing: 0"
            class="tablePageFrame">
            <tr>
                <td style="width: 100%; text-align: center">
                    <table class="tableMain"
                        style="width: 100%">
                        <tr>
                            <td style="width: 100%; text-align: left; vertical-align: top"
                                class="tdContent" colspan="2">
                                <div id="mainAppDetails">
                                    <table style="width: 100%"
                                        class="tableDefault">
                                        <tr>
                                            <td style="width: 100%"></td>
                                        </tr>
                                    </table>
                                    <div id="showMap"
                                        title="SEARCH VENUES">
                                        <table>
                                            <tr style="vertical-align: top">
                                                <td>
                                                    <telerik:RadMap RenderMode="Lightweight"
                                                        runat="server"
                                                        ID="RadMap1" Zoom="4"
                                                        Width="600px"
                                                        Height="300px">
                                                        <CenterSettings
                                                            Latitude="-28.4783"
                                                            Longitude="23.8953" />
                                                        <LayersCollection>
                                                            <telerik:MapLayer
                                                                Type="Bing"
                                                                Key="Alo-pb5cZ9eeMuhwBpnSZLQsbT2q6wHwiGO4Wd0W1m6sBEiyAsBGHI1qkk5FPWzm">
                                                            </telerik:MapLayer>
                                                            <%--<telerik:MapLayer Type="Tile"
                                                                Subdomains="a,b,c"
                                                                UrlTemplate="http://#= subdomain #.tile.openstreetmap.org/#= zoom #/#= x #/#= y #.png">
                                                            </telerik:MapLayer>--%>
                                                        </LayersCollection>
                                                        <%--<ClientEvents OnClick="logClick" />--%>
                                                    </telerik:RadMap>
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <div id="searchCorners">
                                                                    <b>Enter Search Location:</b>
                                                                    <br />
                                                                    <%-- <telerik:RadTextBox ID="radLocation" 
                                                                        runat="server" Width="180">
                                                                        
                                                                    </telerik:RadTextBox>--%>
                                                                    <telerik:RadAutoCompleteBox
                                                                        RenderMode="Lightweight"
                                                                        ID="racLocation" runat="server"
                                                                        Width="180" DropDownHeight="80"
                                                                        EmptyMessage="-- Enter Location --"
                                                                        OnClientRequesting="requestAutocomplete">
                                                                        <WebServiceSettings Method="GetAutocomplete"
                                                                            Path="DockingHubService.asmx" />
                                                                    </telerik:RadAutoCompleteBox>
                                                                    <br />
                                                                    <br />
                                                                    <telerik:RadButton runat="server"
                                                                        ID="rbSearchLocation"
                                                                        Width="90px"
                                                                        AutoPostBack="false"
                                                                        Text="Search Location"
                                                                        OnClientClicked="OnClientClicked">
                                                                    </telerik:RadButton>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Location(s) found:
                                                                <telerik:RadListBox runat="server"
                                                                    ID="rlbLocations"
                                                                    EmptyMessage="No locations found"
                                                                    Width="190px" Height="205px"
                                                                    OnClientSelectedIndexChanged="centerItem"
                                                                    OnClientItemDoubleClicked="centerItem">
                                                                </telerik:RadListBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <br />
                                                                <br />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Button runat="server"
                                                                    Text="Close"
                                                                    ID="btnClose" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <span>
                                        <asp:Button
                                            ID="btnShowMap"
                                            runat="server"
                                            Text="Show Map"
                                            CausesValidation="false" />
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <script type="text/javascript">

                function requestAutocomplete(sender, eventArgs) {

                    var context = eventArgs.get_context();
                    context["input"] = sender.get_value;
                }

                function setRTBValues(latitude, longitude) {

                }

                // South African map for coordinates
                $("#showMap").dialog({
                    autoOpen: false,
                    height: 550,
                    width: 890,
                    draggable: true,
                    modal: true,
                    open: function (type, data) {
                        $(this).parent().appendTo("form");
                    },
                    close: function () {

                        // Clear the coordinates fields and center map
                        setRTBValues("", "");
                        var map =
                            $find("<%= RadMap1.ClientID %>").kendoWidget;
                        map.center([-28.4783, 23.8953]);
                        map.zoom(5);

                        allFields.val("").removeClass("ui-state-error");
                    }
                });

                $("#btnShowMap").button().click(function (eve) {
                    eve.preventDefault();
                    $("#showMap").dialog("open");
                });
        </script>
    </form>
</body>
</html>
