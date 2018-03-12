import QtQuick 2.0

Rectangle {
    id: raiz
    color: "blue"
    signal burcar(string dato)
    property alias txt: tiBuscar.text
    onVisibleChanged: {
        if(visible){
            xti.focus = true
            if(tiBuscar.text!==''){
                buscar(tiBuscar.text)
            }
        }
    }
    Rectangle{
        id:xti
        width: raiz.width-app.fs
        height: raiz.height-app.fs
        border.width: 2
        radius: app.fs
        anchors.centerIn: raiz
        TextInput {
            id: tiBuscar
            text: ""
            font.pixelSize: app.fs*6
            width: parent.width-app.fs
            height: app.fs*6
            focus: parent.focus
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.centerIn:  parent
            onTextChanged: buscar(tiBuscar.text)
            Keys.onReturnPressed: buscar(tiBuscar.text)
        }
    }
}
