import QtQuick 2.0
import QtQuick.Controls 2.3


Item {
    property int intSizeX: 0
    property int intSizeY: 0
    property int intScale: 0
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
            text: intSizeX
            placeholderText: "X"
        }

        TextField {
            id: txtEdtSiteRows
            x: 145
            y: 112
            width: 99
            height: 24
            text: intSizeY
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
            font.underline: true
            font.family: "Verdana"
            font.bold: false
            font.pixelSize: 19
        }
    }

}
