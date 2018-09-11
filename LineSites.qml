import QtQuick 2.11
import QtPositioning 5.8
import QtQuick.Controls 2.2
//import QtQml 2.11

Item {

    width: parent.width - 0.02*parent.width
    height:lstRectangle.height + chListStruct.height
    function showDetailSite()
    {
        editSites.siteName = siteName;
        editSites.siteDescription = siteDescription;
        editSites.siteLatitude = SiteLatitude;
        editSites.siteLongitude = SiteLongitude;
        editSites.siteID = siteID;
        editSites.btnUpdate = "Update";
    }
    Column{

        anchors.fill: parent
        Rectangle{
            id:lstRectangle
            anchors{
                left: parent.left
                right: parent.right
            }
            height: 38
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
                                edtSiteSize.visible = false;
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
                        signal siteOpened(int site);
                        flat: true
                        onClicked: {
                            cymBdd.pleaseEmitSiteOpened(siteID);
                            editSites.visible = true;
                            editStruct1.visible = false;
                            showerMap.mapCenter = QtPositioning.coordinate(SiteLatitude, SiteLongitude);
                            showDetailSite();
                            zoomInAnimation.start();
                            siteOpen1.txtSiteNameOpen = siteName
                            siteOpen1.txtSizeX = cymBdd.getSiteSizeX(siteID);
                            siteOpen1.txtSizeY = cymBdd.getSiteSizeY(siteID);
                            siteOpen1.intScale = cymBdd.getSiteScale(siteID);
                            siteOpen1.siteID = siteID;
                            console.log(siteID);

                            edtSiteSize.visible = true;
                            edtSiteSize.intScale = siteOpen1.intScale
                            edtSiteSize.intSizeX = siteOpen1.txtSizeX
                            edtSiteSize.intSizeY = siteOpen1.txtSizeY
                            edtSiteSize.siteID = siteID
                        }
                        Connections {
                            target: cymBdd
                            onSiteOpened: {
                                //console.log(lintSiteID);
                                //console.log("ouvert le signal onSiteOpened", lintSiteID);
                                if (lintSiteID==siteID){
                                    chListStruct.model = structModel;//structModel;
                                    var lintNbStructures = cymBdd.getNbStructures();
                                    var lclChaine = {"sTypeID": 0, "name":"Pizza", "posX":0, "posY":0, "siteID":0, "structID":0};
                                    structModel.clear();
                                    for (var i=0;i<lintNbStructures;i++){
                                        lclChaine.sTypeID = cymBdd.getStructureStypeID(i);
                                        lclChaine.name = cymBdd.getStructureName(i);
                                        lclChaine.posX = cymBdd.getStructurePosX(i);
                                        lclChaine.posY = cymBdd.getStructurePosY(i);
                                        lclChaine.structID = cymBdd.getStructureID(i);
                                        lclChaine.siteID = cymBdd.getStructureSiteID(i);
                                        structModel.append(lclChaine);
                                    }
                                }
                                else
                                    chListStruct.model = 0;
                            }
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
        ListViewStruct{
            boundsBehavior: Flickable.StopAtBounds
            height: 30 * chListStruct.count + spacing * chListStruct.count
            id: chListStruct
            anchors.left: parent.left
            anchors.right: parent.right
            //model: chListStruct.model//rootDelegate.ListView.view.model.getChildModel(index)
        }
    }



}

/*##^## Designer {
    D{i:9;anchors_height:40;anchors_width:334}
}
 ##^##*/
