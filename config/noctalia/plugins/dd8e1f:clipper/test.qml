import QtQuick 2.0

Item {
    Component.onCompleted: {
        console.log("Path: " + Qt.resolvedUrl(".").toString().replace("file://", "") + "notecards")
        Qt.quit()
    }
}
