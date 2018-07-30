import QtQuick 2.0
import QtQuick.Controls 1.6

Item {
    width: 320
    height: 240
    Rectangle {
        id: rectangle
        color: "#5b659b"
        anchors.fill: parent

        Text {
            id: text1
            x: 63
            y: 8
            text: qsTr("Add a new Site")
            font.family: "Tahoma"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 26
        }

        Text {
            id: text2
            x: 8
            y: 49
            text: qsTr("Name : ")
            font.bold: true
            font.pixelSize: 16
        }

        TextField {
            id: txtNewSiteName
            x: 74
            y: 46
            width: 238
            height: 22
            font.bold: true
            font.wordSpacing: 0
            placeholderText: qsTr("Text Field")
        }

        Text {
            id: text3
            x: 8
            y: 74
            text: qsTr("Description : ")
            font.bold: true
            font.pixelSize: 16
        }

        TextArea {
            id: txtNewSiteDescription
            x: 8
            y: 99
            width: 304
            height: 78
            font.wordSpacing: 0
        }

        Button {
            id: btnCancelANSite
            x: 8
            y: 194
            text: qsTr("Cancel")
            tooltip: ""
        }

        Button {
            id: btnOkAddNewSite
            x: 258
            y: 194
            text: qsTr("OK")
            tooltip: "Add a new site"
            isDefault: true
        }
    }

}

/*##^## Designer {
    D{i:1;anchors_height:200;anchors_width:200;anchors_x:18;anchors_y:13}
}
 ##^##*/
