import QtQuick 2.11
import QtQuick.Scene3D 2.0

import Qt3D.Core 2.0
import Qt3D.Extras 2.0
import Qt3D.Input 2.0
import Qt3D.Render 2.0

    Scene3D {
        anchors.fill: parent
        anchors.margins: 10
        focus: true
        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

        Entity {
            id: sceneRoot
            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 60
                nearPlane : 0.1
                farPlane : 1000.0
                position: Qt.vector3d( 0.0, 0.0, 200.0 )
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
                source: "https://storage.googleapis.com/cymbalum_files/table1.stl"
            }
            Transform {
                id: stlTransform
                property real defaultStartAngle: -45
                property real progressAngle: defaultStartAngle
                rotationX: progressAngle
            }

            NumberAnimation {
                target: stlTransform
                property: "progressAngle"
                duration: 10000
                from: 0
                to: 360

                loops: Animation.Infinite
                running: true
            }

            Entity {
                property Material progressMaterial: PhongMaterial {
                    ambient: "#80C342"
                    diffuse: "white"
                }

                components: [stlMesh, progressMaterial, stlTransform]
            }
        }
    }
