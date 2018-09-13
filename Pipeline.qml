import QtQuick 2.11;
import QtLocation 5.11;
import QtQuick.Controls 2.4

MapPolyline {
    property int index: -1
    property var fctDelete
    line.width: 6;
    line.color: '#273E63';
    MouseArea{
        anchors.fill: parent
        onClicked: {
            contextMenu.popup();
            console.log("Oh ouiiiiiii !",index);
        }

        Menu {
                id: contextMenu
                MenuItem {
                    text: "Delete"
                    onClicked: fctDelete(index);
                }
                MenuItem { text: "Cancel" }
            }
    }
}
