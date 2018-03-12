import QtQuick 2.0

// Minimal slider implementation
Rectangle {
    id: slider

    //property alias text: buttonText.text
    Accessible.role: Accessible.Slider

    property int value: 5         // required
    property int minimumValue: 0  // optional (default INT_MIN)
    property int maximumValue: 20 // optional (default INT_MAX)
    property int stepSize: 1      // optional (default 1)

    property var arrayLetras: ["*", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "Ñ", "O", "P", "Q", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    property string letraActual
    property alias rectSel: sel
    property bool enabled: false

    width: 100
    height: 30
    border.color: "black"
    border.width: 1
    Row{
        width: slider.width
        height: slider.height
        Repeater{
            model: arrayLetras
            Rectangle{
                id: l
                width: slider.width/arrayLetras.length
                height: slider.height
                //color: ""
                onXChanged: {
                    var pos = x / slider.width * (maximumValue - minimumValue) + minimumValue
                    slider.value = pos
                }
                Text {
                    id: letra
                    text: arrayLetras[index]
                    anchors.centerIn: parent
                    font.pixelSize: parent.width*0.8
                    //color: "white"
                }
            }
        }
    }
    Rectangle{
        id: sel
        width: app.fs*6
        height: slider.height
        color: "blue"
        onXChanged: {
            if(raiz.enabled){
                var pos = x / slider.width * (maximumValue - minimumValue) + minimumValue
                slider.value = pos
                var sql = 'UPDATE varglob SET val=\''+x+'\' WHERE nom=\'uposxletsel\''
                uk.sqlQuery(sql, true)
            }
        }
        Text {
            id: letraRect
            text: arrayLetras[slider.value]
            anchors.centerIn: parent
            font.pixelSize: parent.height*0.5
            color: "white"
            onTextChanged: slider.letraActual = text
        }
        MouseArea{
            anchors.fill: parent
            drag.target:sel
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: slider.width-sel.width
            onPressed: {
                var pos = sel.x / slider.width * (maximumValue - minimumValue) + minimumValue
                slider.value = pos
            }
        }
    }

    Keys.onLeftPressed: value > minimumValue ? value = value - stepSize : minimumValue
    Keys.onRightPressed: value < maximumValue ? value = value + stepSize : maximumValue
    function setPos(px){
        sel.x = px
    }
}
