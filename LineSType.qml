import QtQuick 2.11

Rectangle{
    id:rectangle
    function getPath()
    {
        return cymBdd.getLocalPath();
    }
    width: parent.width - 0.015*parent.width
    height: 64
    color: "#d0d1e6"
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#d0d1e6";
        }
        GradientStop {
            position: 1.00;
            color: "#ffffff";
        }
    }
    radius: 4
    Row{
        spacing: 12
        padding: 4
        anchors.fill: parent
        Image {
            id: imgSType
            source: "file://"+getPath()+"/structuretypes/icon/"+sTypeID
            height: parent.height - 2* parent.padding
            width: height

        }
        Column{
            id:clnSearchedPlace
            spacing: 5
            Text { id:searchSTypeName;text: name; font.pointSize: 16; font.bold: true ; verticalAlignment: Text.AlignBottom;}
            Text { id:searchSTypeDescr;text: description;}
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            searchSTypeName.color="brown";
            siteOpen1.name.strSelectedSType = name;
            cymBdd.pleaseEmitSTypeSelected(sTypeID,name);

            /*showerMap.mapCenter = place.location.coordinate;
            showerMap.visible = true;
            siteOpen1.visible = false;
            edtSiteSize.visible = false;*/
        }
        hoverEnabled: true
        onEntered: {
            searchSTypeDescr.color="red";
            searchSTypeName.color="red";}

        onExited: {
            searchSTypeDescr.color="black";
            searchSTypeName.color="black";}
    }
}
