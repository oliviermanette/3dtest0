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
        width:600
        height: 320
        focus: true

        onInitializeGL: {
            cymBdd.addNewSite("Reims", 51.1, 1.2, "QString strCommentaire");
            GLCode.initializeGL(canvas3d);
        }

        onPaintGL: {
            GLCode.paintGL(canvas3d);
        }

        onResizeGL: {
            GLCode.resizeGL(canvas3d);
        }
    }
}
