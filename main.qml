import QtQuick 2.11
import QtLocation 5.11
import QtPositioning 5.8

Item {
    Row{
        Rectangle{
            width: 350
            height: 700
            color: "#7272e4"
        }
        Rectangle{
            id: mapArea
            width: 600
            height: 700
            color: "#998f8f"
            Location {
                id:startLocation
                coordinate: QtPositioning.coordinate(-27.5, 153.1)
            }

            Plugin {
                id: myPlugin
                name: "osm"
                //specify plugin parameters as necessary
                //PluginParameter {...}
                //PluginParameter {...}
                //...
            }

            PlaceSearchModel {
                id: searchModel

                plugin: myPlugin

                searchTerm: "pizza"
                searchArea: QtPositioning.circle(startLocation);

                Component.onCompleted: update()

            }

            Map {
                id: map
                anchors.fill: parent
                plugin: myPlugin;
                center: QtPositioning.coordinate(-27.5, 153.1)
                zoomLevel: 13

                MapItemView {
                    model: searchModel
                    delegate: MapQuickItem {
                        coordinate: place.location.coordinate

                        anchorPoint.x: image.width * 0.5
                        anchorPoint.y: image.height

                        sourceItem: Column {
                            Image { id: image; source: "marker.png" }
                            Text { text: title; font.bold: true }
                        }
                    }
                }
            }

        }

        Rectangle {
            enabled: false
            visible: false

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

