import QtQuick 2.11
import QtQuick.Controls 2.3


Item {
    property int intPosX: 0
    property int intPosY: 0
    property string strStructName: "noname"
    property int siteID: 0
    property int structID: 0
    property int sTypeID: 0
    property string strSelectedSType: "Select Struct."
    property double lblWidthRatio: 0.4
    property double ldblHeight: 24
    width: parent.width-0.02*parent.width
    height: 0.33 * parent.height
    Rectangle {
        id: rectangle
        radius: 8
        border.width: 1
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#f9b7b7"
            }

            GradientStop {
                position: 1
                color: "#b9a7a7"
            }
        }
        Column{
            anchors.fill: parent
            Text {
                padding: 8
                id: textStructTitle
                //color: "#dadfb7"
                text: qsTr("Structure options")
                font.underline: true
                font.family: "Verdana"
                font.bold: false
                font.pixelSize: 19

            }
            Row{
                padding: 8
                spacing: 16
                width: parent.width
                Text {
                    id: text1
                    width: lblWidthRatio * parent.width
                    text: qsTr("Name :")
                    font.pixelSize: 17

                }
                TextField {
                    id: txtEdtStructName
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    text: strStructName
                    placeholderText: "name"
                }
            }
            Row{
                padding: 8
                spacing: 16
                width: parent.width
                Text {
                    id: text2
                    width: lblWidthRatio * parent.width
                    text: qsTr("Pos. Col.# :")
                    font.pixelSize: 17

                }
                TextField {
                    id: txtEdtStrucPosX
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    text: intPosX
                    placeholderText: "X"
                }
            }
            Row{
                padding: 8
                spacing: 16
                width: parent.width
                Text {
                    id: text3
                    text: qsTr("Pos. Row# :")
                    font.pixelSize: 17
                    width: lblWidthRatio * parent.width

                }
                TextField {
                    id: txtEdtStrucPosY
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    text: intPosY
                    placeholderText: "Y"
                }
            }
            Row{
                padding: 8
                spacing: 16
                width: parent.width
                Image {
                    id: imgSType
                    source: "file://"+fctGetPath()+"/structuretypes/icon/"+sTypeID
                    height: parent.height - 2* parent.padding
                    fillMode: Image.PreserveAspectFit
                    width: height
                }
                Connections{
                    target: cymBdd
                    onSTypeSelected:{
                        sTypeID = uinSTypeID;
                        btnSelectStructType.text = strSTypeName;
                    }
                }
                Button{
                    id:btnSelectStructType
                    flat: true
                    text: strSelectedSType
                    font.underline: true
                    font.capitalization: Font.MixedCase
                    font.bold: false
                    width: lblWidthRatio * parent.width
                    onTextChanged: font.bold=true;
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: btnSelectStructType.font.bold = true;
                        onExited: btnSelectStructType.font.bold = false;
                        onClicked: {
                            cymBdd.updateSType();
                            fctUpdateSType();
                            listView.visible = false;
                            listViewSType.visible = true;
                        }
                    }
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
                    id: btnUpdateStruct
                    width: lblWidthRatio * parent.width
                    height: ldblHeight
                    text: qsTr("Update")
                    //flat: true
                    font.capitalization: Font.AllUppercase
                    font.bold: true
                    font.pointSize: 16
                    onClicked: {
                        cymBdd.setUpdateStruct(Number(structID), Number(siteID),Number(txtEdtStrucPosX.text), Number(txtEdtStrucPosY.text), txtEdtStructName.text,sTypeID);
                        cymBdd.pleaseEmitSiteOpened(siteID);
                    }
                }
            }
        }
    }
}
