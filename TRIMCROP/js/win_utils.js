//---------------------Toggle window state-----------------------
function toggleMaximized() {
    if (window.visibility === Window.Windowed)
        window.showMaximized();
    else
        window.showNormal();
}

//---------------Cursor shape on window edge hover---------------
function setCursorShape(p){
    const b = 25;
    if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
    if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
    if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
    if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
    if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
    if (p.y < b || p.y >= height - b) return Qt.SizeVerCursor;
}

//----------------Handle window resizing event-------------------
function activeResizeEvent(p){
    const b = 25;
    let e = 0;
    if (p.x < b) { e |= Qt.LeftEdge }
    if (p.x >= width - b) { e |= Qt.RightEdge }
    if (p.y < b) { e |= Qt.TopEdge }
    if (p.y >= height - b) { e |= Qt.BottomEdge }
    window.startSystemResize(e);
}
