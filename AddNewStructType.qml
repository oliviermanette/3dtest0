import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
/*
Icone
fichier stl ==> pas dans la base de données
nom
description
  */


Rectangle {
    Popup{
        id:popopop
        StlShow{
            strFilename: lstrSTLFile
        }
    }
    function getPath()
    {
        return cymBdd.getLocalPath();
    }
    color: "#eeeef7"
    radius: 4
    property double ldblWidthRatio: 0.4
    property int intTxtFldHeight: 25
    property string lstrIconFile: "value"
    property string lstrSTLFile: "value"
    property bool lblIconOrSTL: false
    Column{
        FileDialog{
            id: fileDialog
                title: "Please choose a file"
                //nameFilters: [ "Image files (*.jpg *.png)"]
                folder: shortcuts.home
                onAccepted: {
                    if (lblIconOrSTL){
                        //STL Selected
                        lstrSTLFile = fileDialog.fileUrl.toString();
                        //lstrSTLFile = lstrSTLFile.replace("file://","");
                        lbl3D.text = cymBdd.fileNameFromPath(lstrSTLFile.replace("file://",""));
                        lbl3D.font.underline = true;
                        lbl3D.color = "blue";
                        mouseASTL.visible = true;

                    }
                    else{
                        //Icon selected
                        lstrIconFile = fileDialog.fileUrl.toString();
                        imgIconType.source = lstrIconFile;
                        lstrIconFile = lstrIconFile.replace("file://","");
                        lblIcon.text = cymBdd.fileNameFromPath(lstrIconFile);
                    }
                }
                onRejected: {
                    console.log("Canceled")
                }
        }
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
                id:txtTitle
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
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            lblIconOrSTL = false;
                            fileDialog.open();
                        }
                    }

                }


            }


            Column{
                Label {
                    id: lbl3D
                    text: qsTr("Select 3D File")

                    MouseArea{
                        id:mouseASTL
                        anchors.fill: parent
                        visible: false
                        onClicked: popopop.open()
                    }
                }
                Image {
                    id: imgStl
                    source: "img/stl.png"
                    width: 100
                    height: 100
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            lblIconOrSTL = true;
                            fileDialog.open();
                        }
                    }
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
                onClicked: {
                    var lvrID = cymBdd.addNewStructType(txtTypeName.text, txtTypeDesc.text);
                    if (lvrID>0){
                        cymBdd.sendFileToCloud(lstrIconFile, "structuretypes/icon", lvrID);
                        cymBdd.sendFileToCloud(lstrSTLFile, "structuretypes/stl", lvrID);
                        formNewStruct.strSelectedSType = txtTypeName.text
                        formNewType.visible  = false;
                        listView.visible = false//sTypeModel;
                        listViewSType.visible = true
                        //listView.delegate
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
                    }
                    else{
                        txtTitle.color="red";
                        txtTitle.text="Error";
                    }
                }
            }
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
