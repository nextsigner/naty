import QtQuick 2.0

Rectangle {
    id: raiz
    property int idcliente
    property int modo: 1
    onVisibleChanged: {
        if(visible){
            cargarPedCliente()
        }
    }
    ListView{
        id:listViewPedClientes
        //anchors.fill: raiz
        width: raiz.width
        height: raiz.height-xTit.height
        clip: true
        model: lmPedClientes
        delegate: delClientes
        anchors.top: xTit.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4
        function mostrarBotonEliminar(){
            var mostrar = false
            for(var i=0; i <lmPedClientes.count;i++){
                if(lmPedClientes.get(i).csel){
                    mostrar = true
                }
            }
            btnEliminarClientesSel.visible = mostrar
        }
        ListModel{
            id:lmPedClientes
            function add(id, idc, des, fecha){
                return {
                    cid: id,
                    cidc: idc,
                    cdes: des,
                    cfecha: fecha
                }
            }
        }
        Component{
            id: delClientes
            Rectangle{
                id:xDelPedClientes
                property bool presionado: false
                width: parent.width*0.98
                height: txtPed.contentHeight+app.fs*8
                border.width: 2
                radius: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                Text {
                    id: txtFechaPed
                    text: cfecha
                    width: parent.width-app.fs
                    wrapMode: Text.WordWrap
                    font.pixelSize: app.fs*2
                    anchors.top: parent.top
                    anchors.topMargin:  app.fs
                    anchors.left: parent.left
                    anchors.leftMargin: app.fs
                    //anchors.centerIn: parent
                    color: "black"
                }
                Text {
                    id: txtPed
                    text: cdes
                    width: parent.width-app.fs
                    wrapMode: Text.WordWrap
                    font.pixelSize: app.fs*6
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: app.fs*2
                    //anchors.centerIn: parent
                    color: "black"
                }
                Timer {
                    id:tpress
                    running: false
                    repeat: false
                    interval:1500
                    onTriggered: {
                        if(xDelPedClientes.presionado){
                            //xDelPedClientes.seleccionado= true
                            clienteSeleccionado(cid, cnom)
                        }else{
                            xDelPedClientes.seleccionado= false
                        }
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        tpress.stop()
                        xDelPedClientes.presionado = false
                        //xDelPedClientes.seleccionado = !xDelPedClientes.seleccionado

                    }
                    onPressed: {
                        xDelPedClientes.presionado=true
                        tpress.start()
                    }
                    onReleased: {
                        tpress.stop()
                        xDelPedClientes.presionado=false
                    }
                }
            }
        }
    }

    Rectangle{
        id: xTit
        width: raiz.width
        height: app.fs*10
        color:"blue"
        Text {
            id: txtTit
            text: "<b>Pedidos sin entregar</b>"
            font.pixelSize: app.fs*4
            anchors.centerIn: parent
            color: "white"
        }
    }
    function cargarPedCliente(){
        lmPedClientes.clear()
        var sql = 'select * from pedidos where idcliente='+raiz.idcliente+' and estado='+raiz.modo
        var jsonString = uk.getJsonSql('pedidos', sql, 'sqlite', true)

        var json = JSON.parse(jsonString)
        for(var i=0;i<Object.keys(json).length;i++){
            var ms = parseInt(json['row'+i].col4)
            //console.log("MS: "+ms)
            var d = new Date(ms)
            var cf = ''+d.getDate()+'/'+parseInt(d.getMonth()+1)+'/'+d.getFullYear()+' '+d.getHours()+'hs'
            lmPedClientes.append(lmPedClientes.add(json['row'+i].col0, json['row'+i].col1, json['row'+i].col2, cf))

        }
    }
}
