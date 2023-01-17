import QtQuick
import QtQuick.Controls

Rectangle {
    //Bound to parent
    id: area
    property int maxW: parent.width
    property int maxH: parent.height
    property int thickness
    property int extendLength

    x: maxW / 4
    y: maxH / 4
    width: maxW / 2
    height: maxH / 2
    color: "#55ffffff"

    //Sizing and positioning logic for each edge
    function adjustLeft(mouseVal, maxVal){
        if (area.x + mouseVal < 0)
            return
        if(area.width - mouseVal < 30 && mouseVal > 0)
            return
        area.x += mouseVal
        area.width -= mouseVal
    }

    function adjustRight(mouseVal, maxVal){
        area.width += mouseVal
        if (area.width + area.x > maxVal){
            area.width = maxVal - area.x
        }
        if(area.width < 30)
            area.width = 30
    }

    function adjustTop(mouseVal, maxVal){
        if (area.y + mouseVal < 0)
            return
        if(area.height - mouseVal < 30 && mouseVal > 0)
            return
        area.y += mouseVal
        area.height -= mouseVal
    }

    function adjustBottom(mouseVal, maxVal){
        area.height += mouseVal
        if (area.height + area.y > maxVal){
            area.height = maxVal - area.y
        }
        if(area.height < 30)
            area.height = 30
    }

    MouseArea {
        id: draggableArea
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: "OpenHandCursor"
        drag{
            target: parent
            minimumX: 0
            minimumY: 0
            maximumX: maxW - area.width
            maximumY: maxH - area.height
        }
        onPressed:{
            cursorShape = Qt.ClosedHandCursor
        }
        onReleased: {
            cursorShape = Qt.OpenHandCursor
        }
    }

    Edge {
        id: leftEdge
        widthX: thickness
        widthY: parent.height + extendLength
        anchors {
            horizontalCenter: parent.left
            verticalCenter: parent.verticalCenter
            horizontalCenterOffset: -thickness/2
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: "SizeHorCursor"
            drag{ target: parent; axis: Drag.XAxis }
            onMouseXChanged: {
                if(drag.active){
                    adjustLeft(mouseX, maxW)
                    parent.color = "white"
                }
            }
        }
    }

    Edge {
        id: rightEdge
        widthX: thickness
        widthY: parent.height + extendLength
        anchors {
            horizontalCenter: parent.right
            verticalCenter: parent.verticalCenter
            horizontalCenterOffset: thickness/2
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: "SizeHorCursor"
            drag{ target: parent; axis: Drag.XAxis}
            onMouseXChanged: {
                if(drag.active){
                    adjustRight(mouseX, maxW)
                    parent.color = "white"
                }
            }
        }
    }

    Edge {
        id: topEdge
        widthX: parent.width + extendLength
        widthY: thickness
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.top
            verticalCenterOffset: -thickness/2
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: "SizeVerCursor"
            drag{ target: parent; axis: Drag.YAxis}
            onMouseYChanged: {
                if(drag.active){
                    adjustTop(mouseY, maxH)
                    parent.color = "white"
                }
            }
        }
    }

    Edge {
        id: bottomEdge
        widthX: parent.width + extendLength
        widthY: thickness
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.bottom
            verticalCenterOffset: thickness/2
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: "SizeVerCursor"
            drag{ target: parent; axis: Drag.YAxis}
            onMouseYChanged: {
                if(drag.active){
                    adjustBottom(mouseY, maxH)
                    parent.color = "white"
                }
            }
        }
    }
}
