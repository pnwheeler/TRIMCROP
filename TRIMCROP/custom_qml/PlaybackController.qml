import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia
import Process 1.0
import "qrc:/js/str_utils.js" as StringUtils
import "qrc:/custom_qml"

Item {
    id: root
    required property MediaPlayer mediaPlayer
    required property CropROI area
    property int mediaPlayerState: mediaPlayer.playbackState
    property alias muted: audioOutput.muted
    property alias volume: audioOutput.volume
    property alias start: trimSlider.positionStart
    property alias end: trimSlider.positionEnd
    property int clip_duration_ms

    height: frame.height

    Frame {
        id: frame
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        background: Rectangle {
            id: bgRect
            color: "blue"
        }

        ColumnLayout {
            id: controlPanel
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5

            TrimSlider {
                id: trimSlider
                Layout.topMargin: 5
                Layout.fillWidth: true
                mediaPlayer: root.mediaPlayer
                bgColor: bgRect.color
            }

            RowLayout {
                id: playerButtons
                Layout.fillWidth: true
                AudioSlider {
                    id: audioOutput
                    Layout.preferredWidth: 100
                    mediaPlayer: root.mediaPlayer
                }

                Item {Layout.fillWidth: true}

                RoundButton {
                    id: playPauseButton
                    Layout.rightMargin: 35
                    property bool playing: trimSlider.playing
                    radius: 60
                    icon.width: radius
                    icon.height: radius
                    icon.source: playing ? "qrc:/svg/pause-outline.svg" : "qrc:/svg/play-outline.svg"
                    hoverEnabled: true
                    scale: hovered ? 1.1 : 1
                    background: Rectangle { color: "transparent" }
                    onClicked: playing ? mediaPlayer.pause() : mediaPlayer.play()
                }

                Item {Layout.fillWidth: true}

                Button {
                    id: closeButton
                    Layout.rightMargin: 20
                    textFormat.text: "close"
                    textFormat.font.family: "Cascadia Mono"
                    onClicked: {
                        saveButton.visible = true
                        mediaPlayer.stop()
                        root.visible = false;
                        area.visible = false;
                        activeFile.text = ""
                    }
                }

            }
            Button {
                id: saveButton
                Layout.alignment: Qt.AlignCenter
                textFormat.text: "save clip"
                textFormat.font.family: "Cascadia Mono"
                textFormat.font.pixelSize: 20
                textFormat.font.bold: true
                textFormat.font.capitalization: Font.AllUppercase
                onClicked: {
                    if (mediaPlayer.playbackState === MediaPlayer.PlayingState)
                        mediaPlayer.pause()
                    saveFile.open()
                }
            }
        }
    }

    FileDialog {
        id: openFile
        currentFolder: mediaPlayer.source
        onAccepted: {
            mediaPlayer.stop()
            mediaPlayer.source = currentFile
            mediaPlayer.play()
        }
    }

    Process {
        id: process
        onReadyReadStandardError: {
            console.log(readAllStandardError())
        }
        onReadyReadStandardOutput: {
            let progress_info = StringUtils.parse_stats(readAllStandardOutput())
            let normalized_pos = Math.floor(Number(progress_info.curr_pos)/1000)/clip_duration_ms
            progressBar.value = normalized_pos
            progressText.percentage = Math.floor(normalized_pos * 100).toString()
        }
        onStarted: {
            progressContainer.visible = true
        }
        onFinished: {
            progressContainer.visible = false
            mediaPlayer.source = saveFile.currentFile
            mediaPlayer.play()
        }

    }

    FileDialog {
        id: saveFile
        currentFolder: mediaPlayer.source
        fileMode: FileDialog.SaveFile
        nameFilters: ["mp4 (*.mp4)", "avi (*.avi)", "mkv (*.mkv)", "flv (*.flv)", "webm (*.webm)", "mov (*.mov)", "wmv (*.wmv)"]
        onAccepted: {
            clip_duration_ms = end - start
            mediaPlayer.stop()
            saveButton.visible = false
            let ffmpeg_command = StringUtils.config_ffmpeg_args(mediaPlayer.source, currentFile, start, clip_duration_ms, area.width, area.height, area.x, area.y);
            process.start("ffmpeg", ffmpeg_command)
            area.visible = false
        }
    }
}


