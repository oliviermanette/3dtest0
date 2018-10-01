import QtQuick 2.11
import QtQuick.Scene3D 2.0

import Qt3D.Core 2.0
import Qt3D.Extras 2.0
import Qt3D.Input 2.0
import Qt3D.Render 2.0
import Qt3D.Logic 2.0

Rectangle{
    id: scene
    property string strFilename: "value"
    property int intPosX: 300
    property int intTorX: 300
    property var extSensors: maxCount
    property var extRotate: rotateShow
    ListModel{
        id:maxCount
    }
    width: 500
    height: 500
    color: "#e1eef3"
    radius: 4
    border.color: "#2e2e3a"
    border.width: 1
        Scene3D {
            id: sceneHandler
            function getPath()
            {
                var strPath = cymBdd.getLocalPath();
                console.log("file://"+strPath+"/structuretypes/stl/1");
                return strPath;

            }
            anchors.fill: parent
            anchors.margins: 10
            focus: true

            Entity {
                id: sceneRoot
                Camera {
                    id: camera
                    projectionType: CameraLens.PerspectiveProjection
                    fieldOfView: 100
                    nearPlane : 0.1
                    farPlane : 3000.0
                    position: Qt.vector3d( 500.0, 500.0, intPosX )
                    upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                    viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )

                }
                FirstPersonCameraController { camera: camera }

                components: [
                    RenderSettings {
                        activeFrameGraph: ForwardRenderer {
                            camera: camera
                            clearColor: "transparent"
                        }
                    },
                    InputSettings { }

                ]

                Mesh {
                    id: stlMesh
                    source: strFilename
                    objectName: "skeletonStruct"
                }

                Transform {
                    id: stlTransform
                    property real defaultStartAngle: -45
                    property real progressAngle: defaultStartAngle
                    rotationY: progressAngle
                }

                NumberAnimation {
                    id:rotateShow
                    target: stlTransform
                    property: "progressAngle"
                    duration: 10000
                    from: 0
                    to: 360
                    loops: 1
                    running: true
                }

                Entity {
                    property Material progressMaterial: PhongMaterial {
                        ambient: "#f9f9e5"
                        diffuse: "white"
                    }

                    components: [stlMesh, progressMaterial, stlTransform]
                }

                NodeInstantiator {
                        id: collection
                        model: maxCount
                        delegate: CapteurP{
                            id: monCapteur
                        }
                }


            }
        }
}
