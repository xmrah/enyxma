import QtQuick
import Quickshell
import "./components" as Comp

ShellRoot {
    id: root

    // Tüm bağlı ekranlar için TopBar türet
    Variants {
        model: Quickshell.screens

        delegate: Comp.TopBar {
            property var modelData
            screen: modelData

            onOpenLauncher: appLauncher.toggle()
            onToggleControlCenter: controlCenter.toggle()
        }
    }

    // Uygulama Başlatıcı (Super+Space veya Bar'dan tetiklenir)
    Comp.AppLauncher {
        id: appLauncher
    }

    // Kontrol Merkezi (Super+I veya Bar'dan tetiklenir)
    Comp.ControlCenter {
        id: controlCenter
    }

    // On-Screen Display (Ses ve parlaklık göstergesi)
    Comp.OSD {
        id: osd
    }
}
