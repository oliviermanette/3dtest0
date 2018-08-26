import QtQuick 2.11
import QtPositioning 5.8
import QtQuick.Controls 2.2
//import QtQml 2.11

Item {
    width: parent.width
    height: 38
    function showDetailSite()
    {
        editSites.siteName = siteName;
        editSites.siteDescription = siteDescription;
        editSites.siteLatitude = SiteLatitude;
        editSites.siteLongitude = SiteLongitude;
        editSites.siteID = siteID;
        editSites.btnUpdate = "Update";
    }
    Rectangle{
        id:lstRectangle
        anchors.fill: parent
        color: "#d0d1e6"
        radius: 4
        border.color: "#d8d9d4"
        Row{


            id:clnListSites
            anchors.fill: parent
            spacing: 1
            Rectangle{
                width: 0.38*parent.width
                height: parent.height
                color: "transparent"
                Text {
                    id:txtListSiteName;
                    text: siteName;
                    horizontalAlignment: Text.AlignLeft
                    font.pointSize: 16//0.16*parent.width;
                    font.bold: true ;
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                    width: parent.width
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: txtListSiteName.color="#0cea08";
                        onExited: txtListSiteName.color="black"
                        onClicked: {
                            showerMap.visible = true;
                            siteOpen1.visible = false;
                            showerMap.mapCenter = QtPositioning.coordinate(SiteLatitude, SiteLongitude);
                            showDetailSite();
                        }
                    }
                }
            }
            Rectangle{
                id:rctOpenSite
                width: 0.3*parent.width
                height: parent.height
                color: "transparent"
                Button {
                    text: "Open"
                    flat: true
                    onClicked: {
                        showerMap.mapCenter = QtPositioning.coordinate(SiteLatitude, SiteLongitude);
                        showDetailSite();
                        zoomInAnimation.start();
                        siteOpen1.txtSiteNameOpen = siteName
                        siteOpen1.txtSizeX = cymBdd.getSiteSizeX(siteID);
                        siteOpen1.txtSizeY = cymBdd.getSiteSizeY(siteID);
                        siteOpen1.intScale = cymBdd.getSiteScale(siteID);
                        siteOpen1.siteID = siteID;
                    }
                }
            }
            Rectangle{
                width: 0.3*parent.width
                height: parent.height
                color: "transparent"
                Button {
                    text: "+ Struct."
                    flat: true
                }
            }
        }
    }

}

/*##^## Designer {
    D{i:9;anchors_height:40;anchors_width:334}
}
 ##^##*/
