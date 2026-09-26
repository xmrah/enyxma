import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import ".." as Root

PanelWindow {
    id: ccWindow

    // Ekranın sağ üst köşesine, barın hemen altına hizalanır
    anchors {
        top: true
        right: true
    }

    implicitWidth: 350
    implicitHeight: 480
    color: "transparent"
    visible: false

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    function open(): void { visible = true; }
    function close(): void { visible = false; }
    function toggle(): void { visible = !visible; }

    // IPC İşleyicisi
    // quickshell ipc call controlCenter toggle
    IpcHandler {
        target: "controlCenter"

        function toggle(): void {
            ccWindow.toggle();
        }

        function open(): void {
            ccWindow.open();
        }

        function close(): void {
            ccWindow.close();
        }

        function openPower(): void {
            ccWindow.open();
        }
    }

    // Kart Gövdesi
    Rectangle {
        id: card
        anchors.fill: parent
        anchors.topMargin: 46
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        anchors.leftMargin: 8

        radius: Root.Theme.radiusLarge
        color: Qt.rgba(Root.Theme.surface.r, Root.Theme.surface.g, Root.Theme.surface.b, 0.95)
        border.color: Root.Theme.border
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14

            // -----------------------------------------------------------------
            // BAŞLIK
            // -----------------------------------------------------------------
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Kontrol Merkezi"
                    font.family: Root.Theme.fontFamily
                    font.pixelSize: 15
                    font.bold: true
                    color: Root.Theme.text
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 26
                    height: 26
                    radius: Root.Theme.radiusSmall
                    color: closeHover.hovered ? Root.Theme.surfaceHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 12
                        color: Root.Theme.textMuted
                    }

                    HoverHandler { id: closeHover }
                    TapHandler { onTapped: ccWindow.close() }
                }
            }

            // -----------------------------------------------------------------
            // TEMA EKOSİSTEMİ SEÇİCİ (5 SEÇKİN PALET)
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "TEMA PALETİ"
                    font.family: Root.Theme.fontMono
                    font.pixelSize: 11
                    font.bold: true
                    color: Root.Theme.accent
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 6
                    columnSpacing: 6

                    Repeater {
                        model: [
                            { id: "void-black",   name: "Void Black",   accent: "#00e5ff", bg: "#0a0a0c" },
                            { id: "cyber-matrix", name: "Cyber Matrix", accent: "#00ff66", bg: "#050c08" },
                            { id: "ghost-white",  name: "Ghost White",  accent: "#0052cc", bg: "#f5f7fa" },
                            { id: "slate-cobalt", name: "Slate Cobalt", accent: "#2d7ff9", bg: "#0d131a" },
                            { id: "blood-amber",  name: "Blood Amber",  accent: "#ff4d00", bg: "#100808" }
                        ]

                        Rectangle {
                            required property string id
                            required property string name
                            required property string accent
                            required property string bg

                            property bool isSelected: Root.Theme.currentTheme === id

                            Layout.fillWidth: true
                            Layout.preferredHeight: 34
                            radius: Root.Theme.radiusSmall
                            color: isSelected ? Root.Theme.surfaceHover : (themeBtnHover.hovered ? Root.Theme.surfaceHover : "transparent")
                            border.color: isSelected ? Root.Theme.accent : Root.Theme.border
                            border.width: isSelected ? 2 : 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 8

                                Rectangle {
                                    width: 14
                                    height: 14
                                    radius: 7
                                    color: accent
                                    border.color: Root.Theme.border
                                    border.width: 1
                                }

                                Text {
                                    text: name
                                    Layout.fillWidth: true
                                    font.family: Root.Theme.fontFamily
                                    font.pixelSize: 11
                                    font.weight: isSelected ? Font.DemiBold : Font.Normal
                                    color: Root.Theme.text
                                    elide: Text.ElideRight
                                }
                            }

                            HoverHandler { id: themeBtnHover }
                            TapHandler {
                                onTapped: Root.Theme.applyTheme(id)
                            }
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // SES VE AYAR KONTROLLERİ
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "SİSTEM DÜZEYLERİ"
                    font.family: Root.Theme.fontMono
                    font.pixelSize: 11
                    font.bold: true
                    color: Root.Theme.accent
                }

                // Ses Kontrol Kartı
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    radius: Root.Theme.radiusSmall
                    color: Root.Theme.surfaceHover
                    border.color: Root.Theme.border
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10

                        Text {
                            text: "🔊"
                            font.pixelSize: 13
                        }

                        Text {
                            text: "Ses Çıkışı"
                            font.family: Root.Theme.fontFamily
                            font.pixelSize: 12
                            color: Root.Theme.text
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            width: 28
                            height: 24
                            radius: 4
                            color: Root.Theme.surface
                            border.color: Root.Theme.border
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "−"
                                font.bold: true
                                color: Root.Theme.text
                            }

                            TapHandler {
                                onTapped: {
                                    if (typeof Hyprland !== "undefined") {
                                        Hyprland.dispatch("exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-");
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: 28
                            height: 24
                            radius: 4
                            color: Root.Theme.surface
                            border.color: Root.Theme.border
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "+"
                                font.bold: true
                                color: Root.Theme.text
                            }

                            TapHandler {
                                onTapped: {
                                    if (typeof Hyprland !== "undefined") {
                                        Hyprland.dispatch("exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+");
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // -----------------------------------------------------------------
            // GÜÇ VE OTURUM DÜĞMELERİ
            // -----------------------------------------------------------------
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // Kilitle
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: Root.Theme.radiusSmall
                    color: lockHover.hovered ? Root.Theme.surfaceHover : "transparent"
                    border.color: Root.Theme.border
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "🔒"; font.pixelSize: 11; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Kilitle"; font.family: Root.Theme.fontFamily; font.pixelSize: 11; color: Root.Theme.text; anchors.verticalCenter: parent.verticalCenter }
                    }

                    HoverHandler { id: lockHover }
                    TapHandler {
                        onTapped: {
                            ccWindow.close();
                            if (typeof Hyprland !== "undefined") Hyprland.dispatch("exec loginctl lock-session");
                        }
                    }
                }

                // Yeniden Başlat
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: Root.Theme.radiusSmall
                    color: rebootHover.hovered ? Root.Theme.surfaceHover : "transparent"
                    border.color: Root.Theme.border
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "🔄"; font.pixelSize: 11; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Yeniden Başlat"; font.family: Root.Theme.fontFamily; font.pixelSize: 11; color: Root.Theme.text; anchors.verticalCenter: parent.verticalCenter }
                    }

                    HoverHandler { id: rebootHover }
                    TapHandler {
                        onTapped: {
                            ccWindow.close();
                            if (typeof Hyprland !== "undefined") Hyprland.dispatch("exec systemctl reboot");
                        }
                    }
                }

                // Kapat
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: Root.Theme.radiusSmall
                    color: pwrHover.hovered ? Root.Theme.danger : "transparent"
                    border.color: pwrHover.hovered ? Root.Theme.danger : Root.Theme.border
                    border.width: 1

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "⏻"; font.pixelSize: 12; anchors.verticalCenter: parent.verticalCenter; color: pwrHover.hovered ? "#ffffff" : Root.Theme.text }
                        Text { text: "Kapat"; font.family: Root.Theme.fontFamily; font.pixelSize: 11; color: pwrHover.hovered ? "#ffffff" : Root.Theme.text; anchors.verticalCenter: parent.verticalCenter }
                    }

                    HoverHandler { id: pwrHover }
                    TapHandler {
                        onTapped: {
                            ccWindow.close();
                            if (typeof Hyprland !== "undefined") Hyprland.dispatch("exec systemctl poweroff");
                        }
                    }
                }
            }
        }
    }
}
