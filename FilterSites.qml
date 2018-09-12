import QtQuick 2.11
import QtQuick.Controls 2.2

Rectangle{
    id: rectangle
    border.color: "black"
    width: parent.width
    height: 35
    color: "#b0afb9"
    radius: 4
    Row{
        anchors.fill: parent
        spacing: 0.02*parent.width
        padding: 0.01*parent.width
        TextField {
            id: txtFldSiteSearch
            width: 0.68*parent.width
            height: parent.height-0.02*parent.width
            placeholderText: qsTr("Filter sites")
        }
        Button {
            id: btnSearchSite
            width: 0.28*parent.width
            flat: true
            height: parent.height-0.02*parent.width
            text: qsTr("Filter")
            onClicked: {
                if (cymBdd.filterSitesByND(txtFldSiteSearch.text)){
                    fctUpdateSitesList();
                }
            }
        }
    }
}
