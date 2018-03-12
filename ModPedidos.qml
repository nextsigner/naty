import QtQuick 2.0

Rectangle {
    id: raiz
    property int idcliente: -1
    property int modo: 1
    onVisibleChanged: {
        if(visible){
            cargarPedidos()
        }
    }
    ListView{
        id:listViewPedClientes
        property int itemSeleccionado: -1
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
                property bool seleccionado: false
                //visible:  !listViewPedClientes.itemSeleccionado && seleccionado ? false: true
                color: seleccionado ? "#ccc" : "#fff"
                width: parent.width*0.98
                //height: txtPed.contentHeight+app.fs*8
                //height: listViewPedClientes.itemSeleccionado===parseInt(cid) ? txtPed.contentHeight+app.fs*24 : txtPed.contentHeight+app.fs*8
                height: colDel.height+app.fs*4
                border.width: 2
                radius: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                Behavior on height{
                    NumberAnimation{
                        duration: 250
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        tpress.stop()
                        xDelPedClientes.presionado = false
                        //xDelPedClientes.seleccionado = false
                        //xDelPedClientes.seleccionado = !xDelPedClientes.seleccionado

                    }
                    onPressed: {
                        xDelPedClientes.seleccionado = -1
                        listViewPedClientes.itemSeleccionado = -1
                        xDelPedClientes.presionado=true
                        tpress.start()
                    }
                    onReleased: {
                        tpress.stop()
                        xDelPedClientes.presionado=false
                    }
                }
                Column{
                    id:colDel
                    width: parent.width-app.fs*2
                    anchors.centerIn: parent
                    spacing: app.fs*2
                    Text {
                        id: txtFechaPed
                        text: cfecha
                        width: parent.width-app.fs
                        wrapMode: Text.WordWrap
                        font.pixelSize: app.fs*2
                        //anchors.top: parent.top
                        //anchors.topMargin:  app.fs
                        //anchors.left: parent.left
                        //anchors.leftMargin: app.fs
                        textFormat: Text.RichText
                        //anchors.centerIn: parent
                        color: listViewPedClientes.itemSeleccionado===parseInt(cid) ? "black" : "red"
                    }
                    Text {
                        id: txtPed
                        text: cdes
                        width: parent.width-app.fs
                        height: contentHeight
                        wrapMode: Text.WordWrap
                        font.pixelSize: app.fs*6

                        //anchors.horizontalCenter: parent.horizontalCenter
                        //anchors.bottom: parent.bottom
                        //anchors.bottomMargin: app.fs*2
                        //anchors.centerIn: parent
                        color: "black"
                    }
                    BotonArea{
                        txt: 'Entregar'
                        visible: listViewPedClientes.itemSeleccionado===parseInt(cid)
                        activo: true
                        onIrA: {
                            //app.area = index
                            //raiz.ver = false
                        }
                    }
                }
                /*Text {
                    id: txtFechaPed
                    text: cfecha
                    width: parent.width-app.fs
                    wrapMode: Text.WordWrap
                    font.pixelSize: app.fs*2
                    anchors.top: parent.top
                    anchors.topMargin:  app.fs
                    anchors.left: parent.left
                    anchors.leftMargin: app.fs
                    textFormat: Text.RichText
                    //anchors.centerIn: parent
                    color: listViewPedClientes.itemSeleccionado===parseInt(cid) ? "black" : "red"
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
                }*/
                Timer {
                    id:tpress
                    running: false
                    repeat: false
                    interval:1500
                    onTriggered: {
                        if(xDelPedClientes.presionado){
                            listViewPedClientes.itemSeleccionado = cid
                            xDelPedClientes.seleccionado= true

                            //clienteSeleccionado(cid, cnom)
                        }else{
                            listViewPedClientes.itemSeleccionado = false
                            xDelPedClientes.seleccionado= false
                        }
                    }
                }

                Component.onCompleted: {
                    var sql = 'select nom from clientes where  id='+cid
                    console.log("CID :"+cid)
                    var rows = unik.getSqlData('clientes', sql, 'sqlite')
                    //var nc = ''+rows[0].col[0]
                    if(rows.length>0){
                        txtFechaPed.text += ' pedido por <b>'+rows[0].col[0]+'</b>'
                    }else{
                        txtFechaPed.text += ' pedido por cliente eliminado de id '+cid
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
    function cargarPedidos(){
        lmPedClientes.clear()
        var sql = 'select * from pedidos where  estado='+raiz.modo

        var rows = uk.getSqlData('pedidos', sql, 'sqlite')
        for(var i=0;i<rows.length;i++){
            var ms = parseInt(rows[i].col[4])
            //console.log("MS: "+ms)
            var d = new Date(ms)
            var cf = ''+d.getDate()+'/'+parseInt(d.getMonth()+1)+'/'+d.getFullYear()+' '+d.getHours()+'hs'
            lmPedClientes.append(lmPedClientes.add(rows[i].col[0], rows[i].col[1], rows[i].col[2], cf))
        }
    }
}
