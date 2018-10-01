import QtQuick 2.11
import QtQuick.Controls 2.2
//import QtQuick.Controls 1.4
import QtPositioning 5.8

Item {
    property var composant;
    property var sprite:[];
    property int currentPipe:0;

    function fctGetPath()
    {
        return cymBdd.getLocalPath();
    }

    function fctUpdateSitesList()
    {
        var lclChaine = {
            "siteName":"Pizza",
            "siteIntegrity": 5.95,
            "SiteLatitude":48,
            "SiteLongitude":1.5,
            "siteDescription":"My Description",
            "siteLink":0,
            "siteLinkStruct":0,
            "siteID":0
        };
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
            lclChaine.siteLink = cymBdd.getSiteLinked(i);
            lclChaine.siteLinkStruct = cymBdd.getSiteLinkStruct(i);
            siteModel.append(lclChaine);
        }
    }

    function fctUpdateSType(){
        if (cymBdd.checkCachesFolders())
            console.log("cache folders succesfully created");
        var lintNbSTypes = cymBdd.getNbSTypes();
        var lclChaine = {
            "sTypeID": 1,
            "name":"Pizza",
            "description":"My Description"
        };
        sTypeModel.clear();
        for (var i=0;i<lintNbSTypes;i++){
            lclChaine.sTypeID = cymBdd.getSTypeID(i);
            if (!cymBdd.isFileExist("/structuretypes/icon/"+Number(lclChaine.sTypeID).toString())){
                cymBdd.downloadFileFromCloud("structuretypes/icon", Number(lclChaine.sTypeID).toString());
            }
            lclChaine.name = cymBdd.getSTypeName(i);
            lclChaine.description = cymBdd.getSTypeDescription(i);
            sTypeModel.append(lclChaine);
        }
    }
    function delPipeline(lintIndex){
        if ((sprite[lintIndex] !== null)&&(typeof sprite[lintIndex] !== "undefined"))
            sprite[lintIndex].destroy();
        cymBdd.delPipeline(lintIndex);
        fctUpdatePipelines();
        fctUpdateSitesList();
    }

    function createSpriteObjects(lat1,long1,lat2,long2) {
        if ((sprite[currentPipe] !== null)&&(typeof sprite[currentPipe] !== "undefined"))
            sprite[currentPipe].destroy();
        composant = Qt.createComponent("Pipeline.qml");
        sprite[currentPipe] = composant.createObject(showerMap.getMap,{"path": [
                                            { latitude: lat1, longitude: long1 },
                                            { latitude: lat2, longitude: long2 }]});
        sprite[currentPipe].line.width=8;
        sprite[currentPipe].index = currentPipe;
        sprite[currentPipe].fctDelete = delPipeline;

        if (sprite[currentPipe] === null) {
            // Error Handling
            console.log("Error creating object");
        }
        else{
            showerMap.getMap.addMapItem(sprite[currentPipe]);
            currentPipe++;
            console.log("Add Object to map :",currentPipe);
        }
    }

    function fctUpdatePipelines(){
        var lnbPipes = cymBdd.getPipelineNb();
        currentPipe = 0;

        for (var i=0;i<lnbPipes;i++)
        {
            createSpriteObjects(cymBdd.getLineSiteLat1(i),
                                cymBdd.getLineSiteLong1(i),
                                cymBdd.getLineSiteLat2(i),
                                cymBdd.getLineSiteLong2(i));
        }
    }


    //property alias popAddNewSite: popAddNewSite
    anchors.fill: parent
    Popup {
        id: popup
        x: 100
        y: 300
        width: 345
        height: 345
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        PopAddNewSite{
            id:winAddNewSite
        }
    }
    Popup{
        id: popAskLogin
        width: 345
        height: 345
        x: (parent.width -width)/2
        y: (parent.height - height)/2

        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose
        PopLogin{
            id:winSignIn
        }
        Connections {
            target: cymBdd
            onLoginRequired: {
                console.log('should open the popup now or never');
                popAskLogin.open();
            }
        }
    }

    Row{
        id: row
        anchors.fill: parent

        ListModel{
            id:siteModel
        }
        ListModel{
            id:sTypeModel
        }
        ListModel{
            id:structModel
        }

        Rectangle{
            id: rctTreeView
            width: 0.18*parent.width
            height: parent.height
            color: "#B3B3B3"
            objectName: "rect"
            radius: 4
            border.color: "#2A4161"
            border.width: 1
            Column{
                anchors.fill: parent
                padding: 2
                spacing: 3

                FilterSites{
                    z:10
                }

                ListView{
                    id:listSites
                    width: parent.width
                    height: 0.8*parent.height
                    model: siteModel
                    delegate: Component {

                        LineSites{
                            id: lstListSites
                        }
                    }
                }
            }
        }
        Rectangle{
            id:rctEditInfo
            width: 0.18*parent.width
            height: parent.height
            color: "#B3B3B3"
            radius: 4
            border.color: "#2A4161"
            border.width: 1
            Column{
                anchors.fill: parent
                padding: 2
                spacing: 3
                Button {
                    id: btnAddNewSite
                    width: 0.4*parent.width
                    height: 31
                    text: qsTr("Add New Site")

                    onClicked: {
                        popup.open();
                    }
                }
                EditStruct{
                    id:editStruct1
                    visible: false
                }

                EditSites {
                    id: editSites
                    visible: false
                }
                EditSiteSize{
                    id: edtSiteSize
                    visible: false
                }
                LinkingSites{
                    id: edtLnkSites
                    visible: false
                }
            }

        }

        Rectangle{
            id: mapArea
            width: 0.46*parent.width
            height: parent.height
            color: "#2A4161"
            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: "#F0F0F0";
                }
                GradientStop {
                    position: 1.00;
                    color: "#B3B3B3";
                }
            }
            radius: 4
            border.color: "#2A4161"
            border.width: 1

            Column{
                anchors.fill : parent
                padding: 2
                spacing: 3
                Row{
                    spacing: 10
                    width: parent.width
                    TextField {
                        id: searchTextField
                        width: 0.7*parent.width
                        height: 28
                        text: qsTr("Search Place")

                        MouseArea {
                            id: mouseArea
                            height: 24
                            anchors.topMargin: 0
                            anchors.fill: parent
                            onClicked: {
                                searchTextField.focus = true;
                                if (searchTextField.text == "Search Place")
                                    searchTextField.text ="";
                            }
                        }
                    }

                    Button {
                        id: button
                        width: 0.2* parent.width
                        height: 33
                        text: qsTr("Search")

                        onClicked: {
                            showerMap.strSearchField = searchTextField.text;
                            listView.visible = true;
                            listViewSType.visible = false;
                        }
                    }

                }
                MapShow{
                    id:showerMap
                    width: parent.width-2*parent.padding
                    height: 0.95*parent.height
                    ScaleAnimator {
                            id:zoomInAnimation
                            target: showerMap;
                            from: 1;
                            to: 2;
                            duration: 300
                            running: false
                            onStopped: {
                                showerMap.visible = false;
                                siteOpen1.visible = true;
                                zoomOutAnimation.start();
                            }
                        }
                    ScaleAnimator{
                        id:zoomOutAnimation
                        target: showerMap
                        from: 2
                        to: 1
                        duration: 1
                        running: false
                    }
                }
                SiteOpen{
                    id:siteOpen1
                    visible: false
                    width: parent.width-2*parent.padding
                    height: 0.95*parent.height
                    onVisibleChanged: {
                        if (visible==true) {
                            showerMap.visible = false;
                            stlViewer.visible=false;
                        }
                    }
                }
                Column{
                    width: parent.width-2*parent.padding
                    height: 0.95*parent.height
                    Row{
                        Rectangle{
                            width: 30
                            height: 30
                            color: "yellow"
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    var lclCapteur = {
                                        "sensorName":"Pizza",
                                        "sensorPosX": 0,
                                        "sensorPosY":0,
                                        "sensorPosZ":0,
                                        "siteDescription":"My Description",
                                        "siteLink":0,
                                        "siteLinkStruct":0,
                                        "siteID":0
                                    };
                                    stlViewer.extSensors.clear();
                                    cymBdd.loadNewSTLFile(stlViewer.strFilename);
                                    lclCapteur.sensorPosX = cymBdd.getCurrentVertexX();
                                    lclCapteur.sensorPosY = cymBdd.getCurrentVertexY();
                                    lclCapteur.sensorPosZ = cymBdd.getCurrentVertexZ();

                                    console.log(stlViewer.strFilename);
                                    console.log(lclCapteur.sensorPosX);
                                    console.log(lclCapteur.sensorPosY);
                                    console.log(lclCapteur.sensorPosZ);
                                    stlViewer.extSensors.append(lclCapteur);
                                }
                            }
                        }

                        Rectangle{
                            width: 30
                            height: 30
                            color: "red"
                            Timer{
                                id:fastBackward
                                onTriggered: stlViewer.intPosX += 25;
                                interval: 77
                                repeat: true
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: stlViewer.intPosX += 10;
                                onPressAndHold: fastBackward.start();
                                onReleased: fastBackward.stop();
                            }
                        }
                        Rectangle{
                            width: 30
                            height: 30
                            color: "blue"
                            Timer{
                                id:fastForward
                                onTriggered: stlViewer.intPosX -= 25;
                                interval: 77
                                repeat: true
                            }


                            MouseArea{
                                anchors.fill: parent
                                onClicked: stlViewer.intPosX -= 10;
                                onPressAndHold: fastForward.start();
                                onReleased: fastForward.stop();

                            }
                        }
                        Rectangle{
                            width: 20
                            height: 20
                            color: "green"
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {

                                    var lclCapteur = {
                                        "sensorName":"Pizza",
                                        "sensorPosX": 0,
                                        "sensorPosY":0,
                                        "sensorPosZ":0,
                                        "siteDescription":"My Description",
                                        "siteLink":0,
                                        "siteLinkStruct":0,
                                        "siteID":0
                                    };
                                    stlViewer.extSensors.clear();
                                    cymBdd.nextVertex();
                                    lclCapteur.sensorPosX = cymBdd.getCurrentVertexX();
                                    lclCapteur.sensorPosY = cymBdd.getCurrentVertexY();
                                    lclCapteur.sensorPosZ = cymBdd.getCurrentVertexZ();

                                    console.log(stlViewer.strFilename);
                                    console.log(lclCapteur.sensorPosX);
                                    console.log(lclCapteur.sensorPosY);
                                    console.log(lclCapteur.sensorPosZ);
                                    stlViewer.extSensors.append(lclCapteur);
                                }
                            }
                        }
                        Rectangle{
                            width: 30
                            height: 30
                            color: "orange"
                            MouseArea{
                                anchors.fill: parent
                                onClicked: stlViewer.extRotate.start()

                            }
                        }
                    }


                    StlShow{
                        id:stlViewer
                        visible: false
                        width: parent.width-2*parent.padding
                        height: 0.95*parent.height
                    }
                }
            }
        }

        Rectangle {
            id: rctContextInfo
            width: 0.18*parent.width
            height: parent.height
            color: "#B3B3B3"
            border.color: "#2A4161"
            border.width: 1
            radius: 4
            Column{
                anchors.fill : parent
                padding: 2
                spacing: 3
                Button {
                    id: btnSignIn
                    width: 117
                    flat: true
                    height: 31
                    text: qsTr("Sign In")

                    onClicked: {
                        //popup.open();
                        if (cymBdd.getOwnerID()){
                            cymBdd.signOut();

                            siteModel.clear();

                            editSites.visible = false;
                            editStruct1.visible = false;
                            EditSiteSize.visible = false;

                            btnSignIn.text = "Sign In";
                        }
                        else
                            popAskLogin.open();
                    }
                }
                ListView {
                    id: listView
                    flickDeceleration: 1494
                    width: 0.99*parent.width
                    height: 0.9*parent.height
                    //visible: false
                    model: showerMap.lstModel
                    delegate:Component {


                        LineSearch{
                            id: titi
                        }
                    }
                }
                ListView{
                    id: listViewSType

                    flickDeceleration: 1494
                    width: 0.99*parent.width
                    height: 0.9*parent.height
                    visible: false
                    model: sTypeModel

                    delegate:Component {


                        LineSType{
                            id: toge
                        }
                    }
                }
            }





        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
