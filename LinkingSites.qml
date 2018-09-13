import QtQuick 2.11
import QtQuick.Controls 2.4
import QtPositioning 5.8

Rectangle {
    property bool blSelected1: false
    property string strSelectedSType: " Select Type "
    property double ldblWidthRatio: 0.4
    property int intTxtFldHeight: 25
    property int intSelectedSType: 0
    property var lvrComponent;
    property var lvrSprite;

    function fctSelectSite(selectedSiteIdx){
        if (!blSelected1){
            cmbBoxSite1.currentIndex = selectedSiteIdx;
        }
        else{
            cmbBoxSite2.currentIndex = selectedSiteIdx;
        }
    }

    function deleteTempSprite(){
        if ((lvrSprite !== null)&&(typeof lvrSprite !== "undefined"))
            lvrSprite.destroy();
    }

    function createTempSpriteObjects(lat1,long1,lat2,long2) {
        deleteTempSprite();
        lvrComponent = Qt.createComponent("Pipeline.qml");
        lvrSprite = lvrComponent.createObject(showerMap.getMap,{"path": [
                                            { latitude: lat1, longitude: long1 },
                                            { latitude: lat2, longitude: long2 }]});
        lvrSprite.line.width=5;
        lvrSprite.line.color="black";


        if (lvrSprite === null) {
            // Error Handling
            console.log("Error creating object");
        }
        else{
            showerMap.getMap.addMapItem(lvrSprite);
            currentPipe++;
            console.log("Add Temporary object to map");
        }
    }

    color: "#f7f7ef"
    //anchors.fill: parent
    radius: 4
    width: parent.width -0.02*parent.width
    height: 0.35*parent.height
    Column{
        anchors.fill: parent
        spacing: 0.03*parent.width
        padding: 0.02*parent.width
        Row{
            spacing: 9
            width: parent.width
            layoutDirection: Qt.LeftToRight
            Text {
                id: text0
                color: "#10110e"
                text: qsTr("Connect Two Sites:")
                horizontalAlignment: Text.AlignLeft
                font.bold: true
                font.pixelSize: 18
                width: 0.6*parent.width
            }
        }
        Row{
            spacing: 9
            width: parent.width
            layoutDirection: Qt.LeftToRight
            Text {
                id: text1
                color: "#10110e"
                text: qsTr("Sites #1:")
                horizontalAlignment: Text.AlignLeft
                font.bold: true
                font.pixelSize: 14
                width: 0.3*parent.width
            }

            ComboBox {
                id: cmbBoxSite1
                model: siteModel
                textRole: "siteName"
                onCurrentIndexChanged: {
                    blSelected1 =true;
                    showerMap.mapCenter = QtPositioning.coordinate(siteModel.get(currentIndex).SiteLatitude, siteModel.get(currentIndex).SiteLongitude);
                }
            }
        }
        Row{
            spacing: 9
            width: parent.width
            layoutDirection: Qt.LeftToRight
            Text {
                id: text2
                color: "#10110e"
                text: qsTr("Sites #2:")
                horizontalAlignment: Text.AlignLeft
                font.bold: true
                font.pixelSize:14
                width: 0.3*parent.width
            }

            ComboBox {
                id: cmbBoxSite2
                model: siteModel
                textRole: "siteName"
                onCurrentIndexChanged: {
                    //au milieu des 2
                    blSelected1 =false;
                    var lfltLat = siteModel.get(currentIndex).SiteLatitude + siteModel.get(cmbBoxSite1.currentIndex).SiteLatitude;
                    var lfltLong = siteModel.get(currentIndex).SiteLongitude + siteModel.get(cmbBoxSite1.currentIndex).SiteLongitude;
                    var lfltLatitude = lfltLat/2;
                    var lfltLongitude = lfltLong/2;
                    lfltLat = siteModel.get(currentIndex).SiteLatitude - siteModel.get(cmbBoxSite1.currentIndex).SiteLatitude;
                    lfltLong = siteModel.get(currentIndex).SiteLongitude - siteModel.get(cmbBoxSite1.currentIndex).SiteLongitude
                    var lfltDistance = Math.sqrt(Math.pow(lfltLat,2)+Math.pow(lfltLong,2));

                    console.log(lfltDistance);
                    showerMap.mapCenter = QtPositioning.coordinate(lfltLatitude, lfltLongitude);
                    //Ok mais il faut dézoomer pour voir les 2
                    showerMap.mapZoom = (-0.34) * lfltDistance + 9.8;
                    createTempSpriteObjects(siteModel.get(cmbBoxSite1.currentIndex).SiteLatitude,
                                        siteModel.get(cmbBoxSite1.currentIndex).SiteLongitude,
                                        siteModel.get(currentIndex).SiteLatitude,
                                        siteModel.get(currentIndex).SiteLongitude);
                    /*Pour trouver les chiffres ci-dessus j'ai résolu le système d'équation suivant:
                      16x+y=4;
                      1,2x+y=9;
                      Avec 16 et 1,2 les distances calculés entre Örebro et Reims et entre Montreal et Mont Tremblant
                      Et j'y ai mis les niveaux de zoom correspondant souhaité.
                      9 je suis à peu près sûr pour ce zoom mais le 4 je l'ai mis au pif et j'ai eu des résultats corrects.
                      plus le zoom est petit et plus on est loin;
                      Donc si on se trouve trop loin, il faudrait résoudre en changeant par 5 et 10 par exemple.
                      ça ne change rien pour x mais ça change y
                      */
                    console.log(showerMap.mapZoom);

                }
            }
        }
        Column{
            width: parent.width- 2* parent.padding
            spacing: 2
            padding: 5
            Row{
                width: parent.width
                spacing: 4
                Text {
                    id: name6
                    text: qsTr("Type :")
                    font.pointSize: 16
                    font.bold: true
                    width: ldblWidthRatio* parent.width
                }
            }
            Row{
                width: parent.width - 2* parent.padding
                spacing: 8
                Button{
                    flat: true
                    id:btnNewStructType
                    text: " New "
                    enabled: false
                    font.underline: true
                    font.family: "Tahoma"
                    font.capitalization: Font.MixedCase
                    font.bold: false
                    width: ldblWidthRatio* parent.width
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: btnNewStructType.font.bold = true;
                        onExited: btnNewStructType.font.bold = false;
                        onClicked: {

                        }

                    }
                }
                Connections{
                    target: cymBdd
                    onSTypeSelected:{
                        intSelectedSType = uinSTypeID;
                        btnSelectStructType.text = strSTypeName;
                    }
                }
                Button{
                    id:btnSelectStructType
                    flat: true
                    text: strSelectedSType
                    font.underline: true
                    font.capitalization: Font.MixedCase
                    font.bold: false
                    width: ldblWidthRatio* parent.width
                    onTextChanged: font.bold=true;
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: btnSelectStructType.font.bold = true;
                        onExited: btnSelectStructType.font.bold = false;
                        onClicked: {
                            cymBdd.updateSType();
                            fctUpdateSType();
                            listView.visible = false;
                            listViewSType.visible = true;
                        }
                    }
                }
            }
        }
        Row{
            layoutDirection: Qt.LeftToRight
            spacing: 0.1*parent.width
            padding: 5
            Button{
                id:btnCanNewLink
                text: "Cancel"
                height: intTxtFldHeight
                onClicked: {
                    blSelected1 =false;
                    edtLnkSites.visible = false;
                    deleteTempSprite();
                }
            }
            Button{
                id:btnAddNewLink
                text: "Add"
                font.pointSize: 14
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
                font.bold: true
                height: intTxtFldHeight
                onClicked: {
                    if (cymBdd.addLinkToSites(siteModel.get(cmbBoxSite1.currentIndex).siteID,
                                              siteModel.get(cmbBoxSite2.currentIndex).siteID, intSelectedSType)){
                        blSelected1 =false;
                        edtLnkSites.visible = false;
                        strSelectedSType = " Select Type ";
                        intSelectedSType = 0;
                        fctUpdateSitesList();
                        deleteTempSprite();
                        fctUpdatePipelines();
                    }
                    else
                        btnAddNewLink.text = "ERROR"

                }
            }
        }
    }
}
