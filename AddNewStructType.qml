import QtQuick 2.11
import QtQuick.Controls 2.4
/*
Icone
fichier stl ==> pas dans la base de données
nom
description
  */

Rectangle {
    color: "#eeeef7"
    radius: 4
    property double ldblWidthRatio: 0.4
    property int intTxtFldHeight: 25
    Column{
        id:clnNewType
        width: parent.width
        height: parent.height
        padding: 7
        spacing: 15
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            //width: parent.width - 2* parent.padding
            Text{
                text:"Add New Type"
                font.pointSize: 18
                font.underline: true
                font.bold: true
            }
        }
        Row{
            width: parent.width- 2* parent.padding
            spacing: 4
            padding: 5
            Text {
                id: name2
                text: qsTr("Name :")
                font.bold: true
                width: 0.5 * ldblWidthRatio* parent.width
            }
            TextField{
                id:txtTypeName
                width: 1.5*ldblWidthRatio* parent.width + 2* parent.spacing
                height: intTxtFldHeight
                placeholderText: "Enter a clear name for the type"
            }
        }
        Row{
            width: parent.width- 2* parent.padding
            spacing: 4
            padding: 5
            Text {
                id: name
                text: qsTr("Description :")
                font.bold: true
                width: 0.5*ldblWidthRatio* parent.width
            }
            Rectangle{
                width: 1.5*ldblWidthRatio* parent.width + 2* parent.spacing
                height: intTxtFldHeight * 5
                color: "white"
                //background: "black"
                radius: 3
                TextArea{
                    id:txtTypeDesc
                    placeholderText: "Describe clearly the type of structure"
                    wrapMode: Text.WordWrap
                    anchors.fill: parent

                }
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12
            padding: 2
            Column{
                Label {
                    id: lblIcon
                    text: qsTr("Select Icon File")
                }
                Image {
                    id: imgIconType
                    source: "img/png.png"
                    //scale: 1
                    width: 100
                    height: 100
                }
            }
            Column{
                Label {
                    id: lbl3D
                    text: qsTr("Select 3D File")
                }
                Image {
                    id: imgStl
                    source: "img/stl.png"
                    width: 100
                    height: 100
                }
            }
        }
        Row{
            anchors.right: parent.right
            spacing: 15
            padding: 15
            Button{
                id:btnCanNewType
                text: "Cancel"
                height: intTxtFldHeight
                onClicked: {
                    formNewType.visible  =false;
                    //gridSite.visible = true;
                }
            }
            Button{
                id:btnAddNewType
                text: "Add"
                font.pointSize: 14
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
                font.bold: true
                height: intTxtFldHeight
            }
        }
    }


}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
