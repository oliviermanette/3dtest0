import QtQuick 2.0
import QtQuick.Window 2.3
import QtQuick.Scene3D 2.0

import Qt3D.Core 2.0
import Qt3D.Extras 2.0
import Qt3D.Input 2.0
import Qt3D.Render 2.0

Item {
    Rectangle {
        id: scene
        anchors.fill: parent
        anchors.margins: 50
        color: "darkRed"

        transform: Rotation {
            id: sceneRotation
            axis.x: 1
            axis.y: 0
            axis.z: 0
            origin.x: scene.width / 2
            origin.y: scene.height / 2
        }
    Scene3D {
        anchors.fill: parent
        anchors.margins: 10
        focus: true
        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

        Entity {
            id: sceneRoot
           /* Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                aspectRatio: 1820 / 1080
                nearPlane: 0.1
                farPlane: 1000.0
                position: Qt.vector3d(0.014, 0.956, 2.178)
                upVector: Qt.vector3d(0.0, 1.0, 0.0)
                viewCenter: Qt.vector3d(0.0, 0.7, 0.0)
            }*/
            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                nearPlane : 0.1
                farPlane : 1000.0
                position: Qt.vector3d( 0.0, 0.0, 40.0 )
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
            PhongMaterial {
                id: material
            }

            SphereMesh {
                id: sphereMesh
                radius: 3
            }

            Transform {
                id: sphereTransform
                property real userAngle: 0.0
                matrix: {
                    var m = Qt.matrix4x4();
                    m.rotate(userAngle, Qt.vector3d(0, 1, 0))
                    m.translate(Qt.vector3d(20, 0, 0));
                    return m;
                }
            }

            NumberAnimation {
                target: sphereTransform
                property: "userAngle"
                duration: 10000
                from: 0
                to: 360

                loops: Animation.Infinite
                running: true
            }

            Entity {
                id: sphereEntity
                components: [ sphereMesh, material, sphereTransform ]
            }


            Mesh {
                id: progressMesh
                source: "https://storage.googleapis.com/cymbalum_files/COSD.stl"
            }
            Transform {
                id: progressTransform
                property real defaultStartAngle: -45
                property real progressAngle: defaultStartAngle
                rotationY: progressAngle
            }

            Entity {
                property Material progressMaterial: PhongMaterial {
                    ambient: "#80C342"
                    diffuse: "black"
                }

                components: [progressMesh, progressMaterial]
            }

        }
    }
}
/*


    Mesh {
        id: progressMesh
        source: "file:///Users/oliviermanette/QtApps/build-qt3D0-5_11_1-Debug/table1.stl"
    }
    Transform {
        id: progressTransform
        property real defaultStartAngle: -90
        property real progressAngle: defaultStartAngle
        rotationY: progressAngle
    }

    Entity {
        property Material progressMaterial: PhongMaterial {
            ambient: "#80C342"
            diffuse: "black"
        }

        components: [progressMesh, progressMaterial]
    }*/
}

