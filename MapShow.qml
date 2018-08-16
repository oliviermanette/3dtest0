import QtQuick 2.0
import QtLocation 5.11
import QtPositioning 5.8

Item {

    property string strSearchField: ""
    property var lstModel: searchModel//siteModel
    property var mapCenter: QtPositioning.coordinate(48.856614, 2.3522219)

    Location {
        id:startLocation
        coordinate: QtPositioning.coordinate(48.856614, 2.3522219)
    }

    Plugin {
        id: myPlugin
        name: "osm"
    }

    PlaceSearchModel {
        id: searchModel
        plugin: myPlugin

        searchTerm: strSearchField
        //searchArea: QtPositioning.circle(startLocation);
        Component.onCompleted: {
            update();
            map.update();

        }
        onSearchTermChanged: {
            update();
            map.update();

        }
        onStatusChanged: {
            if (searchModel.count>0){


                //console.log(PlaceSearchModel.Plac);//searchModel.count);
            }
        }

    }
    MapQuickItem {
        id: marker
        anchorPoint.x: image.width/2
        anchorPoint.y: image.height
        sourceItem:
            Image {
            id: image
            source: "marker.png";
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: myPlugin;
        center: mapCenter//QtPositioning.coordinate(48.856614, 2.3522219)
        zoomLevel: 13

        MouseArea {
            id: selectSiteMouseArea
            anchors.fill: parent
            hoverEnabled: false

            onClicked: {
                //map.center = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                marker.coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y));// map.center;
                map.addMapItem(marker);
                winAddNewSite.dblLongitude = map.toCoordinate(Qt.point(mouse.x, mouse.y)).longitude;
                winAddNewSite.dblLatitude = map.toCoordinate(Qt.point(mouse.x, mouse.y)).latitude;
                popup.open();
            }
        }
         // Permet d'ajouter des marqueurs aux endroits choisis, ça va m'être utile pour visualiser les différents sites.
        Component {
            id: searchDelegate

            MapQuickItem {
                id: marker
                anchorPoint.x: image.width/2
                anchorPoint.y: image.height
                visible : true
                //coordinate:QtPositioning.coordinate(SiteLatitude, SiteLongitude)
                coordinate: place.location.coordinate

                sourceItem: Image {
                    id: image
                    source: "map-marker.png";
                }
            }
        }
        Component {
            id: sitesDelegate
            MapQuickItem {
                id: siteShowMarkers
                anchorPoint.x: imageSite.width/2
                anchorPoint.y: imageSite.height
                visible : true
                coordinate:QtPositioning.coordinate(SiteLatitude, SiteLongitude)
                //coordinate: place.location.coordinate

                sourceItem:     Image {
                    id: imageSite
                    source: "marker128.png";
                    Text {
                        id: name
                        color: "#0c1593"
                        text: siteName
                        font.bold: true
                        lineHeight: 1.6
                        font.pointSize: 30
                        horizontalAlignment: Text.AlignHCenter
                        anchors.rightMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 128
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -19
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.top: parent.top
                    }
                }
            }
        }
        MapItemView {
            id:showOnMap
            model: lstModel
            delegate: searchDelegate
        }
        MapItemView {
            id:showSitesOnMap
            model: siteModel
            delegate: sitesDelegate
        }
    }
}
