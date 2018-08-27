import QtQuick 2.11
import QtQuick.Controls 2.3

Column{
    id: columnOpenSite
    width: parent.width
    height: parent.height
    property string txtSiteNameOpen: "value"
    property int siteID: 0
    property int txtSizeX: 0
    property int txtSizeY: 0
    property int intScale: 0
    property int lintWidth: 0
    function getBestFit()
    {
       /*
         Prend le maximum entre txtSizeX et txtSizeY
         */
        if (txtSizeX>txtSizeY)
            lintWidth = 0.8 * parent.width/txtSizeX;
        else
            lintWidth = 0.8 * parent.width/txtSizeY;
        return lintWidth;
    }

    padding: 10
    spacing: 20

    Text {
        id: lblSiteNameOpen
        text: qsTr(txtSiteNameOpen)
        width: parent.width
        font.bold: true
        font.underline: true
        color: "#ebeec3"
        font.pointSize: 24
    }
    Grid{
        id:gridSite
        columns: txtSizeX
        //anchors.fill: parent
        width: parent.width - 10
        height: 0.8*parent.height

        Repeater{
            model: txtSizeX*txtSizeY
            Rectangle{
                id:rctArea
                width: getBestFit()//4*77/txtSizeY
                height: getBestFit()//4*77/txtSizeY
                //anchors.fill: parent
                color: "#2E3561"
                border.color: "#eceecd"
                border.width: 1
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: rctArea.color="#0cea08";
                    onExited: rctArea.color="#2E3561"//"#0cea08";
                    onClicked: {
                        formNewStruct.intPosY = Math.floor(index/txtSizeX);
                        formNewStruct.intPosX = (index/txtSizeX-Math.floor(index/txtSizeX))*txtSizeX;
                        formNewStruct.visible=true;
                        gridSite.visible = false;
                    }
                }
                Image {
                    id: name
                    //source: "img/73225988_s.jpg"
                    anchors.fill: parent
                }
            }
        }
    }
    AddNewStruct{
        id:formNewStruct
        width: 0.45*parent.width
        height: 0.45*parent.width
        visible: false
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:7;anchors_x:0}
}
 ##^##*/
