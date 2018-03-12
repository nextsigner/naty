import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import uk 1.0
Rectangle{
    id: raiz
    width: parent.width
    height: parent.heigth
    property string clienteActual: 'ninguno'
    property int idclienteActual: -2
    onVisibleChanged: {
        if(visible){
            //actualizarClientes()
        }else{
            modVerPedClientes.visible = false
        }
    }
    /*ListView{
        id:listViewClientes
        //anchors.fill: raiz
        width: raiz.width
        height: raiz.height-xTit.height
        clip: true
        model: lmClientes
        delegate: delClientes
        anchors.top: xTit.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4
        ListModel{
            id:lmClientes
            function add(t){
                return {
                    txt: t
                }
            }
        }
        Component{
            id: delClientes
            Rectangle{
                width: xApp.width*0.98
                height: app.fs*8
                border.width: 2
                radius: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                Text {
                    text: txt
                    font.pixelSize: app.fs*6
                    anchors.centerIn: parent
                }
            }
        }
    }*/
    Rectangle{
        id: xTit
        width: raiz.width
        height: app.fs*10
        color:"blue"
        Text {
            id: txtTit
            text: "<b>"+raiz.clienteActual+"</b>"
            font.pixelSize: app.fs*4
            anchors.centerIn: parent
            color: "white"
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                raiz.visible = false
            }
        }

    }
    Column{
        width: raiz.width
        anchors.centerIn: raiz
        Rectangle{
            width: parent.width-app.fs
            height: txtCantPSE.contentHeight+app.fs*4
            border.width: 2
            radius: app.fs
            Text {
                id: txtCantPSE
                font.pixelSize: app.fs*4
                anchors.centerIn: parent
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    modVerPedClientes.modo = 1
                    modVerPedClientes.idcliente = raiz.idclienteActual
                    modVerPedClientes.visible = true
                }
            }
        }
    }



    BotFlot{
        width: height
        height: app.fs*10
        bg:"blue"
        txt: "+P"
        anchors.bottom: raiz.bottom
        anchors.bottomMargin: app.fs*4
        anchors.right: raiz.right
        anchors.rightMargin: app.fs*4
        onClickeado: {
            modAgregarPedido.idcliente = raiz.idclienteActual
            modAgregarPedido.visible = true
            app.verMenu = false
        }
    }


    ModAddPedido{
        id: modAgregarPedido
        width: raiz.width
        height: raiz.height
        visible: false
        onVisibleChanged: {
            if(!visible){
                cargarEstadoCliente(raiz.idclienteActual, raiz.clienteActual)
            }
        }
    }
    ModVerPedCliente{
        id: modVerPedClientes
        width: raiz.width
        height: raiz.height
        visible: false
    }

    function cargarEstadoCliente(id, nom){
        idclienteActual = id
        clienteActual = nom
        var sql = 'select * from clientes where id='+id+''
        var jsonString = uk.getJsonSql('clientes', sql, 'sqlite', true)
        var json = JSON.parse(jsonString)
        raiz.clienteActual =  json['row0'].col1

        sql = 'select * from pedidos where idcliente='+id+''
        //sql = 'select * from pedidos'
        jsonString = uk.getJsonSql('pedidos', sql, 'sqlite', true)

        json = JSON.parse(jsonString)
        txtCantPSE.text = ' '+Object.keys(json).length+' pedidos\nsin entregar'

        raiz.visible = true
    }

    function actualizarClientes(){
        lmClientes.clear()
        var jsonString = uk.getJsonSql('clientes', 'select * from clientes', 'sqlite', true)
        var json = JSON.parse(jsonString)
        for(var i=0; i < Object.keys(json).length; i++){
            //var item = Object.keys()[0]
            lmClientes.append(lmClientes.add(json['row'+i].col1))
        }
        listViewClientes.currentIndex = lmClientes.count-1
    }

}
