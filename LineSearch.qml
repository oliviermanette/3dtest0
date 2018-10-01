import QtQuick 2.11

Rectangle{
    id:rectangle
    width: parent.width - 0.015*parent.width
    height: 64//0.08*parent.height
    color: "#D1D1D1"
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#D1D1D1";
        }
        GradientStop {
            position: 1.00;
            color: "#B3B3B3";
        }
    }
    radius: 4
    Row{
        spacing: 12
        padding: 4
        anchors.fill: parent
        Image {
            id: name
            source: "map-marker.png"
            height: parent.height - 2* parent.padding
            width: implicitWidth
        }
        Column{
            id:clnSearchedPlace
            spacing: 5
            Text { id:searchTitle;text: title; font.pointSize: 16; font.bold: true ; verticalAlignment: Text.AlignBottom;}
            Text { id:searchAdd;text: place.location.address.text;}
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            searchTitle.color="brown";
            showerMap.mapCenter = place.location.coordinate;
            showerMap.visible = true;
            siteOpen1.visible = false;
            edtSiteSize.visible = false;
        }
        hoverEnabled: true
        onEntered: {
            searchAdd.color="#6EABFF";
            searchTitle.color="#6EABFF";}

        onExited: {
            searchAdd.color="black";
            searchTitle.color="black";}

    }
}



