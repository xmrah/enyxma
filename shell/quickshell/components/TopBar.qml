import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import ".." as Root

PanelWindow {
    id: barWindow

    // Ekranın en üstüne yerleşir
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 44
    color: "transparent"

    // Wayland katman ayarları
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // Dış sinyaller (Launcher ve ControlCenter tetikleyicileri)
    signal openLauncher()
    signal toggleControlCenter()

    // Ana Bar Gövdesi (Yarı saydam cam efekti ve ince sınır)
    Rectangle {
        id: barContainer
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 2
        anchors.leftMargin: 8
        anchors.rightMargin: 8

        radius: Root.Theme.radiusMedium
        color: Qt.rgba(Root.Theme.surface.r, Root.Theme.surface.g, Root.Theme.surface.b, 0.88)
        border.color: Root.Theme.border
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 12

            // -----------------------------------------------------------------
            // SOL: Logo & Uygulama Başlatıcı Düğmesi
            // -----------------------------------------------------------------
            Rectangle {
                id: launcherBtn
                Layout.preferredWidth: 32
                Layout.preferredHeight: 30
                radius: Root.Theme.radiusSmall
                color: launcherBtnHover.hovered ? Root.Theme.surfaceHover : "transparent"
                border.color: launcherBtnHover.hovered ? Root.Theme.accent : "transparent"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "λ"
                    font.family: Root.Theme.fontMono
                    font.bold: true
                    font.pixelSize: 16
                    color: Root.Theme.accent
                }

                HoverHandler { id: launcherBtnHover }
                TapHandler { onTapped: barWindow.openLauncher() }
            }

            // -----------------------------------------------------------------
            // SOL-ORTA: Hyprland Çalışma Alanları (Workspaces 1 - 8)
            // -----------------------------------------------------------------
            Row {
                id: workspaceRow
                Layout.alignment: Qt.AlignVCenter
                spacing: 6

                Repeater {
                    model: 8

                    Rectangle {
                        id: wsIndicator
                        property int wsId: index + 1
                        property bool isFocused: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === wsId

                        width: isFocused ? 28 : 22
                        height: 22
                        radius: Root.Theme.radiusSmall

                        color: isFocused ? Root.Theme.accent : (wsHover.hovered ? Root.Theme.surfaceHover : Qt.rgba(Root.Theme.surface.r, Root.Theme.surface.g, Root.Theme.surface.b, 0.5))
                        border.color: isFocused ? Root.Theme.accentHover : Root.Theme.border
                        border.width: 1

                        Behavior on width {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: wsIndicator.wsId.toString()
                            font.family: Root.Theme.fontMono
                            font.bold: wsIndicator.isFocused
                            font.pixelSize: 11
                            color: wsIndicator.isFocused ? (Root.Theme.isDark ? "#000000" : "#ffffff") : Root.Theme.textMuted
                        }

                        HoverHandler { id: wsHover }
                        TapHandler {
                            onTapped: Hyprland.dispatch("workspace " + wsIndicator.wsId)
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // ORTA: Aktif Pencere Başlığı
            // -----------------------------------------------------------------
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    anchors.centerIn: parent
                    width: Math.min(implicitWidth, parent.width - 40)
                    elide: Text.ElideMiddle
                    text: (Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.lastwindowtitle) ? Hyprland.focusedWorkspace.lastwindowtitle : "enyxma workspace"
                    font.family: Root.Theme.fontFamily
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: Root.Theme.text
                }
            }

            // -----------------------------------------------------------------
            // SAĞ: Tema İndikatörü + Saat & Tarih + Kontrol Merkezi Düğmesi
            // -----------------------------------------------------------------
            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 10

                // Tema Rozeti (Aktif temayı gösterir, tıklandığında temaları sırayla gezer)
                Rectangle {
                    id: themeBadge
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: themeRow.implicitWidth + 14
                    radius: Root.Theme.radiusSmall
                    color: themeHover.hovered ? Root.Theme.surfaceHover : "transparent"
                    border.color: Root.Theme.border
                    border.width: 1

                    Row {
                        id: themeRow
                        anchors.centerIn: parent
                        spacing: 6

                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            anchors.verticalCenter: parent.verticalCenter
                            color: Root.Theme.accent
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: Root.Theme.activePalette.name
                            font.family: Root.Theme.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: Root.Theme.text
                        }
                    }

                    HoverHandler { id: themeHover }
                    TapHandler {
                        onTapped: {
                            var keys = Object.keys(Root.Theme.palettes);
                            var idx = keys.indexOf(Root.Theme.currentTheme);
                            var nextIdx = (idx + 1) % keys.length;
                            Root.Theme.applyTheme(keys[nextIdx]);
                        }
                    }
                }

                // Saat ve Tarih
                Rectangle {
                    Layout.preferredHeight: 24
                    Layout.preferredWidth: clockText.implicitWidth + 16
                    radius: Root.Theme.radiusSmall
                    color: Qt.rgba(Root.Theme.surfaceHover.r, Root.Theme.surfaceHover.g, Root.Theme.surfaceHover.b, 0.4)

                    Text {
                        id: clockText
                        anchors.centerIn: parent
                        text: Qt.formatDateTime(new Date(), "ddd dd MMM  HH:mm")
                        font.family: Root.Theme.fontMono
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: Root.Theme.text
                    }

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd dd MMM  HH:mm")
                    }
                }

                // Kontrol Merkezi Düğmesi
                Rectangle {
                    id: ccBtn
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 28
                    radius: Root.Theme.radiusSmall
                    color: ccHover.hovered ? Root.Theme.accent : Root.Theme.surfaceHover
                    border.color: Root.Theme.border
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "⚙"
                        font.pixelSize: 13
                        color: ccHover.hovered ? (Root.Theme.isDark ? "#000000" : "#ffffff") : Root.Theme.text
                    }

                    HoverHandler { id: ccHover }
                    TapHandler { onTapped: barWindow.toggleControlCenter() }
                }
            }
        }
    }
}
