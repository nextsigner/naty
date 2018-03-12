import QtQuick 2.0

Item{
    id: raiz
    property color bg
    property alias txt: txtBot.text
    property int radio: -1
    property int fs: 10
    //property alias fs: txtBot.font.pixelSize
    signal clickeado
    Rectangle{
        id: fondo
        width: raiz.width
        height: raiz.height
        color: bg
        radius: raiz.radio===-1?width*0.5:raiz.radio
        anchors.centerIn: raiz
    }
    Text {
        id: txtBot
        font.pixelSize: raiz.fs
        font.family: "FontAwesome"
        anchors.centerIn: parent
        color: "white"
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {

            an.start()
        }
    }
    ParallelAnimation{
        id: an
        onStopped: an2.start()
        NumberAnimation {
            target: fondo
            property: "width"
            from: raiz.width
            to: raiz.width*0.5
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: fondo
            property: "height"
            from: raiz.height
            to: raiz.height*0.5
            duration: 200
            easing.type: Easing.OutBounce
        }
    }
    ParallelAnimation{
        id: an2
        onStopped: {
            clickeado()
            raiz.visible = false
        }
        NumberAnimation {
            target: fondo
            property: "width"
            from: raiz.width*.5
            to: raiz.width
            duration: 100
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: fondo
            property: "height"
            from: raiz.height*0.5
            to: raiz.height
            duration: 200
            easing.type: Easing.OutBounce
        }
    }
}
