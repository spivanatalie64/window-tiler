/*
 * WindowTiler - Custom decoration with directional snap buttons
 * Right: Close, Minimize, Maximize
 * Left: Up, Down, Left, Right (tile directions)
 */
import QtQuick
import org.kde.kwin.decoration

Decoration {
    id: root
    property bool animate: false
    Component.onCompleted: {
        borders.left   = 28;
        borders.right  = 28;
        borders.top    = 32;
        borders.bottom = 28;
        maximizedBorders.left   = 0;
        maximizedBorders.right  = 0;
        maximizedBorders.top    = 0;
        maximizedBorders.bottom = 0;
        padding.left   = 0;
        padding.right  = 0;
        padding.bottom = 0;
        padding.top    = 0;
        root.animate = true;
    }

    // Title bar background
    Rectangle {
        id: titleBar
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: decoration.client.maximized ? 32 : 0
        visible: decoration.client.maximized
        color: decoration.client.active ? "#2980b9" : "#2c3e50"
        Behavior on color {
            ColorAnimation { duration: root.animate ? 150 : 0 }
        }
    }

    Rectangle {
        id: titleBorder
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: 0
            rightMargin: 0
            topMargin: 0
        }
        height: decoration.client.maximized ? 0 : 32
        visible: !decoration.client.maximized
        color: decoration.client.active ? "#2980b9" : "#2c3e50"
        Behavior on color {
            ColorAnimation { duration: root.animate ? 150 : 0 }
        }
    }

    // BORDER
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: 4
        color: decoration.client.active ? "#3498db" : "#34495e"
        visible: !decoration.client.maximized
        Behavior on color {
            ColorAnimation { duration: root.animate ? 150 : 0 }
        }
    }
    Rectangle {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: 4
        color: decoration.client.active ? "#3498db" : "#34495e"
        visible: !decoration.client.maximized
        Behavior on color {
            ColorAnimation { duration: root.animate ? 150 : 0 }
        }
    }
    Rectangle {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: 4
        color: decoration.client.active ? "#3498db" : "#34495e"
        visible: !decoration.client.maximized
        Behavior on color {
            ColorAnimation { duration: root.animate ? 150 : 0 }
        }
    }

    // Title text (in the middle)
    Text {
        id: caption
        text: decoration.client.caption
        color: decoration.client.active ? "#ffffff" : "#bdc3c7"
        font.pixelSize: 12
        font.bold: true
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors {
            left: leftButtons.right
            right: rightButtons.left
            top: parent.top
            bottom: parent.top
        }
        height: 32
        anchors.topMargin: 0
        leftPadding: 8
        rightPadding: 8
        Behavior on color {
            ColorAnimation { duration: root.animate ? 150 : 0 }
        }
    }

    // ---- LEFT BUTTONS: Directional Tiling ----
    Item {
        id: leftButtons
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 4
        }
        height: 32
        width: childrenRect.width

        Row {
            spacing: 2
            height: 32

            // Snap Up
            DirectionButton {
                label: "\u25B2"
                tooltip: "Tile to top half"
                enabled: decoration.client.maximizeable
                onClicked: workspace.slotWindowTile(decoration.client, 1) // Up
            }

            // Snap Down
            DirectionButton {
                label: "\u25BC"
                tooltip: "Tile to bottom half"
                enabled: decoration.client.maximizeable
                onClicked: workspace.slotWindowTile(decoration.client, 2) // Down
            }

            // Snap Left
            DirectionButton {
                label: "\u25C0"
                tooltip: "Tile to left half"
                enabled: decoration.client.maximizeable
                onClicked: workspace.slotWindowTile(decoration.client, 3) // Left
            }

            // Snap Right
            DirectionButton {
                label: "\u25B6"
                tooltip: "Tile to right half"
                enabled: decoration.client.maximizeable
                onClicked: workspace.slotWindowTile(decoration.client, 4) // Right
            }
        }
    }

    // ---- RIGHT BUTTONS: Close, Minimize, Maximize ----
    Item {
        id: rightButtons
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 4
        }
        height: 32
        width: childrenRect.width

        Row {
            spacing: 2
            height: 32

            // Minimize
            ActionButton {
                label: "\u2014"
                tooltip: "Minimize"
                enabled: decoration.client.minimizeable
                onClicked: decoration.requestMinimize()
            }

            // Maximize/Restore
            ActionButton {
                label: decoration.client.maximized ? "\u25A1" : "\u25A3"
                tooltip: decoration.client.maximized ? "Restore" : "Maximize"
                enabled: decoration.client.maximizeable
                onClicked: decoration.requestToggleMaximization(Qt.LeftButton)
            }

            // Close
            ActionButton {
                label: "\u2715"
                tooltip: "Close"
                enabled: decoration.client.closeable
                labelColor: "#e74c3c"
                onClicked: decoration.requestClose()
            }
        }
    }

    // Custom Direction Button component
    component DirectionButton: Item {
        property string label
        property string tooltip
        property bool hovered: false
        property bool pressed: false
        signal clicked()

        width: 26
        height: 26

        Rectangle {
            anchors.fill: parent
            radius: 3
            color: pressed ? "#1a5276" : (hovered ? "#2c3e50" : "transparent")
            border.color: hovered ? "#3498db" : "transparent"
            border.width: 1
        }

        Text {
            anchors.centerIn: parent
            text: label
            color: decoration.client.active ? "#ecf0f1" : "#95a5a6"
            font.pixelSize: 12
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: hovered = true
            onExited: hovered = false
            onPressed: pressed = true
            onReleased: { pressed = false; clicked() }
        }
    }

    // Standard Action Button component
    component ActionButton: Item {
        property string label
        property string tooltip
        property bool hovered: false
        property bool pressed: false
        property color labelColor: "#ecf0f1"
        signal clicked()

        width: 26
        height: 26

        Rectangle {
            anchors.fill: parent
            radius: 3
            color: pressed ? "#1a5276" : (hovered ? "#2c3e50" : "transparent")
            border.color: hovered ? "#3498db" : "transparent"
            border.width: 1
        }

        Text {
            anchors.centerIn: parent
            text: label
            color: labelColor
            font.pixelSize: 12
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: hovered = true
            onExited: hovered = false
            onPressed: pressed = true
            onReleased: { pressed = false; clicked() }
        }
    }
}
