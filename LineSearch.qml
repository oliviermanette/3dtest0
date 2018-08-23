import QtQuick 2.11

Item {
    width: 280
    height: 83
    Row{
        anchors.fill: parent
        spacing: 12
        Rectangle {
            id: rectangle
            width: 280
            height: 83
            //color: "#a8d4ff"
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
            radius: 8

            Column{
                y: 0
                anchors.left: parent.left
                anchors.leftMargin: 4
                Rectangle{ id:kelkonk;height: 10; color: "transparent";width: 10;}
                Image {
                    id: name
                    source: "map-marker.png"
                    MouseArea{
                        width: 264
                        height: 67
                        anchors.rightMargin: -198
                        anchors.fill: parent
                        onClicked: {
                            searchTitle.color="red";
                            //console.log(place.location.coordinate);
                            showerMap.mapCenter = place.location.coordinate;
                        }
                        onPressed: {
                            rectangle.color = "yellow"
                        }
                        onReleased: {
                            rectangle.color = "d0d1e6"
                        }
                    }
                }
            }
        }
        Column{
            id:clnSearchedPlace
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.left: parent.left
            anchors.leftMargin: 75
            spacing: 5
            Text{text:"   ";height: 10;}
            Text { id:searchTitle;text: title; font.pointSize: 16; font.bold: true ; verticalAlignment: Text.AlignBottom;}
            Text { text: place.location.address.text ;anchors.right: parent.right;verticalAlignment: Text.AlignTop;anchors.rightMargin: 0; anchors.left: parent.left;anchors.leftMargin: 0}
        }
    }
}


