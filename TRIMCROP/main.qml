import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia
//-------------Import js utilities
import "qrc:/js/win_utils.js" as WindowUtils
import "qrc:/js/str_utils.js" as StringUtils
//-------------Import qml files
import "qrc:/custom_qml"

ApplicationWindow {
    id: window
    flags: Qt.FramelessWindowHint | Qt.Window
    width: 640
    height: 480
    minimumWidth: 350
    minimumHeight: 350
    visible: true
    title: qsTr("TRIM CROP")
    color: "black"
    property int borderWidth: 4

    Rectangle{
        anchors.fill: parent
        border.color: "black"
        border.width: borderWidth
        color: "transparent"
        z: 5
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY)
            WindowUtils.setCursorShape(p)
        }
        acceptedButtons: Qt.NoButton
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.position;
            WindowUtils.activeResizeEvent(p)
        }
    }

    Page {
        anchors.fill: parent
        anchors.margins: borderWidth
        background: Rectangle{
            anchors.fill: parent
            color: "black"
        }

        header: ToolBar {
            id: toolbar
            background:Rectangle{
                anchors.fill: parent
                color: "white"
            }

            contentHeight: toolButtons.implicitHeight
            Item {
                anchors.fill: parent
                DragHandler {
                    grabPermissions: TapHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { window.startSystemMove(); }
                }
            }

            RowLayout {
                anchors.centerIn: parent
                Text {
                    id: title
                    text: "TRIM CROP"
                    font.family: "Cascadia Mono"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    Layout.alignment: Qt.AlignCenter
                }
                Text {
                    id: activeFile
                    font.family: "Cascadia Mono"
                    font.pixelSize: Qt.application.font.pixelSize
                    Layout.alignment: Qt.AlignCenter
                }
            }

            RowLayout {
                id: toolButtons
                spacing: 0
                anchors.right: parent.right
                anchors.rightMargin: - 5
                ToolButton {
                    contentItem: Text {
                        text: "🗕"
                        opacity: parent.hovered ? 1.0 : 0.5
                        scale: parent.hovered? 1.1 : 1
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle{
                        border.color: "transparent"
                    }

                    onClicked: window.showMinimized()
                }
                ToolButton {
                    contentItem: Text {
                        text: window.visibility === Window.Windowed ? "🗖" : "🗗"
                        opacity: parent.hovered ? 1.0 : 0.5
                        scale: parent.hovered? 1.1 : 1
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle{
                        border.color: "transparent"
                    }
                    onClicked: WindowUtils.toggleMaximized()
                }
                ToolButton {
                    contentItem: Text {
                        text: "🗙"
                        opacity: parent.hovered ? 1.0 : 0.5
                        scale: parent.hovered? 1.1 : 1
                        color: parent.hovered ? "red" : "black"
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle{
                        border.color: "transparent"
                    }
                    onClicked: window.close()
                }

            }
        }
        Item{
            anchors.fill: parent
            Button {
                id: openFile
                anchors.centerIn: parent
                height: 20
                textFormat.text: "open file"
                textFormat.font.family: "Cascadia Mono"
                onClicked: fileDialog.open()
                visible: !controls.visible
            }
            FileDialog {
                id: fileDialog
                currentFolder: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]

                onAccepted: {
                    controls.visible = true
                    cropArea.visible = true
                    mediaPlayer.source = currentFile
                    mediaPlayer.play()
                }
            }

            MediaPlayer{
                id: mediaPlayer
                videoOutput: videoOutput
                audioOutput: audioOutput
                loops: MediaPlayer.Infinite
                onSourceChanged: {
                    if(mediaPlayer.mediaStatus === MediaPlayer.NoMedia)
                        activeFile.text = ""
                    else
                        activeFile.text = "[" + StringUtils.getFileName(mediaPlayer.source) + "]"
                }
            }

            AudioOutput {
                id: audioOutput
                volume: controls.volume
                muted: controls.muted
            }

           Item{
                anchors.left: parent.left
                anchors.right: parent.right
                height: window.height - controls.height - toolbar.height - 10
                anchors.margins: 15
                VideoOutput {
                    id: videoOutput
                    anchors.centerIn: parent
                    scale: parent.width/contentRect.width
                }
            }
            CropROI {
                id: cropArea
                parent: videoOutput
                property real thicknessScalar: videoOutput.contentRect.width/100
                visible: false
                thickness: 1.5 * thicknessScalar
                extendLength: 5 * thicknessScalar
                border.width: .6 * thicknessScalar
                border.color: "#ee000000"
            }

            PlaybackController {
                id: controls
                visible: false
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                mediaPlayer: mediaPlayer
                area: cropArea
            }
        }
        Page{
            id: progressContainer
            anchors.fill: parent
            anchors.margins: 5
            visible: false
            background: Rectangle{
                color: "#dd000000"
                border.color: "#eeffffff"
                border.width: 2
            }
            ColumnLayout{
                anchors.fill: parent
                spacing: 10
                Item {Layout.fillHeight: true}
                Text {
                    id: progressText
                    property string percentage
                    color: "white"
                    font.family: "Cascadia Mono"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    text: percentage + " % completed"
                    Layout.alignment: Qt.AlignHCenter
                }
                ProgressBar{
                    Layout.alignment: Qt.AlignHCenter
                    id: progressBar
                    from: 0.0
                    to: 1.0
                    background: Rectangle {
                           implicitWidth: 200
                           implicitHeight: 15
                           color: "transparent"
                           radius: 3
                           border.color: "white"
                           border.width: 2
                    }
                    contentItem: Item{
                        implicitWidth: 200
                        implicitHeight: 15
                        Rectangle{
                            width: progressBar.visualPosition * parent.width
                            height: parent.height
                            radius: 3
                            color: "white"
                            opacity: (progressBar.value + 1)/2
                        }
                    }
                }
                Item {Layout.fillHeight: true}
            }
        }
    }
}
