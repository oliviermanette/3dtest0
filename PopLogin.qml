import QtQuick 2.11
import QtQuick.Controls 2.3

Item {
    Image {
        id: imgFondLogin
        source: "40887597_s.jpg"
        width:320
        height: 320
        //anchors.fill: parent

        Image {
            id: image
            x: 110
            y: 8
            width: 100
            height: 100
            source: "logo_FLOD.png"
        }

        TextField {
            id: txtLogin
            x: 30
            y: 175
            width: 261
            height: 40
            text: qsTr("")
            placeholderText: "FLOD ID or Email"
        }

        TextField {
            id: txtPasswd
            x: 30
            y: 229
            width: 261
            height: 40
            placeholderText: "Password"
            echoMode: TextInput.Password
        }

        Button {
            id: btnLogin
            x: 217
            y: 285
            width: 74
            height: 27
            text: qsTr("Log In")
            onClicked: {

                cymBdd.getOwnerIDByLogin(txtLogin.text, txtPasswd.text);
                txtPasswd.text="";

                if (cymBdd.getOwnerID()){
                    popAskLogin.close();

                    fctUpdateSitesList();
                    fctUpdatePipelines();

                    btnSignIn.text = "Sign Out";
                    editSites.visible = true;
                }
                else{
                    // login failed
                    btnLogin.text ="Try Again";
                }


            }
        }

        Label {
            id: label
            x: 37
            y: 131
            color: "#f8f9f4"
            text: qsTr("Sign In to FLOD Cloud")
            font.family: "Verdana"
            font.pointSize: 22
            font.bold: false
        }

        Button {
            id: button
            x: 136
            y: 285
            width: 74
            height: 27
            text: qsTr("Forgot")
        }
    }

}

/*##^## Designer {
    D{i:0;autoSize:true;height:320;width:320}
}
 ##^##*/
