import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtPositioning 5.8

Item {
    //property alias popAddNewSite: popAddNewSite
    Popup {
        id: popup
        x: 100
        y: 300
        width: 345
        height: 345
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        //background: "grey"

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

        ListModel{
            id:siteModel
        }


        Rectangle{
            id: rectangle
            width: 350
            height: 700
            color: "#b0afb9"
            border.color: "#2e2e3a"
            border.width: 4
            TextField {
                id: txtFldSiteSearch
                x: 281
                y: 0
                width: 238
                height: 23
                placeholderText: qsTr("Filter sites")
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.top: parent.top
                anchors.topMargin: 8
            }

            Button {
                id: btnSearchSite
                x: 252
                y: 4
                width: 90
                height: 31
                text: qsTr("Filter")
                onClicked: {
                    if (cymBdd.filterSitesByND(txtFldSiteSearch.text)){
                        var lclChaine = {"siteIntegrity": 5.95, "siteName":"Pizza", "SiteLatitude":48, "SiteLongitude":1.5, "siteDescription":"My Description"};
                        var lintNbSites = cymBdd.getNbSites();
                        console.log(lintNbSites);
                        siteModel.clear();
                        for (var i=0;i<lintNbSites;i++){
                            lclChaine.siteIntegrity = "100%";
                            lclChaine.siteName = cymBdd.getSiteName(i);//"Hambourg";
                            lclChaine.SiteLatitude = cymBdd.getSiteLatitude(i);
                            lclChaine.SiteLongitude = cymBdd.getSiteLongitude(i);
                            lclChaine.siteDescription = cymBdd.getSiteDescription(i);
                            siteModel.append(lclChaine);
                        }
                    }
                }
            }

            Button {
                id: btnAddNewSite
                x: 225
                y: 661
                width: 117
                height: 31
                text: qsTr("Add New Site")
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8


                onClicked: {
                    popup.open();
                }
            }

            TreeView {
                x: 8
                y: 37
                width: 334
                height: 353
                TableViewColumn {
                    title: "Name"
                    role: "siteName"
                    width: 150
                }
                TableViewColumn {
                    title: "Integrity"
                    role: "siteIntegrity"
                    width: 100
                }
                model: siteModel
                Component.onCompleted: {
                    //console.log('started here ! Thanks !');
                    var lclChaine = {"siteIntegrity": 5.95, "siteName":"Pizza", "SiteLatitude":48, "SiteLongitude":1.5, "siteDescription":"My Description"};
                    var lintNbSites = cymBdd.getNbSites();
                    //console.log(lintNbSites);
                    for (var i=0;i<lintNbSites;i++){
                        lclChaine.siteIntegrity = "100%";
                        lclChaine.siteName = cymBdd.getSiteName(i);//"Hambourg";
                        lclChaine.siteDescription = cymBdd.getSiteDescription(i);
                        lclChaine.SiteLatitude = cymBdd.getSiteLatitude(i);
                        lclChaine.SiteLongitude = cymBdd.getSiteLongitude(i);
                        siteModel.append(lclChaine);
                    }
                }

                onClicked: {
                    console.log(currentIndex.row);
                    console.log(currentIndex.column);
                    console.log(siteModel.get(currentIndex.row).SiteLatitude);
                    console.log(siteModel.get(currentIndex.row).SiteLongitude);
                    console.log(siteModel.get(currentIndex.row).siteName)
                    showerMap.mapCenter = QtPositioning.coordinate(siteModel.get(currentIndex.row).SiteLatitude, siteModel.get(currentIndex.row).SiteLongitude);
                    editSites.siteName = siteModel.get(currentIndex.row).siteName;
                    editSites.siteDescription = siteModel.get(currentIndex.row).siteDescription;
                    editSites.siteLatitude = siteModel.get(currentIndex.row).SiteLatitude;
                    editSites.siteLongitude = siteModel.get(currentIndex.row).SiteLongitude;
                    //showerMap.update();
                    //const QModelIndex = index;

                }
            }

            EditSites {
                id: editSites
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                visible: false
            }
        }

        Rectangle{
            id: mapArea
            width: 600
            height: 700
            color: "#2e2e3a"

            MapShow{
                id:showerMap
                anchors.rightMargin: 3
                anchors.leftMargin: 1
                anchors.bottomMargin: 4
                anchors.topMargin: 37
                anchors.fill: parent
            }

            TextField {
                id: searchTextField
                y: 2
                width: 492
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
                x: 494
                y: 0
                width: 106
                height: 33
                text: qsTr("Search")
                //isDefault: true
                //activeFocusOnPress: true

                onClicked: {

                    showerMap.strSearchField = searchTextField.text;
                    //showerMap.lstModel = showerMap.searchModel;
                }
            }

        }

        Rectangle {
            enabled: false
            visible: false

            id: scene
            width: 600
            height: 700
            color: "#e1eef3"
        }

        Rectangle {
            id: rctContextInfo
            width: 281
            height: 700
            color: "#b0afb9"
            border.color: "#2e2e3a"
            border.width: 1
            Button {
                id: btnSignIn
                x: 10
                y: 1
                width: 117
                height: 31
                text: qsTr("Sign In")
                anchors.right: parent.right
                anchors.rightMargin: 4


                onClicked: {
                    //popup.open();
                    if (cymBdd.getOwnerID()){
                        //sign out
                        cymBdd.signOut();

                        siteModel.clear();

                        editSites.visible = false;

                        btnSignIn.text = "Sign In";
                    }
                    else
                        popAskLogin.open();
                }
            }

            ListView {
                id: listView
                anchors.bottomMargin: 89
                anchors.topMargin: 128
                flickDeceleration: 1494
                //visible: false
                anchors.fill: parent
                model: showerMap.lstModel//searchModel
                //Component.onCompleted: cymBdd.toto();
                delegate: Component {


                    LineSearch{
                        id: titi
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
