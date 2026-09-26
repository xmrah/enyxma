pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

QtObject {
    id: root

    // Aktif tema adı
    property string currentTheme: "void-black"

    // Tek doğruluk kaynağından üretilen 5 seçkin tema paleti
    readonly property var palettes: ({
        "void-black": {
            name: "Void Black",
            isDark: true,
            colors: {
                background: "#0a0a0c",
                surface: "#131318",
                surfaceHover: "#1c1c24",
                border: "#262633",
                accent: "#00e5ff",
                accentHover: "#33edff",
                secondary: "#7aa2f7",
                text: "#e0e6ed",
                textMuted: "#79828c",
                danger: "#ff5555",
                success: "#50fa7b",
                warning: "#f1fa8c"
            },
            hyprlandBorder: "rgba(00e5ffee) rgba(262633ee) 45deg"
        },
        "cyber-matrix": {
            name: "Cyber Matrix",
            isDark: true,
            colors: {
                background: "#050c08",
                surface: "#0b1710",
                surfaceHover: "#12261b",
                border: "#1b3827",
                accent: "#00ff66",
                accentHover: "#33ff85",
                secondary: "#00e5a3",
                text: "#dcf5e3",
                textMuted: "#5c8a6b",
                danger: "#ff4444",
                success: "#00ff66",
                warning: "#ffcc00"
            },
            hyprlandBorder: "rgba(00ff66ee) rgba(1b3827ee) 45deg"
        },
        "ghost-white": {
            name: "Ghost White",
            isDark: false,
            colors: {
                background: "#f5f7fa",
                surface: "#ffffff",
                surfaceHover: "#ebf0f5",
                border: "#d5dbe3",
                accent: "#0052cc",
                accentHover: "#0065ff",
                secondary: "#2684ff",
                text: "#172b4d",
                textMuted: "#6b778c",
                danger: "#de350b",
                success: "#36b37e",
                warning: "#ffab00"
            },
            hyprlandBorder: "rgba(0052ccee) rgba(d5dbe3ee) 45deg"
        },
        "slate-cobalt": {
            name: "Slate Cobalt",
            isDark: true,
            colors: {
                background: "#0d131a",
                surface: "#151e29",
                surfaceHover: "#1d2a3a",
                border: "#283b52",
                accent: "#2d7ff9",
                accentHover: "#579aff",
                secondary: "#60a5fa",
                text: "#e2e8f0",
                textMuted: "#8092a8",
                danger: "#ef4444",
                success: "#10b981",
                warning: "#f59e0b"
            },
            hyprlandBorder: "rgba(2d7ff9ee) rgba(283b52ee) 45deg"
        },
        "blood-amber": {
            name: "Blood Amber",
            isDark: true,
            colors: {
                background: "#100808",
                surface: "#1a0f0f",
                surfaceHover: "#261515",
                border: "#3b2020",
                accent: "#ff4d00",
                accentHover: "#ff7033",
                secondary: "#ff8533",
                text: "#fce8e6",
                textMuted: "#8f6e6d",
                danger: "#ff2200",
                success: "#4ade80",
                warning: "#facc15"
            },
            hyprlandBorder: "rgba(ff4d00ee) rgba(3b2020ee) 45deg"
        }
    })

    // Aktif temanın reaktif renk özellikleri
    readonly property var activePalette: palettes[currentTheme] || palettes["void-black"]
    readonly property color background: activePalette.colors.background
    readonly property color surface: activePalette.colors.surface
    readonly property color surfaceHover: activePalette.colors.surfaceHover
    readonly property color border: activePalette.colors.border
    readonly property color accent: activePalette.colors.accent
    readonly property color accentHover: activePalette.colors.accentHover
    readonly property color secondary: activePalette.colors.secondary
    readonly property color text: activePalette.colors.text
    readonly property color textMuted: activePalette.colors.textMuted
    readonly property color danger: activePalette.colors.danger
    readonly property color success: activePalette.colors.success
    readonly property color warning: activePalette.colors.warning
    readonly property bool isDark: activePalette.isDark

    // Tipografi ve Geometri Token'ları
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 16
    readonly property string fontFamily: "Inter, Noto Sans, Sans-Serif"
    readonly property string fontMono: "JetBrains Mono, monospace"

    // Tema Uygulama Fonksiyonu (Rebuild'siz anlık Hyprland senkronizasyonu)
    function applyTheme(name: string): void {
        if (!palettes[name]) {
            console.warn("[enyxma:Theme] Geçersiz tema adı:", name);
            return;
        }

        currentTheme = name;
        console.log("[enyxma:Theme] Tema değiştirildi:", name);

        // Hyprland aktif kenarlık rengini canlı güncelle
        var borderSpec = palettes[name].hyprlandBorder;
        if (borderSpec && typeof Hyprland !== "undefined") {
            Hyprland.dispatch("keyword general:col.active_border " + borderSpec);
        }
    }

    // Quickshell IPC İşleyicisi
    // Harici çağrı: quickshell ipc call theme setTheme "cyber-matrix"
    property IpcHandler ipc: IpcHandler {
        target: "theme"

        function setTheme(name: string): void {
            root.applyTheme(name);
        }

        function getTheme(): string {
            return root.currentTheme;
        }

        function listThemes(): string {
            return Object.keys(root.palettes).join(", ");
        }
    }
}
