QT += quick

SOURCES += \
        main.cpp

resources.files = main.qml 
resources.prefix = /$${TARGET}
RESOURCES += resources \
    resource.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    TRIM_CROP.ico \
    custom_qml/AudioSlider.qml \
    custom_qml/Button.qml \
    custom_qml/CropROI.qml \
    custom_qml/Edge.qml \
    custom_qml/PlaybackController.qml \
    custom_qml/SeekSlider.qml \
    custom_qml/SeekerSlider.qml \
    custom_qml/TrimSlider.qml \
    js/str_utils.js \
    js/win_utils.js \
    svg/pause-outline.svg \
    svg/play-outline.svg \
    svg/sound-min.svg \
    svg/sound-off.svg

RC_ICONS = TRIM_CROP.ico
