import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import ".." as Root

PanelWindow {
    id: osdWindow

    // Ekranın alt orta kısmına konumlanır
    anchors {
        bottom: true
    }

    implicitWidth: 260
    implicitHeight: 90
    color: "transparent"
    visible: false

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    property string icon: "🔊"
    property string title: "Ses Seviyesi"
    property real level: 0.5

    function showOsd(newIcon: string, newTitle: string, newLevel: real): void {
        icon = newIcon;
        title = newTitle;
        level = newLevel;
        visible = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 1600
        repeat: false
        onTriggered: osdWindow.visible = false
    }

    // Harici IPC İşleyicisi
    // quickshell ipc call osd notifyVolume
    IpcHandler {
        target: "osd"

        function notifyVolume(): void {
            osdWindow.showOsd("🔊", "Ses Seviyesi", Math.min(1.0, osdWindow.level + 0.05));
        }

        function notifyBrightness(): void {
            osdWindow.showOsd("☀️", "Ekran Parlaklığı", 0.7);
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 30
        anchors.leftMargin: 20
        anchors.rightMargin: 20

        radius: Root.Theme.radiusMedium
        color: Qt.rgba(Root.Theme.surface.r, Root.Theme.surface.g, Root.Theme.surface.b, 0.92)
        border.color: Root.Theme.border
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            Text {
                text: osdWindow.icon
                font.pixelSize: 20
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: osdWindow.title
                    font.family: Root.Theme.fontFamily
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: Root.Theme.text
                }

                // Gösterge Çubuğu (Progress bar)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 6
                    radius: 3
                    color: Root.Theme.surfaceHover

                    Rectangle {
                        height: parent.height
                        width: parent.width * osdWindow.level
                        radius: 3
                        color: Root.Theme.accent

                        Behavior on width {
                            NumberAnimation { duration: 100 }
                        }
                    }
                }
            }
        }
    }
}
