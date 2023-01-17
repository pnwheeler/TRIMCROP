import QtQuick
import QtQuick.Controls

Rectangle {
    property int widthY
    property int widthX
    width: widthX
    height: widthY
    color: "#ccffffff"
    z: 1
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            parent.color = "#ccc4c4c4"
            parent.z = 2
        }
        onExited: {
            parent.color = "#ccffffff"
            parent.z = 1
        }
    }
}
