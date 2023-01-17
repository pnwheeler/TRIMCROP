import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    required property MediaPlayer mediaPlayer
    property bool muted: false
    property real volume: control.value/100.
    property real valWhenMuted: 100

    implicitHeight: buttons.height

    RowLayout {
        anchors.fill: parent
        Item {
            id: buttons

            width: muteButton.implicitWidth
            height: muteButton.implicitHeight

            RoundButton {
                id: muteButton
                radius: 22
                icon.source: muted ? "qrc:/svg/sound-off.svg" : "qrc:/svg/sound-min.svg"
                icon.width: radius
                icon.height: radius
                hoverEnabled: true
                scale: hovered ? 1.1 : 1
                background: Rectangle {
                    id: buttonOutline
                    anchors.centerIn: parent
                    color: "transparent"
                    width: parent.width - 5
                    height: parent.height - 5
                    border.width: 2
                    border.color: muted ? parent.hovered ? "#aaffffff" : "#44ffffff" : "transparent"
                    radius: width
                }
                onClicked: {
                    if(!muted){
                        control.value = 0.0
                        muted = true
                    }else{
                        control.value = valWhenMuted
                        muted = false
                    }
                }
            }
        }

        Slider {
            id: control
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            enabled: true
            to: 100.0
            value: 100.0
            background: Rectangle {
                x: control.leftPadding
                y: control.topPadding + control.availableHeight / 2 - height / 2
                implicitWidth: root.width
                implicitHeight:fillRect.height
                width: control.availableWidth
                height: implicitHeight
                radius: fillRect.radius
                color: "transparent"
                border.color: "white"
                border.width: 2

                Rectangle {
                    id: fillRect
                    Layout.alignment: Qt.AlignVCenter
                    width: control.visualPosition * parent.width
                    height: 15
                    color: Qt.rgba(1, 1, 1, (volume + 1) / 2)
                    radius: height
                }
            }

            onValueChanged: (volume) => {
                if (value <= 0.0){
                    muted = true
                }else{
                    valWhenMuted = control.value
                    if(muted && value >= 0.0)
                        muted = false
                }
            }

            handle: Item {}
        }
    }
}
