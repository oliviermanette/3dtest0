import QtQuick 2.11
import QtQuick.Controls 2.3

Item{
    id: columnOpenSite
    anchors.fill: parent
    property string txtSiteNameOpen: "value"
    property int siteID: 0
    property int txtSizeX: 0
    property int txtSizeY: 0
    property int intScale: 0
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


    Item {
        id: editSiteSize
        x: 8
        y: 60
        width: 280
        height: 180
        Rectangle {
            id: rectangle
            radius: 8
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#414437"
                }

                GradientStop {
                    position: 1
                    color: "#a6afb5"
                }
            }
            border.width: 0
            anchors.fill: parent

            TextField {
                id: txtEdtSiteScale
                x: 145
                y: 47
                width: 99
                height: 24
                text: intScale
                placeholderText: "scale"
            }

            TextField {
                id: txtEdtSiteColumns
                x: 146
                y: 80
                width: 99
                height: 24
                text: txtSizeX
                placeholderText: "X"
            }

            TextField {
                id: txtEdtSiteRows
                x: 145
                y: 112
                width: 99
                height: 24
                text: txtSizeY
                placeholderText: "Y"
            }

            Button {
                id: btnUpdateSiteSize
                x: 145
                y: 144
                width: 100
                height: 26
                text: qsTr("Update")
                flat: true
                font.capitalization: Font.AllUppercase
                font.bold: true
                font.pointSize: 16
                onClicked: {
                    cymBdd.setSiteSize(siteID, txtEdtSiteColumns.text, txtEdtSiteRows.text, txtEdtSiteScale.text);
                    txtSizeX = cymBdd.getSiteSizeX(siteID);
                    txtSizeY = cymBdd.getSiteSizeY(siteID);
                    intScale = cymBdd.getSiteScale(siteID);
                }
            }

            Text {
                id: text1
                x: 42
                y: 47
                text: qsTr("Scale (m) :")
                font.pixelSize: 17
            }

            Text {
                id: text2
                x: 49
                y: 80
                text: qsTr("Columns :")
                font.pixelSize: 17
            }

            Text {
                id: text3
                x: 76
                y: 112
                text: qsTr("Rows :")
                font.pixelSize: 17
            }

            Text {
                id: text4
                x: 8
                y: 8
                color: "#dadfb7"
                text: qsTr("Size of Site")
                font.family: "Verdana"
                font.bold: false
                font.pixelSize: 18
            }
        }

    }

}




/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:7;anchors_x:0}
}
 ##^##*/
