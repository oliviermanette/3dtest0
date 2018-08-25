import QtQuick 2.11

Item{
    id: columnOpenSite
    anchors.fill: parent
    property string txtSiteNameOpen: "value"
    property int siteID: 0
    property int txtSizeX: 0
    property int txtSizeY: 0
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
        anchors.leftMargin: parent.width/2
        anchors.fill: parent
        columns: txtSizeX
        transform: [
            Rotation { axis { x: 0; y: 0; z: 1 } angle: 40 },
            Rotation { axis { x: 1; y: 0; z: 0 } angle: 65 }
        ]

        Repeater{
            model: txtSizeX*txtSizeY
            Rectangle{
                id:rctArea
                width: 4*77/txtSizeY
                height: 4*77/txtSizeY
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
    Text {
        id: name
        text: txtSizeX
        anchors.leftMargin: 30
        anchors.topMargin: 60
        anchors.fill: parent
        color: "#ebeec3"
    }
    Text {
        id: name2
        text: txtSizeY
        anchors.leftMargin: 30
        anchors.topMargin: 90
        anchors.fill: parent
        color: "#ebeec3"
    }

}




/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:7;anchors_x:0}
}
 ##^##*/
