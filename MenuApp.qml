import QtQuick 2.0

Rectangle {
    id: raiz
    height: colMenu.children[0].height*colMenu.children.length+((colMenu.children.length-1))
    //color: "red"
    property bool ver: false
    x: ver ? 0 : 0-width
    Behavior on x{
        NumberAnimation{
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }
    BotonArea{
        txt: "\uf0c9"
        onIrA: {
            raiz.ver = true
        }
        activo: true
        esBotMostrar: true
        visible: !raiz.ver
        anchors.left: parent.right
        anchors.leftMargin: app.fs
        anchors.top: parent.top
        anchors.topMargin: app.fs
    }
    Column{
        id: colMenu
        width: parent.width*0.98
        spacing: app.fs

        //anchors.centerIn: raiz

        Repeater{
            model: ["Clientas", "Pedidos", "Entregas", "Pagos", "Deudas"]
            BotonArea{
                txt: modelData
                onIrA: {
                    app.area = index
                    raiz.ver = false
                }
                activo: index===app.area
                visible: raiz.ver
            }
        }
    }
}
