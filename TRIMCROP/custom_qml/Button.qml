import QtQuick
import QtQuick.Controls

RoundButton {
    id: root
    property string borderColor
    property int borderWidth
    property alias textFormat: textArea

    hoverEnabled: true
    scale: hovered ? 1.1 : 1
    height: parent.height

    contentItem: Text{
        id: textArea
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
    }

    background: Rectangle {
        color: "transparent"
        border.color: "white"
        border.width: 2
        radius: 4
    }
}
