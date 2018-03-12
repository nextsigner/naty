import QtQuick 2.0

Item{
    id: raiz
    width: height
    height: app.fs*10

    property color bg
    property alias txt: txtBot.text
    property int radio: -1
    //property alias fs: txtBot.font.pixelSize
    signal clickeado
    Rectangle{
        id: fondo
        width: raiz.width
        height: width
        color: bg
        radius: raiz.radio===-1?width*0.5:raiz.radio
        anchors.centerIn: raiz

    }
    Text {
        id: txtBot
        font.pixelSize: fondo.width*0.6
        font.family: "FontAwesome"
        anchors.centerIn: parent
        color: "white"
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            clickeado()
            an.start()
        }
    }
    SequentialAnimation{
        id: an
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
            property: "width"
            from: raiz.width*0.5
            to: raiz.width
            duration: 200
            easing.type: Easing.OutBounce
        }
    }
}
