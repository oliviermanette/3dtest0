import QtQuick 2.11
import QtPositioning 5.8
import QtQuick.Controls 2.2
//import QtQml 2.11

Item {
    width: 334
    height: 42
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
                width: 140
                height: parent.height
                color: "transparent"
                Text {
                    id:txtListSiteName;
                    x: 0
                    text: siteName;
                    horizontalAlignment: Text.AlignLeft
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    font.pointSize: 16;
                    font.bold: true ;
                    verticalAlignment: Text.AlignBottom;
                    MouseArea{
                        x: 0
                        anchors.fill: parent
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
                width: 80
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
                    }


                }
            }
            Rectangle{
                width: 110
                height: parent.height
                color: "transparent"
                Button {
                    text: "Add Structure"
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
