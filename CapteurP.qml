import QtQuick 2.11
import Qt3D.Core 2.0
import Qt3D.Extras 2.0
import Qt3D.Input 2.0
import Qt3D.Render 2.0
import Qt3D.Logic 2.0

Entity {
//    property double dblPosX: 0
//    property double dblPosY: 0
//    property double dblPosZ: 0
    TorusMesh {
        id: torusMesh
        radius: 50
        minorRadius: 20
        rings: 100
        slices: 20
    }
    PhongMaterial {
            id: material
        }
    Transform {
            id: torusTransform
            //scale3D: Qt.vector3d(1.5, 1, 0.5)
            //rotation: fromAxisAndAngle(Qt.vector3d(1, 0, 0), 45)
            translation: Qt.vector3d( sensorPosX, sensorPosY, sensorPosZ );
        }

    components: [ torusMesh, material, torusTransform]
}
