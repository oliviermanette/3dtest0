import QtQuick 2.11
import QtPositioning 5.8

Item {
    width: 334
    height: 42
    Rectangle{
        id:lstRectangle
        anchors.fill: parent
        color: "#d0d1e6"
        radius: 4
        border.color: "#d8d9d4"
        Column{
            id:clnListSites
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.left: parent.left
            anchors.leftMargin: 12
            spacing: 5
            Text { id:txtListSiteName;text: siteName; font.pointSize: 16; font.bold: true ; verticalAlignment: Text.AlignBottom;}
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            showerMap.mapCenter = QtPositioning.coordinate(SiteLatitude, SiteLongitude);
            editSites.siteName = siteName;
            editSites.siteDescription = siteDescription;
            editSites.siteLatitude = SiteLatitude;
            editSites.siteLongitude = SiteLongitude;
            editSites.siteID = siteID;
            editSites.btnUpdate = "Update";
        }
    }
}
