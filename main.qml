import QtQuick 2.4
import QtCanvas3D 1.1
import QtQuick.Window 2.2

import "glcode.js" as GLCode

Window {
    title: qsTr("3dtest0")
    width: 640
    height: 360
    visible: true

    Canvas3D {
        id: canvas3d
        //anchors.fill: parent
        width:parent.width/1.2;
        height: parent.height/1.2;
        focus: true

        onInitializeGL: {
            //cymBdd.addNewSite("Reims", 51.1, 1.2, "QString strCommentaire");
            GLCode.initializeGL(canvas3d);
        }

        onPaintGL: {
            GLCode.paintGL(canvas3d);
        }

        onResizeGL: {
            GLCode.resizeGL(canvas3d);
        }
    }

    PathView {
        id: pathView
        x: 5
        y: 22
        width: 250
        height: 316
        model: ListModel {
            ListElement {
                name: "Grey"
                colorCode: "grey"
            }

            ListElement {
                name: "Red"
                colorCode: "red"
            }

            ListElement {
                name: "Blue"
                colorCode: "blue"
            }

            ListElement {
                name: "Green"
                colorCode: "green"
            }
        }
        path: Path {
            startX: 120
            startY: 100
            PathQuad {
                x: 120
                y: 25
                controlX: 260
                controlY: 75
            }

            PathQuad {
                x: 120
                y: 100
                controlX: -20
                controlY: 75
            }
        }
        delegate: Column {
            Rectangle {
                width: 40
                height: 40
                color: colorCode
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                x: 5
                text: name
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
            }
            spacing: 5
        }
    }
}
