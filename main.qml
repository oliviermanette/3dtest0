import QtQuick 2.11

Item {
    Row{
        Rectangle{
            width: 350
            height: 700
            color: "#7272e4"
        }
        Rectangle {
            id: scene
            width: 600
            height: 700
            anchors.margins: 50
            color: "#e1eef3"

            transform: Rotation {
                id: sceneRotation
                axis.x: 1
                axis.y: 0
                axis.z: 0
                origin.x: scene.width / 2
                origin.y: scene.height / 2
            }
            StlShow{

            }
        }
    }
}

