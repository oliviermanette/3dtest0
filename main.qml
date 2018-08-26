import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtPositioning 5.8

Item {
    //property alias popAddNewSite: popAddNewSite
    anchors.fill: parent
    Popup {
        id: popup
        x: 100
        y: 300
        width: 345
        height: 345
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        PopAddNewSite{
            id:winAddNewSite
        }
    }
    Popup{
        id: popAskLogin
        width: 345
        height: 345
        x: (parent.width -width)/2
        y: (parent.height - height)/2

        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose
        PopLogin{
            id:winSignIn
        }
        Connections {
            target: cymBdd
            onLoginRequired: {
                console.log('should open the popup now or never');
                popAskLogin.open();
            }
        }
    }

    Row{
        id: row
        anchors.fill: parent

        ListModel{
            id:siteModel
        }
        Rectangle{
            id: rctTreeView
            width: 0.18*parent.width
            height: parent.height
            color: "#b0afb9"
            radius: 4
            border.color: "#2e2e3a"
            border.width: 1
            Column{
                anchors.fill: parent

                FilterSites{
                    z:10
                }

                ListView{
                    id:listSites
                    width: parent.width
                    height: 0.8*parent.height
                    model: siteModel
                    delegate: Component {

                        LineSites{
                            id: lstListSites
                        }
                    }
                }
            }
        }
        Rectangle{
            id:rctEditInfo
            width: 0.18*parent.width
            height: parent.height
            color: "#b0afb9"
            radius: 4
            border.color: "#2e2e3a"
            border.width: 1
            Column{
                anchors.fill: parent
                padding: 2
                Button {
                    id: btnAddNewSite
                    width: 0.4*parent.width
                    height: 31
                    text: qsTr("Add New Site")

                    onClicked: {
                        popup.open();
                    }
                }
                EditSites {
                    id: editSites
                    visible: false
                }
            }

        }

        Rectangle{
            id: mapArea
            width: 0.46*parent.width
            height: parent.height
            color: "#2e2e3a"
            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: "#2e2e3a";
                }
                GradientStop {
                    position: 1.00;
                    color: "#f9f2f2";
                }
            }
            radius: 4
            border.color: "#2e2e3a"
            border.width: 1

            MapShow{
                id:showerMap
                anchors.rightMargin: 3
                anchors.leftMargin: 1
                anchors.bottomMargin: 4
                anchors.topMargin: 37
                anchors.fill: parent
                ScaleAnimator {
                        id:zoomInAnimation
                        target: showerMap;
                        from: 1;
                        to: 2;
                        duration: 500
                        running: false
                        onStopped: {
                            showerMap.visible = false;
                            siteOpen1.visible = true;
                            zoomOutAnimation.start();
                        }
                    }
                ScaleAnimator{
                    id:zoomOutAnimation
                    target: showerMap
                    from: 2
                    to: 1
                    duration: 1
                    running: false

                }
            }
            SiteOpen{
                id:siteOpen1
                visible: false
                anchors.top : parent.top
                anchors.left: parent.left
            }

            TextField {
                id: searchTextField
                y: 2
                width: 492
                height: 28
                text: qsTr("Search Place")

                MouseArea {
                    id: mouseArea
                    height: 24
                    anchors.topMargin: 0
                    anchors.fill: parent
                    onClicked: {
                        searchTextField.focus = true;
                        if (searchTextField.text == "Search Place")
                            searchTextField.text ="";

                    }
                }


            }

            Button {
                id: button
                x: 494
                y: 0
                width: 106
                height: 33
                text: qsTr("Search")
                //isDefault: true
                //activeFocusOnPress: true

                onClicked: {

                    showerMap.strSearchField = searchTextField.text;
                    //showerMap.lstModel = showerMap.searchModel;
                }
            }

        }

        Rectangle {
            enabled: false
            visible: false

            id: scene
            width: 0.46*parent.width
            height: parent.height
            color: "#e1eef3"
            radius: 4
            border.color: "#2e2e3a"
            border.width: 1
        }

        Rectangle {
            id: rctContextInfo
            width: 0.18*parent.width
            height: parent.height
            color: "#b0afb9"
            border.color: "#2e2e3a"
            border.width: 1
            radius: 4
            Button {
                id: btnSignIn
                x: 10
                y: 1
                width: 117
                height: 31
                text: qsTr("Sign In")
                anchors.right: parent.right
                anchors.rightMargin: 4


                onClicked: {
                    //popup.open();
                    if (cymBdd.getOwnerID()){
                        //sign out
                        cymBdd.signOut();

                        siteModel.clear();

                        editSites.visible = false;

                        btnSignIn.text = "Sign In";
                    }
                    else
                        popAskLogin.open();
                }
            }

            ListView {
                id: listView
                anchors.bottomMargin: 89
                anchors.topMargin: 128
                flickDeceleration: 1494
                //visible: false
                anchors.fill: parent
                model: showerMap.lstModel//searchModel
                //Component.onCompleted: cymBdd.toto();
                delegate: Component {


                    LineSearch{
                        id: titi
                    }
                }
            }
        }

    }

}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
