import QtQuick 2.11

ListView {
    id: canvas
    function getPath()
    {
        return cymBdd.getLocalPath();
    }
    clip: true
    interactive: false
    //model: sTypeModel
    delegate: Component {
        Rectangle {
            id: rootListItem
            anchors.right: parent.right
            width: canvas.width *0.85;
            height: 30
            color: "#b9a7a7"
            border.color: "#4b4747"
            radius: 3
            //image.height + label.paintedHeight
            Grid{
                anchors.fill: parent
                spacing: 7
                rows:1
                columns: 5
                Image {
                    id: imgSType
                    source: "file://"+getPath()+"/structuretypes/icon/"+sTypeID
                    height: parent.height - 2* parent.padding
                    fillMode: Image.PreserveAspectFit
                    width: height
                }
                Text {
                    id: lblName
                    text: qsTr(name)
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height - 2* parent.padding
                    width: parent.width/4
                }
                Rectangle{
                    width: parent.width/7
                    height: parent.height
                    color: "transparent"
                }
                Rectangle{
                    id:rctLblStructOpen
                    height: parent.height - 2* parent.padding
                    width: lblStructOpen.width
                    visible: false
                    color: "#f9b7b7"
                    border.color: "#4b4747"
                    Text {
                        id: lblStructOpen
                        text: "Open"

                        verticalAlignment: Text.AlignVCenter
                        height: parent.height

                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            lblStructOpen.font.bold = true}

                        onExited: {
                            lblStructOpen.font.bold = false}
                    }
                }


                Image {
                    id: structDeleteIcon
                    source: "img/delete-1-icon.png"
                    height: parent.height - 2* parent.padding
                    fillMode: Image.PreserveAspectFit
                    width: 20//implicitWidth
                    visible:false
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("Going to delete that structure")
                            cymBdd.delStructure(structID);
                            cymBdd.pleaseEmitSiteOpened(siteID);
                        }
                        hoverEnabled: true
                        onEntered: {
                            structDeleteIcon.scale = 1.2}

                        onExited: {
                            structDeleteIcon.scale = 1}
                    }
                }
            }
            Connections{
                target: cymBdd
                onStructOpened:{
                    if (lstrName!=name){
                        rootListItem.color = "#b9a7a7";
                        structDeleteIcon.visible = false;
                        mouseSelectionStruct.visible = true;
                        rctLblStructOpen.visible = false;
                    }
                }
            }

            MouseArea {
                id:mouseSelectionStruct
                anchors.fill: parent
                onClicked: {
                   // ici on fait changer la couleur pour montrer qu'elle est sélectionnée
                    cymBdd.pleaseEmitStructOpened(name);
                    rootListItem.color = "#f9b7b7";
                    structDeleteIcon.visible = true;
                    mouseSelectionStruct.visible = false;
                    rctLblStructOpen.visible = true;
                }
            }
        }
    }
}
