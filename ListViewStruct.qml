import QtQuick 2.11

ListView {
    id: canvas
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
