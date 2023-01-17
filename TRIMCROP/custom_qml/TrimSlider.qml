import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

//----------------Trim Slider-------------------
Item{
    id: root
    required property MediaPlayer mediaPlayer
    property alias bgColor: controlFill.color
    property alias firstVal: control.first.value
    property alias secondVal: control.second.value
    property int positionStart: mediaPlayer.duration * firstVal
    property int positionEnd: mediaPlayer.duration * secondVal
    property bool playing: (mediaPlayer.playbackState === MediaPlayer.PlayingState) ? true : false
    implicitHeight: 20

    //-------------------------Update some values---------
    Connections {
        target: root.mediaPlayer
        //---------------Reset handle values--------------
        function onHasVideoChanged() {
            if (mediaPlayer.hasVideo){
                firstVal = 0
                secondVal = 1
            }
        }
        //----------------Reset play loop-----------------
        function onPositionChanged(){
            if (mediaPlayer.position < positionStart)
                mediaPlayer.setPosition(positionStart)
            if(mediaPlayer.position > positionEnd + 1)
                mediaPlayer.setPosition(positionStart)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: -1

        RangeSlider {
            id: control
            enabled: mediaPlayer.seekable
            Layout.fillHeight: true
            Layout.fillWidth: true
            first.onMoved: {
                mediaPlayer.pause()
                mediaPlayer.setPosition(mediaPlayer.duration * firstVal)
            }
            second.onMoved: {
                mediaPlayer.pause()
                mediaPlayer.setPosition(mediaPlayer.duration * secondVal)
            }
            second.onPressedChanged: {
                if(!second.pressed)
                    mediaPlayer.setPosition(positionStart)
            }
            //-------------------------Customizing the slider--------------------------
            background: Rectangle {
                x: control.leftPadding
                y: control.topPadding + control.availableHeight / 2 + height/2
                implicitWidth: root.width
                implicitHeight: 5
                width: control.availableWidth
                height: implicitHeight
                color: "red"
                clip: true
                Rectangle {
                    id: controlFill
                    x: control.first.visualPosition * parent.width
                    width: control.second.visualPosition * parent.width - x
                    height: parent.height
                }

            }
            first.handle: Rectangle {
                id: controlBegin
                x: control.leftPadding + control.first.visualPosition * (control.availableWidth - width)
                y: control.topPadding + control.availableHeight / 2 - height / 3
                implicitWidth: 3
                implicitHeight: 20
                color: control.first.pressed ? "#f6f6f6" : "white"
            }

            second.handle: Rectangle {
                id: controlEnd
                x: control.leftPadding + control.second.visualPosition * (control.availableWidth - width)
                y: control.topPadding + control.availableHeight / 2 - height / 3
                implicitWidth: 3
                implicitHeight: 20
                color: control.first.pressed ? "#f6f6f6" : "white"

            }

            //-------------------------Customizing the tooltips--------------------------
            ToolTip {
                parent: controlBegin
                visible: control.first.pressed
                y: controlBegin.y + 20
                Text {
                    font.family: "Cascadia Mono"
                    color: "white"
                    text: {
                        var m = Math.floor(positionStart / 60000)
                        var ms = (positionStart / 1000 - m * 60).toFixed(2)
                        return `${m}:${ms.padStart(5, 0)}`
                    }
                }
                background: Rectangle{
                    color: "transparent"
                }
            }
            ToolTip {
                parent: controlEnd
                visible: control.second.pressed
                y: controlEnd.y + 20
                Text {
                    font.family: "Cascadia Mono"
                    color: "white"
                    text: {
                        var m = Math.floor(positionEnd / 60000)
                        var ms = (positionEnd / 1000 - m * 60).toFixed(2)
                        return `${m}:${ms.padStart(5, 0)}`
                    }
                }
                background: Rectangle{
                    color: "transparent"
                }
            }
        }

        SeekSlider {
            id: seekerSlider
            height: control.implicitHeight
            Layout.fillHeight: true
            Layout.fillWidth: true
            mediaPlayer: root.mediaPlayer
        }
    }
}
