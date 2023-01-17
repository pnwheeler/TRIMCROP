import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item{
    id: root
    property alias val: control.value
    required property MediaPlayer mediaPlayer
    implicitHeight: parent.height

    RowLayout {
        anchors.fill: parent

        Slider {
            id: control
            enabled: mediaPlayer.seekable
            value: mediaPlayer.position / mediaPlayer.duration
            onMoved: {
                mediaPlayer.pause()
                mediaPlayer.setPosition(mediaPlayer.duration * value)
            }
            background: Rectangle {
                x: control.leftPadding
                y: control.topPadding + control.availableHeight / 2 - height / 2
                implicitWidth: root.width
                implicitHeight: 8
                width: root.width
                height: implicitHeight
                color: "#a3a3a3"

                Rectangle {
                    id: seekFill
                    width: control.visualPosition * parent.width
                    height: parent.height
                    color: "#6e6e6e"
                }
            }

            handle: Rectangle {
                width: 2
                x: seekFill.width - width/2
                y: control.topPadding + control.availableHeight / 2 - height / 2
                implicitHeight: control.implicitHeight
                color: "#44ffffff"
            }

            ToolTip {
                parent: control.handle
                visible: control.hovered
                Text {
                    font.family: "Cascadia Mono"
                    text: {
                        var m = Math.floor(mediaPlayer.position / 60000)
                        var ms = (mediaPlayer.position / 1000 - m * 60).toFixed(2)
                        return `${m}:${ms.padStart(5, 0)}`
                    }
                    color: "white"
                }
                background: Rectangle{
                    color: "transparent"
                }
            }
        }
    }
}
