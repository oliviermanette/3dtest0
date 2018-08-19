import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Controls 1.4
import QtPositioning 5.8

Item {
    //property alias popAddNewSite: popAddNewSite
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
                text: qsTr("Filter sites")
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
                height: 618
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
                    console.log('started here ! Thanks !');
                    var lclChaine = {"siteIntegrity": 5.95, "siteName":"Pizza", "SiteLatitude":48, "SiteLongitude":1.5};
                    var lintNbSites = cymBdd.getNbSites();
                    console.log(lintNbSites);
                    for (var i=0;i<lintNbSites;i++){
                        lclChaine.siteIntegrity = "100%";
                        lclChaine.siteName = cymBdd.getSiteName(i);//"Hambourg";
                        lclChaine.SiteLatitude = cymBdd.getSiteLatitude(i);
                        lclChaine.SiteLongitude = cymBdd.getSiteLongitude(i);
                        siteModel.append(lclChaine);
                    }
                }

                onClicked: {
                    console.log(index);
                    console.log(currentIndex.row);
                    console.log(currentIndex.column);
                    console.log(siteModel.get(currentIndex.row).SiteLatitude);
                    console.log(siteModel.get(currentIndex.row).SiteLongitude);/**/
                    showerMap.mapCenter = QtPositioning.coordinate(siteModel.get(currentIndex.row).SiteLatitude, siteModel.get(currentIndex.row).SiteLongitude);
                    //showerMap.update();
                    //const QModelIndex = index;

                }
            }


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


        }

        Rectangle{
            id: mapArea
            width: 600
            height: 700
            color: "#998f8f"

            MapShow{
                id:showerMap
                anchors.topMargin: 34
                anchors.fill: parent
            }

            TextField {
                id: searchTextField
                width: 492
                height: 33
                text: qsTr("Search Place")

                MouseArea {
                    id: mouseArea
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
                isDefault: true
                activeFocusOnPress: true

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
            color: "#ffffff"

            ListView {
                id: listView
                flickDeceleration: 1494
                anchors.fill: parent
                model: showerMap.lstModel//searchModel
                delegate: Component {

                    Row {
                        spacing: 12
                        Column{
                            Rectangle{ id:kelkonk;height: 10;width: 10;}
                            Image {
                                id: name
                                source: "map-marker.png"
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        searchTitle.color="red";
                                        //console.log(place.location.coordinate);
                                        showerMap.mapCenter = place.location.coordinate;
                                    }
                                }
                            }
                        }
                        Column{
                            id:clnSearchedPlace
                            spacing: 5

                            Text{text:"   ";height: 10;}
                            Text { id:searchTitle;text: title; font.pointSize: 16; font.bold: true ; verticalAlignment: Text.AlignBottom;}
                            Text { text: place.location.address.text ;anchors.right: parent.right;verticalAlignment: Text.AlignTop;anchors.rightMargin: 0; anchors.left: parent.left;anchors.leftMargin: 0}

                        }

                    }
                }
            }

        }

    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:28;anchors_x:281;anchors_y:0}
}
 ##^##*/
