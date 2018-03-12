import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: raiz
    property int idcliente: -1
    property string nomcliente: '?'
    Rectangle{
        id: xTit
        width: raiz.width
        height: app.fs*10
        color:"blue"

        Text {
            id: txtTit
            text: "<b>Agregar Pedido</b>"
            font.pixelSize: app.fs*4
            anchors.centerIn: parent
            color: "white"
        }

        BotFlot{
            id:btnEliminarClientesSel
            width: height
            height: app.fs*10
            bg:"blue"
            txt: "\uf00c"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: app.fs*0.1
            onClickeado: {
                raiz.visible = false
            }
        }

    }


    Rectangle{
        id: xInsPedido
        width: raiz.width
        height: raiz.height-xTit.height
        onVisibleChanged: {
            /*if(!visible){
                app.verMenu = true
            }*/
        }
        Column{
            id: colInsPedido
            width: parent.width
            height: parent.height
            spacing: app.fs*2
            Rectangle{
                width: raiz.width
                height: app.fs*10
                color: "blue"
                Text {
                    text: "Nuevo Pedido:"
                    font.pixelSize: app.fs*6
                    color: "white"
                    width: contentWidth
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                width: app.width-app.fs*2
                height: parent.height/2-app.fs*8
                border.width: 2
                radius: app.fs
                TextArea {
                    id: tiPedido
                    text: ""
                    font.pixelSize: app.fs*6
                    wrapMode: Text.WordWrap
                    width: parent.width-app.fs
                    height: parent.height-app.fs
                    //anchors.horizontalCenter: parent.horizontalCenter
                    anchors.centerIn:  parent
                }
            }
            Boton{
                width: app.fs*30
                height: app.fs*8
                radio:app.fs
                bg:"blue"
                txt: "Agregar"
                fs: app.fs*6
                anchors.right: parent.right
                anchors.rightMargin: app.fs*4
                onClickeado: {
                    if(tiPedido.text!==''){
                        var d = new Date(Date.now())
                        var sql = 'INSERT INTO pedidos(idcliente, pedido, estado, ms)VALUES(\''+raiz.idcliente+'\', \''+tiPedido.text+'\', 1, '+d.getTime()+')'
                        uk.sqlQuery(sql, true)
                        raiz.visible = false
                    }
                }
            }
            Item{
                width: parent.width
                height: app.fs*2
            }
        }

    }


}
