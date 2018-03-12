import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import uk 1.0
Item{
    id: raiz
    width: parent.width
    height: parent.heigth
    property bool verBuscador: false
    property alias msl: modSelLetra
    signal clienteSeleccionado(int id, string nom)
    onVerBuscadorChanged: {
        //app.verMenu = false
    }
    onVisibleChanged: {
        if(visible){
            if(modSelLetra.enabled){
                //actualizarClientes()
            }
        }
    }

    ListView{
        id:listViewClientes
        //anchors.fill: raiz
        width: raiz.width
        height: !xInsClientes.visible ? raiz.height-xTit.height-xBuscadores.height : raiz.height-xTit.height-xInsClientes.height
        clip: true
        model: lmClientes
        delegate: delClientes
        anchors.top: !xInsClientes.visible ?  xBuscadores.bottom : xInsClientes.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4
        function mostrarBotonEliminar(){
            var mostrar = false
            for(var i=0; i <lmClientes.count;i++){
                if(lmClientes.get(i).csel){
                    mostrar = true
                }
            }
            btnEliminarClientesSel.visible = mostrar
        }
        ListModel{
            id:lmClientes
            function add(id, nom, sel){
                return {
                    cid: id,
                    cnom: nom,
                    csel:sel
                }
            }
        }
        Component{
            id: delClientes

            Rectangle{
                id:xDelClientes
                property bool seleccionado: csel
                property bool presionado: false
                width: xApp.width*0.98
                height: app.fs*8
                border.width: 2
                radius: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                color: xDelClientes.seleccionado ? "blue" : "#fff"
                onSeleccionadoChanged: {
                    csel = seleccionado
                    listViewClientes.mostrarBotonEliminar()
                }
                Text {
                    text: cnom
                    font.pixelSize: app.fs*6
                    anchors.centerIn: parent
                    color: xDelClientes.seleccionado ? "white" : "black"
                }
                Timer {
                    id:tpress
                    running: false
                    repeat: false
                    interval:1500
                    onTriggered: {
                        if(xDelClientes.presionado){
                            xDelClientes.seleccionado= true
                            clienteSeleccionado(cid, cnom)
                        }else{
                            xDelClientes.seleccionado= false
                        }
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        tpress.stop()
                        xDelClientes.presionado = false
                        xDelClientes.seleccionado = !xDelClientes.seleccionado

                    }
                    onPressed: {
                        xDelClientes.presionado=true
                        tpress.start()
                    }
                    onReleased: {
                        tpress.stop()
                        xDelClientes.presionado=false
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
            text: "<b>Clientes</b>"
            font.pixelSize: app.fs*4
            anchors.centerIn: parent
            color: "white"
        }
        /*MouseArea{
            anchors.fill: parent
            onClicked: {
                xInsClientes.visible = true
            }
        }*/


    }




    Rectangle{
        id:xBuscadores
        width: parent.width
        height: app.fs*10
        anchors.top: xTit.bottom
        ModSelLetra{
            id:modSelLetra
            minimumValue: 0
            maximumValue: 29
            value: 0
            width: parent.width
            height: app.fs*10
            onLetraActualChanged: {
                if(modSelLetra.enabled){
                    if(letraActual!=='*'){
                        buscarPorLetra(letraActual)
                    }else{
                        buscarPorLetra('')
                    }
                }
            }
        }
        ModBuscar{
            id: modBuscador
            width: parent.width
            height: app.fs*10
            visible: raiz.verBuscador
            onBurcar: {
                raiz.buscar(dato)
            }
            onVisibleChanged: {
                modSelLetra.value = 0
                modSelLetra.rectSel.x = 0
            }
        }
    }



    Rectangle{
        id: xInsClientes
        width: raiz.width
        height: colInsClientes.height
        visible: false
        onVisibleChanged: {
            if(!visible){
                app.verMenu = true
            }
        }
        Column{
            id: colInsClientes
            width: parent.width
            spacing: app.fs*2
            Rectangle{
                width: raiz.width
                height: app.fs*10
                color: "blue"
                Text {
                    text: "Nuevo Cliente"
                    font.pixelSize: app.fs*8
                    color: "white"
                    width: contentWidth
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                width: app.width-app.fs*2
                height: app.fs*10
                border.width: 2
                radius: app.fs
                TextInput {
                    id: tiNC
                    text: ""
                    font.pixelSize: app.fs*6
                    width: parent.width-app.fs
                    height: app.fs*6
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
                    if(tiNC.text!==''){
                        xInsClientes.visible = false
                        var d = new Date(Date.now())
                        var sql = 'INSERT INTO clientes(nom, ms)VALUES(\''+tiNC.text+'\', '+d.getTime()+')'
                        uk.sqlQuery(sql, true)
                        actualizarClientes()
                    }
                }
            }
            Item{
                width: parent.width
                height: app.fs*2
            }
        }
    }

    BotFlot{
        width: height
        height: app.fs*10
        bg:"blue"
        txt: "+"
        anchors.bottom: raiz.bottom
        anchors.bottomMargin: app.fs*4
        anchors.right: raiz.right
        anchors.rightMargin: app.fs*4
        onClickeado: {
            xInsClientes.visible = true
            app.verMenu = false
        }
    }
    BotFlot{
        id:btnEliminarClientesSel
        width: height
        height: app.fs*10
        bg:"blue"
        txt: "X"
        anchors.bottom: raiz.bottom
        anchors.bottomMargin: app.fs*4
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        onClickeado: {
            //raiz.verBuscador = !raiz.verBuscador
            //app.verMenu = !verBuscador
            var sql = 'delete from clientes where id=-1 '
            var cant =0;
            for(var i=0; i <lmClientes.count;i++){
                if(lmClientes.get(i).csel){
                    sql += ' OR  id='+lmClientes.get(i).cid+' '
                }
                cant++;
            }
            console.log(sql)
            uk.sqlQuery(sql, true)
            actualizarClientes()
        }
    }
    BotFlot{
        width: height
        height: app.fs*10
        bg:"blue"
        txt: "\uf002"

        anchors.bottom: raiz.bottom
        anchors.bottomMargin: app.fs*4
        anchors.left: raiz.left
        anchors.leftMargin: app.fs*4
        onClickeado: {
            raiz.verBuscador = !raiz.verBuscador
            //app.verMenu = !verBuscador
        }
    }
    Rectangle{
        id: tapaANC
        width: parent.width
        height: parent.height-xInsClientes.height
        visible: xInsClientes.visible
        color: "black"
        anchors.top: xInsClientes.bottom
        opacity: 0.35
        MouseArea{
            anchors.fill: parent
        }
    }



    function actualizarClientes(){
        lmClientes.clear()
        var jsonString = uk.getJsonSql('clientes', 'select * from clientes', 'sqlite', true)
        var json = JSON.parse(jsonString)
        for(var i=0; i < Object.keys(json).length; i++){
            //var item = Object.keys()[0]
            lmClientes.append(lmClientes.add(json['row'+i].col0, json['row'+i].col1, false))
        }
        listViewClientes.currentIndex = lmClientes.count-1
        btnEliminarClientesSel.visible = false
    }
    function buscar(d){
        console.log('Buscando '+d)
        lmClientes.clear()
        var sql = 'SELECT * FROM clientes WHERE nom LIKE \'%'+d+'%\';'
        var res = uk.getJsonSql('clientes', sql, 'sqlite', true)
        var json = JSON.parse(res)
        //console.log(JSON.stringify(json))
        for(var i=0; i < Object.keys(json).length; i++){
            //var item = Object.keys()[0]
            lmClientes.append(lmClientes.add(json['row'+i].col0, json['row'+i].col1, false))
        }
        listViewClientes.currentIndex = lmClientes.count-1
    }
    function buscarPorLetra(l){
        console.log('Buscando por letra '+l)
        lmClientes.clear()
        var cant=0;
        var sql = 'SELECT * FROM clientes WHERE nom LIKE \''+l+'%\';'
        var res = uk.getJsonSql('clientes', sql, 'sqlite', true)
        var json = JSON.parse(res)
        //console.log(JSON.stringify(json))
        for(var i=0; i < Object.keys(json).length; i++){
            //var item = Object.keys()[0]
            lmClientes.append(lmClientes.add(json['row'+i].col0, json['row'+i].col1, false))
            cant++;
        }
        listViewClientes.currentIndex = lmClientes.count-1
    }

}

