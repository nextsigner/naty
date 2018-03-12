import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import uk 1.0
ApplicationWindow {
    id: app
    visible: true
    width: 540
    height: 960
    title: qsTr("Naty")
    property int area: 0
    property int fs: xApp.width*0.015
    property bool verMenu: true
    onVerMenuChanged: {
        menuApp.visible=verMenu
        console.log("Ver Menu: "+verMenu)
    }
    onClosing: {
        if(Qt.platform.os==='android'){
            close.accepted = false;
        }
    }



    UK{id:uk}
    FontLoader {name: "FontAwesome";source: "qrc:/resource/fontawesome-webfont.ttf";}
    Rectangle{
        id: xApp
        width:app.width<app.height? app.width*0.98 : app.height*0.96
        height:app.width<app.height? app.height*0.96 : app.width*0.98
        anchors.centerIn: parent
        //color: "#333"
        rotation: app.width<app.height?0:90

        ModCargarClientes{
            id:modCargarClientes;
            anchors.fill: parent
            visible: app.area === 0
            Component.onCompleted: {
                //actualizarClientes()
            }
            onClienteSeleccionado: {
                modEstadoCliente.cargarEstadoCliente(id, nom)
            }
        }
        ModEstadoCliente{
            id:modEstadoCliente;
            anchors.fill: parent
           // visible: app.area === 1
            visible: false
        }
        ModPedidos{
            id:modPedidos
            anchors.fill: parent
            visible: app.area === 1
        }
        MenuApp{
            id: menuApp
            width: parent.width*0.8
            visible: app.verMenu
        }
    }
    Timer{
        id: tomenapp
        running: false
    }
    Component.onCompleted: {
        unik.debugLog = true
        var sf = ((''+appsDir).replace('file:///', ''))+'/naty4.sqlite'
        console.log("BD Location: "+sf)
        var initSqlite = unik.sqliteInit(sf)
        var sql

        //Tabla clientes
        sql = 'CREATE TABLE IF NOT EXISTS clientes(
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       nom TEXT,
                       ms NUMERIC
                        )'
        unik.sqlQuery(sql)

        //Tabla pedidos
        sql = 'CREATE TABLE IF NOT EXISTS pedidos(
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       idcliente TEXT,
                       pedido TEXT,
                       estado NUMERIC,
                       ms TEXT
                        )'
        unik.sqlQuery(sql)

        //Tabla movimientos
        //tipo 1=pago
        //tipo 2=deuda
        //tipo 3=cancelado
        sql = 'CREATE TABLE IF NOT EXISTS movimientos2(
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       idcliente TEXT,
                       tipo NUMERIC,
                       monto NUMERIC,
                       ms TEXT
                        )'
        unik.sqlQuery(sql)

        //Tabla Entregas
        sql = 'CREATE TABLE IF NOT EXISTS entregas(
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       idcliente TEXT,
                       idpedido NUMERIC,
                       montoapagar NUMERIC,
                       ms TEXT
                        )'
        unik.sqlQuery(sql)

        //Tabla varglob
        sql = 'CREATE TABLE IF NOT EXISTS varglob(
                       id INTEGER PRIMARY KEY AUTOINCREMENT,
                       nom TEXT,
                       val TEXT
                       )'
        unik.sqlQuery(sql)

        //Detectar Ultima letra seleccionada
        var d = getVG('uposxletsel', '0')
        if(d!==''){
            modCargarClientes.msl.enabled = true
            modCargarClientes.msl.setPos(parseInt(d))
        }else{
            console.log('NO uletrasel: '+d)
            modCargarClientes.msl.enabled = true
            modCargarClientes.msl.setPos(0)
        }
    }
    function getVG(nom, valxdef){
        var sql = 'select val from varglob where nom=\''+nom+'\''
        var rows = unik.getSqlData('varglob', sql, 'sqlite')
        if(rows[0].col[0]!==""){
            return rows[0].col[0]
        }else{
            sql = 'INSERT INTO varglob(id, nom, val)VALUES(NULL, \''+nom+'\', \''+valxdef+'\')'
            unik.sqlQuery(sql)
        }
        return ''
    }
}

