import QtQuick 2.11
import QtQuick.Controls 2.2

Item {
    TextField {
        id: txtFldSiteSearch
        x: 281
        y: 0
        width: 238
        height: 23
        placeholderText: qsTr("Filter sites")
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
    }
    Button {
        id: btnSearchSite
        x: 252
        y: 8
        width: 90
        flat: true
        height: 25
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
                    lclChaine.SiteLatitude = cymBdd.getSiteLatitude(i);
                    lclChaine.SiteLongitude = cymBdd.getSiteLongitude(i);
                    lclChaine.siteDescription = cymBdd.getSiteDescription(i);
                    siteModel.append(lclChaine);
                }
            }
        }
    }
}
