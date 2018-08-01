import QtQuick 2.0

/*Item {
    Component {*/
Row {
    spacing: 55

    Column{
        id: column
        spacing: 5

        Rectangle {
            id: rectangle
            height: 200
            color: "#ffffff"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            Text { x: 0; y: 46; height: 100; text: place.location.address.text ;

                anchors.right: parent.right; anchors.rightMargin: 0; anchors.left: parent.left;anchors.leftMargin: 0 }

            Text { x: 0; y: 0; width: 200; height: 40; text: title; verticalAlignment: Text.AlignBottom; font.pointSize: 17; font.bold: true }

        }
    }
}
/*                    }

}*/
