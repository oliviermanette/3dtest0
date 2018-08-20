import QtQuick 2.0
import QtQuick.Controls 2.3

Item {
    Image {
        id: imgFondLogin
        source: "../../Downloads/40887597_s.jpg"
        //color: "#174ca0"
        anchors.fill: parent

        Image {
            id: image
            x: 110
            y: 8
            width: 100
            height: 100
            source: "../../Downloads/logo FLOD.png"
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
            id: textPasswd
            x: 30
            y: 229
            width: 261
            height: 40
            text: qsTr("")
            placeholderText: "Password"
        }

        Button {
            id: btnLogin
            x: 217
            y: 285
            width: 74
            height: 27
            text: qsTr("Log In")
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
