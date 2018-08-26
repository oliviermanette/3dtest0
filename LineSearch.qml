import QtQuick 2.11

Rectangle{
    id:rectangle
    width: parent.width - 0.015*parent.width
    height: 64//0.08*parent.height
    color: "#d0d1e6"
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#d0d1e6";
        }
        GradientStop {
            position: 1.00;
            color: "#ffffff";
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
        }
        hoverEnabled: true
        onEntered: {
            searchAdd.color="red";
            searchTitle.color="red";}

        onExited: {
            searchAdd.color="black";
            searchTitle.color="black";}

    }
}



