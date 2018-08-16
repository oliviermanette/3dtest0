import QtQuick 2.0
import QtQuick.Controls 1.4
import QtPositioning 5.8

Item {
    property double dblLatitude: 0
    property double dblLongitude: 0
    width: 320
    height: 320
    Rectangle {
        id: rectangle
        color: "#5b659b"
        anchors.fill: parent

        Text {
            id: text1
            x: 63
            y: 8
            text: qsTr("Add a new Site")
            font.family: "Tahoma"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 26
        }

        Text {
            id: text2
            x: 8
            y: 49
            text: qsTr("Name : ")
            font.bold: true
            font.pixelSize: 16
        }

        TextField {
            id: txtNewSiteName
            x: 74
            y: 46
            width: 238
            height: 22
            font.bold: true
            font.wordSpacing: 0
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: text3
            x: 8
            y: 74
            text: qsTr("Description : ")
            font.bold: true
            font.pixelSize: 16
        }

        TextArea {
            id: txtNewSiteDescription
            x: 8
            y: 99
            width: 304
            height: 78
            font.wordSpacing: 0
        }

        Button {
            id: btnCancelANSite
            y: 256
            text: qsTr("Cancel")
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
            tooltip: ""
            onClicked: {
                popup.close();
            }
        }

        Button {
            id: btnOkAddNewSite
            x: 258
            y: 256
            text: qsTr("OK")
            transformOrigin: Item.Center
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
            tooltip: "Add a new site"
            isDefault: true
            onClicked: {
                //QString strNom, double dblLatitude, double dblLongitude, QString strCommentaire

                cymBdd.addNewSite(txtNewSiteName.text, dblLatitude,dblLongitude, txtNewSiteDescription.text);

                var lclChaine = {"siteIntegrity": 5.95, "siteName":"Pizza", "SiteLatitude":48, "SiteLongitude":1.5};
                var lintNbSites = cymBdd.getNbSites();
                console.log(lintNbSites);
                siteModel.clear();
                for (var i=0;i<lintNbSites;i++){
                    lclChaine.siteIntegrity = "100%";
                    lclChaine.siteName = cymBdd.getSiteName(i);//"Hambourg";
                    lclChaine.SiteLatitude = cymBdd.getSiteLatitude(i);
                    lclChaine.SiteLongitude = cymBdd.getSiteLongitude(i);
                    siteModel.append(lclChaine);
                }


                //showerMap.mapCenter = QtPositioning.coordinate(siteModel.get(0).SiteLatitude, siteModel.get(0).SiteLongitude);
                popup.close();
            }
        }

        Text {
            id: text4
            x: 8
            y: 183
            text: qsTr("Latitude:")
            font.pixelSize: 16
        }

        Text {
            id: text5
            x: 8
            y: 221
            text: qsTr("Longitude:")
            font.pixelSize: 16
        }

        TextField {
            id: txtLatitude
            x: 111
            y: 183
            width: 147
            height: 22
            placeholderText: qsTr("Text Field")
        }

        TextField {
            id: txtLongitude
            x: 111
            y: 221
            width: 147
            height: 22
            placeholderText: qsTr("Text Field")
        }
    }

}

/*##^## Designer {
    D{i:7;anchors_x:8}D{i:1;anchors_height:200;anchors_width:200;anchors_x:18;anchors_y:13}
}
 ##^##*/
