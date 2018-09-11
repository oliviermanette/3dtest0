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
            color: "#ee0606"
            border.color: "black"
            //image.height + label.paintedHeight
            Row{
                anchors.fill: parent
                Image {
                    id: imgSType
                    source: "file://"+getPath()+"/structuretypes/icon/"+sTypeID
                    height: parent.height - 2* parent.padding
                    width: height


                }
                Text {
                    id: lblName
                    text: qsTr(name)
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                   //
                }
            }
        }
    }
}
