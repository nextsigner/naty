import QtQuick 2.0

Rectangle{
    id: raiz
    width: txtBtn.width*1.2
    height: app.fs*8
    color: !esBotMostrar?"white":"transparent"
    border.width: !esBotMostrar?2:0
    signal irA
    property alias txt: txtBtn.text
    property bool activo: false
    property bool esBotMostrar: false
    opacity: activo || esBotMostrar ? 1.0 : 0.5
    Rectangle{
        width: raiz.parent.width
        height: raiz.height
        color: !esBotMostrar?"blue":"transparent"
    }
    Text {
        id:txtBtn
        font.pixelSize: app.fs*8
        font.family: "FontAwesome"
        //color: !esBotMostrar?"black":"white"
        color: "white"
        anchors.centerIn: raiz
    }
    MouseArea{
        anchors.fill: raiz
        onClicked: {
            irA()
        }
    }

}
