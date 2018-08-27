import QtQuick 2.11
import QtQuick.Controls 2.3


Item {
    property int intSizeX: 0
    property int intSizeY: 0
    property int intScale: 0
    property int siteID: 0
    property double lblWidthRatio: 0.4
    property double ldblHeight: 24
    width: parent.width-0.02*parent.width
    height: 0.25 * parent.height
    Rectangle {
        id: rectangle
        radius: 8
        border.width: 0
        anchors.fill: parent
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
        Column{
            anchors.fill: parent
            Text {
                padding: 8
                id: textSizeTitle
                //color: "#dadfb7"
                text: qsTr("Size of Site")
                font.underline: true
                font.family: "Verdana"
                font.bold: false
                font.pixelSize: 19
                color: "#f8f9f4"
            }
            Row{
                padding: 8
                spacing: 16
                width: parent.width
                Text {
                    id: text1
                    width: lblWidthRatio * parent.width
                    text: qsTr("Scale (m) :")
                    font.pixelSize: 17
                    color: "#f8f9f4"
                }
                TextField {
                    id: txtEdtSiteScale
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    text: intScale
                    placeholderText: "scale"
                }
            }
            Row{
                padding: 8
                spacing: 16
                width: parent.width
                Text {
                    id: text2
                    width: lblWidthRatio * parent.width
                    text: qsTr("Columns :")
                    font.pixelSize: 17
                    color: "#f8f9f4"
                }
                TextField {
                    id: txtEdtSiteColumns
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    text: intSizeX
                    placeholderText: "X"
                }
            }
            Row{
                padding: 8
                spacing: 16
                width: parent.width
                Text {
                    id: text3
                    text: qsTr("Rows :")
                    font.pixelSize: 17
                    width: lblWidthRatio * parent.width
                    color: "#f8f9f4"
                }
                TextField {
                    id: txtEdtSiteRows
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    text: intSizeY
                    placeholderText: "Y"
                }
            }
            Row{
                padding: 8
                spacing: 16
                width: parent.width
                Rectangle{
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    color: "transparent"
                }

                Button {
                    id: btnUpdateSiteSize
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    text: qsTr("Update")
                    //flat: true
                    font.capitalization: Font.AllUppercase
                    font.bold: true
                    font.pointSize: 16
                    onClicked: {
                        cymBdd.setSiteSize(siteID, txtEdtSiteColumns.text, txtEdtSiteRows.text, txtEdtSiteScale.text);
                        // Met à jour le graphique :
                        siteOpen1.txtSizeX = cymBdd.getSiteSizeX(siteID);
                        siteOpen1.txtSizeY = cymBdd.getSiteSizeY(siteID);
                        siteOpen1.intScale = cymBdd.getSiteScale(siteID);

                    }
                }

            }


        }

    }

}
