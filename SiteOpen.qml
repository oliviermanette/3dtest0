import QtQuick 2.11

Item{
    id: columnOpenSite
    anchors.fill: parent
    property string txtSiteNameOpen: "value"
    Rectangle{
        Text {
            id: lblSiteNameOpen
            text: qsTr(txtSiteNameOpen)
            anchors.leftMargin: 15
            anchors.topMargin: 30
            anchors.fill: parent
            font.bold: true
            font.underline: true
            color: "#ebeec3"
            font.pointSize: 24
        }
    }
    Grid{
        anchors.topMargin: parent.height/3
        anchors.leftMargin: parent.width/2.5
        anchors.fill: parent
        columns: 3
        transform: [
            Rotation { axis { x: 0; y: 0; z: 1 } angle: 40 },
            Rotation { axis { x: 1; y: 0; z: 0 } angle: 65 }
        ]

        Repeater{
            model: 9
            Rectangle{
                id:rctArea
                width: 75
                height: 75
                color: "#0cea08"
                border.color: "#eceecd"
                border.width: 1
                /*
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: "#50d336";
                    }
                    GradientStop {
                        position: 1.00;
                        color: "#bbee77";
                    }
                }*/
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: rctArea.color="red";
                    onExited: rctArea.color="#0cea08";
                }
            }
        }
    }

}




/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:7;anchors_x:0}
}
 ##^##*/
