import QtQuick 2.11
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.4

Item {
    property string siteName: ""
    property string siteDescription: ""
    property double siteLatitude: 0
    property double siteLongitude: 0
    property int siteID: 0
    property string btnUpdate: "Update"
    width: parent.width -0.02*parent.width
    height: 0.45*parent.height
    Rectangle {
        id: rectangle
        radius: 0.02*parent.width
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#33333f"
            }

            GradientStop {
                position: 1
                color: "#515160"
            }
        }
        border.width: 0
        anchors.fill: parent
        Column{
            anchors.fill: parent
            spacing: 0.03*parent.width
            padding: 0.02*parent.width
            Row{
                spacing: 9
                width: parent.width
                layoutDirection: Qt.LeftToRight
                Text {
                    id: text1
                    color: "#f8f9f4"
                    text: qsTr("Sites")
                    font.bold: true
                    font.pixelSize: 18
                    width: 0.6*parent.width
                }
                Button {
                    id: btnEdtSitesDelete
                    width: 77
                    height: 17
                    text: qsTr("Delete")
                    font.weight: Font.Medium
                    font.bold: true
                    //flat: true
                    font.capitalization: Font.AllUppercase
                    onClicked: {
                        cymBdd.delSite(siteID);
                        if (cymBdd.filterSitesByND("")){
                            var lclChaine = {"siteIntegrity": 5.95, "siteName":"Pizza", "SiteLatitude":48, "SiteLongitude":1.5, "siteDescription":"My Description", "siteID":0};
                            var lintNbSites = cymBdd.getNbSites();
                            console.log(lintNbSites);
                            siteModel.clear();
                            for (var i=0;i<lintNbSites;i++){
                                lclChaine.siteIntegrity = "100%";
                                lclChaine.siteName = cymBdd.getSiteName(i);//"Hambourg";
                                lclChaine.SiteLatitude = cymBdd.getSiteLatitude(i);
                                lclChaine.SiteLongitude = cymBdd.getSiteLongitude(i);
                                lclChaine.siteDescription = cymBdd.getSiteDescription(i);
                                lclChaine.siteID = cymBdd.getSiteID(i);
                                siteModel.append(lclChaine);
                            }
                            siteName = "";
                            siteDescription = "";
                            siteLatitude = 0;
                            siteLongitude = 0;
                            siteID = 0;
                            btnUpdate = "DELETED !";
                        }
                    }
                }
            }

            Row{
                spacing: 11
                width: parent.width
                Text {
                    id: text2
                    color: "#f8f9f4"
                    text: qsTr("Name")
                    //horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 16
                    width: 0.3* parent.width
                }

                TextField {
                    id: txtEdtSiteName
                    width: 0.6*parent.width
                    height: 26
                    text: qsTr(siteName)
                    placeholderText: "Name"
                }
            }

            Text {
                id: text3
                color: "#f8f9f4"
                text: qsTr("Description")
                font.pixelSize: 16
                //horizontalAlignment: Text.AlignLeft
            }

            TextArea {
                id: txtEdtSitesDescription
                width: 0.95*parent.width
                height: 116
                text: siteDescription
                placeholderText: "Description"
                textFormat: Text.PlainText
                wrapMode: Text.WordWrap
                background: Rectangle { color: "#f7f7dd"
                radius: 3}
            }
            Row{
                width: parent.width
                Text {
                    id: text4
                    color: "#f8f9f4"
                    text: qsTr("Long.")
                    font.pixelSize: 16
                    //horizontalAlignment: Text.AlignLeft
                    width: 0.3* parent.width
                }

                TextField {
                    id: txtEdtSiteLongitude
                    width: 0.65*parent.width
                    height: 26
                    text: Number(siteLongitude).toString()
                    placeholderText: "Longitude"
                }

            }
            Row{
                width: parent.width
                Text {
                    id: text5
                    color: "#f8f9f4"
                    text: qsTr("Lat.")
                    font.pixelSize: 16
                    //horizontalAlignment: Text.AlignRight
                    width: 0.3*parent.width
                }
                TextField {
                    id: txtEdtSiteLatitude
                    width: 0.65*parent.width
                    height: 26
                    text: Number(siteLatitude).toString()
                    placeholderText: "Latitude"
                }
            }
            Row{
                spacing: 0.1*parent.width
                padding: 0.1*parent.width
                width: parent.width
                Button {
                    id: btnEdtSitesCancel
                    width: 0.3*parent.width
                    height: 26
                    text: qsTr("Cancel")
                    font.capitalization: Font.MixedCase
                }
                Button {
                    id: btnEdtSitesUpdate
                    width: 0.3*parent.width
                    height: 26
                    text: btnUpdate
                    font.capitalization: Font.AllUppercase
                    font.bold: true
                    onClicked: {
                        if (cymBdd.setUpdateSite(siteID, txtEdtSiteName.text, txtEdtSitesDescription.text, txtEdtSiteLatitude.text, txtEdtSiteLongitude.text))
                        {
                            btnUpdate="Updated !";
                            if (cymBdd.filterSitesByND("")){
                                var lclChaine = {"siteIntegrity": 5.95, "siteName":"Pizza", "SiteLatitude":48, "SiteLongitude":1.5, "siteDescription":"My Description", "siteID":0};
                                var lintNbSites = cymBdd.getNbSites();
                                console.log(lintNbSites);
                                siteModel.clear();
                                for (var i=0;i<lintNbSites;i++){
                                    lclChaine.siteIntegrity = "100%";
                                    lclChaine.siteName = cymBdd.getSiteName(i);//"Hambourg";
                                    lclChaine.SiteLatitude = cymBdd.getSiteLatitude(i);
                                    lclChaine.SiteLongitude = cymBdd.getSiteLongitude(i);
                                    lclChaine.siteDescription = cymBdd.getSiteDescription(i);
                                    lclChaine.siteID = cymBdd.getSiteID(i);
                                    siteModel.append(lclChaine);
                                }
                            }
                        }
                        else
                            btnUpdate="try later";
                    }
                }

            }
        }
    }
}

/*##^## Designer {
    D{i:1;anchors_height:200;anchors_width:200;anchors_x:82;anchors_y:80}
}
 ##^##*/
