# enyxma :: Yeni Tema Varyasyonu Ekleme Rehberi

enyxma, üçüncü parti hantal stil soyutlamaları (örneğin Stylix) yerine **deklaratif ve doğrudan (native) bir tema mimarisi** kullanır. Tüm masaüstü ekosistemi (Hyprland pencereleri, Quickshell arayüzleri, Kitty terminali ve IPC katmanı) tek bir doğruluk kaynağından beslenir.

Bu rehber, enyxma'ya yeni bir tema varyasyonunun nasıl ekleneceğini, renk tokenlerini ve anlık geçiş dinamiklerini adım adım açıklar.

---

## 1. Mimarî Bütünlük ve Doğruluk Kaynağı

enyxma tema sisteminin omurgası `shell/themes/palettes.nix` dosyasıdır. Yeni bir tema eklendiğinde sistem şu zincirleme akışı işletir:

```
[shell/themes/palettes.nix] (Nix Doğruluk Kaynağı)
         │
         ├── Derleme Zamanı (Build-time)
         │     ├── `palettes.json` üretimi (QML & Harici araçlar için)
         │     ├── `/etc/kitty/kitty.conf` (Aktif tema renk haritası)
         │     └── `/etc/xdg/hypr/ui/borders.lua` (Hyprland aktif/pasif kenarlıklar)
         │
         └── Çalışma Zamanı (Runtime - Sıfır Rebuild)
               ├── Quickshell `Theme.qml` Singleton
               ├── Quickshell IPC Handler (`target: "theme"`)
               └── Control Center Hızlı Tema Seçici
```

---

## 2. Yeni Tema Tanımlama: Renk Şeması

Yeni bir tema eklemek için `shell/themes/palettes.nix` dosyasındaki nitelik kümesine (attrset) yeni bir anahtar ekleyin.

### Zorunlu Renk Tokenleri

Her temanın aşağıdaki anahtarları içermesi şarttır:

| Token | Açıklama | Örnek Değer |
|---|---|---|
| `name` | Temanın kullanıcıya görünen adı | `"Nord Frost"` |
| `description` | Temanın kısa karakter ve stil özeti | `"Kutup mavisi ve pastel antrasit"` |
| `isDark` | Koyu mod (`true`) veya açık mod (`false`) | `true` |
| `colors.background` | Temel masaüstü ve pencere arka planı | `"#2e3440"` |
| `colors.surface` | Panel, kart ve menü yüzey rengi | `"#3b4252"` |
| `colors.surfaceHover` | Etkileşimli öğeler (hover) yüzeyi | `"#434c5e"` |
| `colors.border` | Kart ve ayırıcı çizgi sınır rengi | `"#4c566a"` |
| `colors.accent` | Birincil neon vurgu rengi | `"#88c0d0"` |
| `colors.accentHover` | Vurgulu buton hover durumu | `"#8fbcbb"` |
| `colors.secondary` | İkincil teknik vurgu rengi | `"#81a1c1"` |
| `colors.text` | Birincil okunabilir metin rengi | `"#eceff4"` |
| `colors.textMuted` | Soluk / ikincil bilgi metni | `"#d8dee9"` |
| `colors.danger` | Hata, iptal ve tehlikeli işlem uyarısı | `"#bf616a"` |
| `colors.success` | Başarı, onay ve güvenli durum uyarısı | `"#a3be8c"` |
| `colors.warning` | Dikkat ve bekleme durumu uyarısı | `"#ebcb8b"` |
| `hyprland.activeBorderColors` | Aktif pencere gradyan sınır renkleri (`rgba`) | `[ "rgba(88c0d0ee)" "rgba(4c566aee)" ]` |
| `hyprland.inactiveBorderColor` | Pasif pencere sınır rengi (`rgba`) | `"rgba(2e3440aa)"` |

---

## 3. Adım Adım Örnek: `nord-frost` Temasının Eklenmesi

### Adım 1: `shell/themes/palettes.nix` Dosyasına Ekleyin

```nix
  nord-frost = {
    name = "Nord Frost";
    description = "Kuzey kutbu buz mavisi ve sakinleştirici antrasit tonları";
    isDark = true;
    colors = {
      background   = "#2e3440";
      surface      = "#3b4252";
      surfaceHover = "#434c5e";
      border       = "#4c566a";
      accent       = "#88c0d0";
      accentHover  = "#8fbcbb";
      secondary    = "#81a1c1";
      text         = "#eceff4";
      textMuted    = "#d8dee9";
      danger       = "#bf616a";
      success      = "#a3be8c";
      warning      = "#ebcb8b";
    };
    hyprland = {
      activeBorderColors = [ "rgba(88c0d0ee)" "rgba(4c566aee)" ];
      inactiveBorderColor = "rgba(2e3440aa)";
    };
  };
```

### Adım 2: `shell/quickshell/Theme.qml` Dosyasına Kaydedin

`shell/quickshell/Theme.qml` dosyasındaki `palettes` sözlüğüne ilgili renkleri ekleyin:

```qml
    readonly property var nordFrost: QtObject {
        readonly property string name: "Nord Frost"
        readonly property bool isDark: true
        readonly property color background: "#2e3440"
        readonly property color surface: "#3b4252"
        readonly property color surfaceHover: "#434c5e"
        readonly property color border: "#4c566a"
        readonly property color accent: "#88c0d0"
        readonly property color accentHover: "#8fbcbb"
        readonly property color secondary: "#81a1c1"
        readonly property color text: "#eceff4"
        readonly property color textMuted: "#d8dee9"
        readonly property color danger: "#bf616a"
        readonly property color success: "#a3be8c"
        readonly property color warning: "#ebcb8b"
    }
```

Ardından `themeNames` dizisine `"nord-frost"` anahtarını ekleyin.

### Adım 3: ControlCenter ve Yükleyiciye Bildirin

- `shell/quickshell/components/ControlCenter.qml` içindeki tema butonlarına yeni temayı ekleyin.
- `modules/installer/enyxma-install.sh` içindeki 5-tema menüsüne 6. seçenek olarak ekleyin.

---

## 4. Çalışma Zamanında Tema Değiştirme (Sıfır Yeniden Derleme)

enyxma'da tema değiştirmek için sistemi `nixos-rebuild switch` ile yeniden derlemenize gerek **yoktur**.

### Quickshell IPC ile Değiştirme:
```bash
quickshell -s theme nord-frost
```

### Hyprland Kısayolu ile Değiştirme:
Masaüstünde `Super + Shift + C` tuş kombinasyonuyla Control Center'ı açıp doğrudan farenizle tıklayabilirsiniz.

---

## 5. Doğrulama ve Test

Eklediğiniz temanın sözdizimini ve veri bütünlüğünü test edin:

```bash
# 1. Nix değerlendirmesini doğrula
nix eval .#defaultTheme

# 2. Flake bütünlüğünü kontrol et
nix flake check
```
