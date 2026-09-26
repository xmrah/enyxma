import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import ".." as Root

PanelWindow {
    id: launcherWindow

    // Ekranı kaplayan yarı saydam arayüz
    anchors.fill: parent
    color: "transparent"
    visible: false

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Aç / Kapa mantığı
    function open(): void {
        visible = true;
        searchInput.text = "";
        searchInput.forceActiveFocus();
    }

    function close(): void {
        visible = false;
    }

    function toggle(): void {
        if (visible) close();
        else open();
    }

    // Harici IPC İşleyicisi
    // quickshell ipc call launcher toggle
    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcherWindow.toggle();
        }

        function open(): void {
            launcherWindow.open();
        }

        function close(): void {
            launcherWindow.close();
        }
    }

    // Dış alana tıklanınca kapat
    MouseArea {
        anchors.fill: parent
        onClicked: launcherWindow.close()
    }

    // ESC tuşuyla kapatma
    Item {
        focus: true
        Keys.onEscapePressed: launcherWindow.close()
    }

    // Başlatıcı Kartı
    Rectangle {
        id: dialogCard
        width: 520
        height: 400
        anchors.centerIn: parent

        radius: Root.Theme.radiusLarge
        color: Qt.rgba(Root.Theme.surface.r, Root.Theme.surface.g, Root.Theme.surface.b, 0.95)
        border.color: Root.Theme.accent
        border.width: 1

        // Kart içine tıklamaların arka plana geçmesini engelle
        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            // Arama Kutusu
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                radius: Root.Theme.radiusMedium
                color: Root.Theme.surfaceHover
                border.color: searchInput.activeFocus ? Root.Theme.accent : Root.Theme.border
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    spacing: 10

                    Text {
                        text: "🔍"
                        font.pixelSize: 14
                    }

                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        font.family: Root.Theme.fontFamily
                        font.pixelSize: 14
                        color: Root.Theme.text
                        clip: true

                        Text {
                            anchors.fill: parent
                            text: "Uygulama veya komut ara..."
                            font.family: Root.Theme.fontFamily
                            font.pixelSize: 14
                            color: Root.Theme.textMuted
                            visible: !searchInput.text && !searchInput.inputMethodComposing
                        }

                        Keys.onReturnPressed: {
                            if (filteredApps.count > 0) {
                                launcherWindow.launch(filteredApps.get(0).exec);
                            }
                        }

                        Keys.onEscapePressed: launcherWindow.close()
                    }
                }
            }

            // Uygulama Listesi
            ListView {
                id: appList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 4

                model: ListModel {
                    id: filteredApps
                }

                delegate: Rectangle {
                    required property string name
                    required property string desc
                    required property string icon
                    required property string exec

                    width: appList.width
                    height: 48
                    radius: Root.Theme.radiusSmall
                    color: itemHover.hovered ? Root.Theme.surfaceHover : "transparent"
                    border.color: itemHover.hovered ? Root.Theme.border : "transparent"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 12

                        Text {
                            text: icon
                            font.pixelSize: 18
                            Layout.alignment: Qt.AlignVCenter
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Layout.alignment: Qt.AlignVCenter

                            Text {
                                text: name
                                font.family: Root.Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                                color: Root.Theme.text
                            }

                            Text {
                                text: desc
                                font.family: Root.Theme.fontFamily
                                font.pixelSize: 11
                                color: Root.Theme.textMuted
                            }
                        }
                    }

                    HoverHandler { id: itemHover }
                    TapHandler {
                        onTapped: launcherWindow.launch(exec)
                    }
                }
            }
        }
    }

    // Uygulamaları çalıştır ve menüyü kapat
    function launch(cmd: string): void {
        close();
        if (typeof Hyprland !== "undefined") {
            Hyprland.dispatch("exec " + cmd);
        }
    }

    // Dahili Uygulama Veritabanı
    readonly property var allApps: [
        { name: "Sistem Kurulumu", desc: "enyxma canlı kurulum sihirbazı", icon: "🚀", exec: "kitty --title 'enyxma installer' enyxma-install" },
        { name: "Terminal", desc: "Kitty GPU hızlandırmalı uçbirim", icon: "💻", exec: "kitty" },
        { name: "Dosya Yöneticisi", desc: "Sistem dosyalarını tara", icon: "📁", exec: "thunar || dolphin" },
        { name: "Sistem Monitörü", desc: "btop donanım ve süreç izleyici", icon: "📊", exec: "kitty -e btop" },
        { name: "Web Tarayıcısı", desc: "Güvenli ve hızlı internet", icon: "🌐", exec: "firefox" },
        { name: "Metin & Kod Editörü", desc: "Helix modal terminal editörü", icon: "📝", exec: "kitty -e hx" },
        { name: "Siber Güvenlik Shell", desc: "İzole analiz ortamı", icon: "🛡️", exec: "kitty" },
        { name: "Ses Mikseri", desc: "Pavucontrol ses çıkış ayarları", icon: "🔊", exec: "pavucontrol" }
    ]

    // Arama filtrelemesi
    function filterApps(query: string): void {
        filteredApps.clear();
        var q = query.toLowerCase().trim();
        for (var i = 0; i < allApps.length; i++) {
            var app = allApps[i];
            if (!q || app.name.toLowerCase().indexOf(q) !== -1 || app.desc.toLowerCase().indexOf(q) !== -1 || app.exec.toLowerCase().indexOf(q) !== -1) {
                filteredApps.append(app);
            }
        }
    }

    Component.onCompleted: filterApps("")
    Connections {
        target: searchInput
        function onTextChanged() {
            launcherWindow.filterApps(searchInput.text);
        }
    }
}
