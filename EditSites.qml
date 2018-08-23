import QtQuick 2.0
import QtQuick.Controls 2.3

Item {
    property string siteName: ""
    property string siteDescription: ""
    property double siteLatitude: 0
    property double siteLongitude: 0
    width: 334
    height: 296
    Rectangle {
        id: rectangle
        radius: 8
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#33333f"
            }

            GradientStop {
                position: 1
                color: "#515160"
            }
        }
        border.width: 0
        anchors.fill: parent

        Text {
            id: text1
            x: 8
            y: 8
            color: "#f8f9f4"
            text: qsTr("Sites")
            font.bold: true
            font.pixelSize: 18
        }

        Text {
            id: text2
            x: 19
            y: 40
            color: "#f8f9f4"
            text: qsTr("Name")
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 16
        }

        TextField {
            id: txtEdtSiteName
            x: 69
            y: 36
            width: 257
            height: 26
            text: qsTr(siteName)
            placeholderText: "Name"
        }

        Text {
            id: text3
            x: 19
            y: 67
            color: "#f8f9f4"
            text: qsTr("Description")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignRight
        }

        TextArea {
            id: txtEdtSitesDescription
            x: 19
            y: 92
            width: 307
            height: 116
            text: qsTr(siteDescription)
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            background: Rectangle { color: "#f7f7dd"
            radius: 3}
        }

        Text {
            id: text4
            x: 19
            y: 221
            color: "#f8f9f4"
            text: qsTr("Long.")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignRight
        }

        TextField {
            id: txtEdtSiteLongitude
            x: 69
            y: 218
            width: 106
            height: 26
            text: Number(siteLongitude).toString()
            placeholderText: "Longitude"
        }

        Text {
            id: text5
            x: 19
            y: 258
            color: "#f8f9f4"
            text: qsTr("Lat.")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignRight
        }

        TextField {
            id: txtEdtSiteLatitude
            x: 69
            y: 255
            width: 106
            height: 26
            text: Number(siteLatitude).toString()
            placeholderText: "Latitude"
        }

        Button {
            id: btnEdtSitesCancel
            x: 221
            y: 218
            width: 105
            height: 26
            text: qsTr("Cancel")
            font.capitalization: Font.MixedCase
        }

        Button {
            id: btnEdtSitesUpdate
            x: 221
            y: 255
            width: 105
            height: 26
            text: qsTr("Update")
            font.capitalization: Font.AllUppercase
            font.bold: true
        }
    }

}

/*##^## Designer {
    D{i:1;anchors_height:200;anchors_width:200;anchors_x:82;anchors_y:80}
}
 ##^##*/
