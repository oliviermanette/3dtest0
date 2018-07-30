import QtQuick 2.0
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
                coordinate: QtPositioning.coordinate(48.856614, 2.3522219)
            }

            Plugin {
                id: myPlugin
                name: "osm"
                //specify plugin parameters as necessary
                //PluginParameter {...}
                //PluginParameter {...}
                //...
            }

            ListModel {
                    id: fruitModel
                    property string language: "en"
                    ListElement {
                        name: "Apple"
                        cost: 2.45
                        refLat:45
                        refLong:2.3
                    }
                    ListElement {
                        name: "Orange"
                        cost: 3.25
                        refLat:46.5
                        refLong:2.4
                        //pos: QtPositioning.coordinate(, 2.4)
                    }
                    ListElement {
                        name: "Banana"
                        cost: 1.95
                        refLat:49
                        refLong:2.5
                        //pos: QtPositioning.coordinate(49, 2.5)
                    }
                }

            PlaceSearchModel {
                id: searchModel

                plugin: myPlugin
                searchTerm: "pizza"
                searchArea: QtPositioning.circle(startLocation);
                Component.onCompleted: update()
            }
            MapQuickItem {
                id: marker
                anchorPoint.x: image.width/2
                anchorPoint.y: image.height

                sourceItem: Image {
                    id: image
                    source: "marker.png";
                }
            }

            Map {
                id: map
                anchors.fill: parent
                plugin: myPlugin;
                center: QtPositioning.coordinate(48.856614, 2.3522219)
                zoomLevel: 13

                MouseArea {
                    id: selectSiteMouseArea
                    anchors.fill: parent
                    hoverEnabled: false

                    onClicked: {
                        map.center = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                        marker.coordinate = map.center;
                        map.addMapItem(marker);
                    }
                }
 // Permet d'ajouter des marqueurs aux endroits choisis, ça va m'être utile pour visualiser les différents sites.
                Component {
                        id: circleDelegate
                        MapCircle {
                            radius: 3000
                            color: "green"
                            center {
                                latitude: refLat
                                longitude: refLong
                            }
                        }
                    }
                MapItemView {
                    model: fruitModel
                    delegate: circleDelegate/*MapQuickItem {
                        coordinate: pos

                        anchorPoint.x: image.width * 0.5
                        anchorPoint.y: image.height

                        sourceItem: Column {
                            Image { id: image; source: "marker.png";}
                            Text { text: name; font.bold: true }
                        }
                    }//*/
                }//*/
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

