import QtQuick 2.11
import QtQuick.Controls 2.2

Rectangle{
    id: rectangle
    border.color: "black"
    width: parent.width
    height: 35
    color: "#b0afb9"
    radius: 4
    Row{
        anchors.fill: parent
        spacing: 0.02*parent.width
        padding: 0.01*parent.width
        TextField {
            id: txtFldSiteSearch
            width: 0.68*parent.width
            height: parent.height-0.02*parent.width
            placeholderText: qsTr("Filter sites")
        }
        Button {
            id: btnSearchSite
            width: 0.28*parent.width
            flat: true
            height: parent.height-0.02*parent.width
            text: qsTr("Filter")
            onClicked: {
                if (cymBdd.filterSitesByND(txtFldSiteSearch.text)){
                    var lclChaine = {"siteIntegrity": 5.95, "siteName":"Pizza", "SiteLatitude":48, "SiteLongitude":1.5, "siteDescription":"My Description", "siteID":0};
                    var lintNbSites = cymBdd.getNbSites();
                    console.log(lintNbSites);
                    siteModel.clear();
                    for (var i=0;i<lintNbSites;i++){
                        lclChaine.siteIntegrity = "100%";
                        lclChaine.siteName = cymBdd.getSiteName(i);//"Hambourg";
                        lclChaine.siteID = cymBdd.getSiteID(i);
                        lclChaine.SiteLatitude = cymBdd.getSiteLatitude(i);
                        lclChaine.SiteLongitude = cymBdd.getSiteLongitude(i);
                        lclChaine.siteDescription = cymBdd.getSiteDescription(i);
                        siteModel.append(lclChaine);
                    }
                }
            }
        }
    }
}
