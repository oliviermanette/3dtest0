import QtQuick 2.11
import QtQuick.Controls 2.4
/*
Le site on le récupère par le siteID
    * Ensuite faut rentrer le nom
    * Choisir le fichier
        :=> s'affiche sous la forme d'un bouton ...
        :=> derrière ouvre un popup avec un nom, la description, l'upload du fichier stl et l'upload du fichier png (image)
    * La position de référence intPosX, intPosY
    * Le type, qu'on récupère dans la liste à droite
        :=> Donc on n'affiche pas en popup
        :=> On l'affiche à la place de la grille

*/
Rectangle{
    property int siteID: 0
    property int intPosX: 0
    property int intPosY: 0
    property double ldblWidthRatio: 0.4
    property int intTxtFldHeight: 25
    property string strSelectedSType: " Select Type "
    color: "#eeeef7"
    //anchors.fill: parent
    radius: 4
    Column {
        width: parent.width
        height: parent.height
        padding: 7
        spacing: 15
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: name
                text: qsTr("Add new Structure to site")
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
                width: ldblWidthRatio* parent.width
            }
            TextField{
                id:txtStructName
                width: ldblWidthRatio* parent.width + 2* parent.spacing
                height: intTxtFldHeight
            }
        }
        Column{
            width: parent.width- 2* parent.padding
            spacing: 2
            padding: 5
            Row{
                width: parent.width
                spacing: 4
                Text {
                    id: name3
                    text: qsTr("Position :")
                    font.pointSize: 16
                    font.bold: true
                    width: ldblWidthRatio* parent.width
                }
            }
            Row{
                width: parent.width
                spacing: 4
                Text {
                    id: name4
                    text: qsTr("X :")
                    horizontalAlignment: Text.AlignRight
                    font.bold: true
                    width: ldblWidthRatio* parent.width*0.5
                }
                TextField{
                    id:txtStructXPos
                    width: ldblWidthRatio* parent.width*0.5
                    height: intTxtFldHeight
                    text:Number(intPosX)
                }
                Text {
                    id: name5
                    text: qsTr("Y :")
                    horizontalAlignment: Text.AlignRight
                    font.bold: true
                    width: ldblWidthRatio* parent.width*0.5
                }
                TextField{
                    id:txtStructYPos
                    width: ldblWidthRatio* parent.width*0.5
                    height: intTxtFldHeight
                    text:Number(intPosY)
                }
            }
        }
        Column{
            width: parent.width- 2* parent.padding
            spacing: 2
            padding: 5
            Row{
                width: parent.width
                spacing: 4
                Text {
                    id: name6
                    text: qsTr("Type :")
                    font.pointSize: 16
                    font.bold: true
                    width: ldblWidthRatio* parent.width
                }
            }
            Row{
                width: parent.width - 2* parent.padding
                spacing: 8
                Button{
                    flat: true
                    id:btnNewStructType
                    text: " New "
                    font.underline: true
                    font.family: "Tahoma"
                    font.capitalization: Font.MixedCase
                    font.bold: false
                    width: ldblWidthRatio* parent.width
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: btnNewStructType.font.bold = true;
                        onExited: btnNewStructType.font.bold = false;
                        onClicked: {

                            formNewType.visible  = true
                            animNewType.start();
                        }

                    }
                }
                Button{
                    id:btnSelectStructType
                    flat: true
                    text: strSelectedSType
                    font.underline: true
                    font.capitalization: Font.MixedCase
                    font.bold: false
                    width: ldblWidthRatio* parent.width
                    onTextChanged: font.bold=true;
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: btnSelectStructType.font.bold = true;
                        onExited: btnSelectStructType.font.bold = false;
                        onClicked: {
                            cymBdd.updateSType();
                            var lintNbSites = cymBdd.getNbSTypes();
                            console.log(lintNbSites);
                            var lclChaine = {"sTypeID": 1, "name":"Pizza", "description":"My Description"};
                            sTypeModel.clear();
                            for (var i=0;i<lintNbSites;i++){
                                lclChaine.sTypeID = 1;
                                lclChaine.name = cymBdd.getSTypeName(i);
                                lclChaine.description = cymBdd.getSTypeDescription(i);
                                sTypeModel.append(lclChaine);
                            }
                            listViewSType.model = sTypeModel;
                            listView.visible = false//sTypeModel;
                            listViewSType.visible = true

                        }
                    }
                }
            }
        }
        Row{
            layoutDirection: Qt.LeftToRight
            spacing: 0.25*parent.width
            padding: 5
            Button{
                id:btnCanNewStruc
                text: "Cancel"
                height: intTxtFldHeight
                onClicked: {
                    formNewStruct.visible=false;
                    gridSite.visible = true;
                }
            }
            Button{
                id:btnAddNewStruc
                text: "Add"
                font.pointSize: 14
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
                font.bold: true
                height: intTxtFldHeight
                onClicked: {
                    if (cymBdd.addNewStruct(txtStructName.text, txtStructXPos.text, txtStructYPos.text, strSelectedSType, siteID)){
                        formNewStruct.visible = false
                        gridSite.visible = true;
                        // TODO : Mettre à jour la liste des structures pour l'afficher dans la grille
                    }
                    else
                        name.text = "ERROR";
                }
            }
        }
    }
}


