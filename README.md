# enyxma :: Sovereign Linux Ecosystem

```
  ███████╗███╗   ██╗██╗   ██╗██╗  ██╗███╗   ███╗ █████╗ 
  ██╔════╝████╗  ██║╚██╗ ██╔╝╚██╗██╔╝████╗ ████║██╔══██╗
  █████╗  ██╔██╗ ██║ ╚████╔╝  ╚███╔╝ ██╔████╔██║███████║
  ██╔══╝  ██║╚██╗██║  ╚██╔╝   ██╔██╗ ██║╚██╔╝██║██╔══██║
  ███████╗██║ ╚████║   ██║   ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║
  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝
              SOVEREIGN SYSTEM ARCHITECTURE
```

**enyxma**, NixOS + Hyprland (Pure Lua 0.55+) + Quickshell (QtQuick/QML) ve impermanence/tmpfs kök dizini mimarisi üzerine sıfırdan inşa edilmiş; gray-hat siber güvenlik araştırmacıları ve sistem geliştiricileri için tasarlanmış bağımsız ve egemen bir Linux dağıtımıdır.

Genel amaçlı bir son kullanıcı dağıtımı (Omarchy veya CachyOS gibi) **değildir**. Her bileşeni tek bir yekpare ekosistem felsefesiyle, sıfırdan tasarlanmış ve dışarıdan hiçbir dotfiles kopyalanmadan üretilmiştir.

---

## 🌟 Temel Mimarî Özellikler

### 1. Pure Lua Hyprland (0.55+) & Quickshell Ekosistemi
- Statik ve kısıtlı `hyprland.conf` yerine tam programlanabilir **Pure Lua** (`shell/hypr/`).
- Stylix veya Waybar gibi hantal soyutlamalar yerine, doğrudan Wayland/Hyprland IPC ile çalışan GPU hızlandırmalı **Quickshell (QtQuick/QML)** masaüstü kabuğu (`TopBar`, `AppLauncher`, `ControlCenter`, `OSD`).

### 2. Tek Doğruluk Kaynaklı (SSOT) 5-Tema Ekosistemi
- `shell/themes/palettes.nix` üzerinden tanımlanan 5 seçkin tema varyasyonu:
  - 🌌 **Void Black:** Minimalist saf siyah, derin kömür ve cyan neon vurgusu.
  - 🟢 **Cyber Matrix:** Siber güvenlik obsidyeni ve parlak zümrüt neonu.
  - ❄️ **Ghost White:** Yüksek kontrastlı kristal beyaz ve safir mavisi.
  - 🔷 **Slate Cobalt:** Teknik mühendislik antrasiti ve kobalt mavisi.
  - 🩸 **Blood Amber:** Karanlık obsidyen, kızıl kehribar ve alev turuncusu.
- **Sıfır Yeniden Derleme:** Çalışma zamanında Quickshell IPC (`quickshell -s theme <ad>`) ve Control Center üzerinden anlık geçiş imkânı.

### 3. Ephemeral Root (tmpfs) ve Deklaratif Disko
- Kök dizin (`/`) RAM üzerinde **8 GB `tmpfs`** olarak çalışır. Her yeniden başlatmada geçici dosyalar sıfırlanır, sistem asla kirlenmez.
- `disko` ile GPT bölümleme, 1 GB ESP (`/boot`), opsiyonel LUKS2 (Argon2id) tam disk şifreleme ve Btrfs subvolume havuzu (`@nix`, `@persist`, `@swap`).
- `impermanence` ile sadece kullanıcı ve sistemin kalıcı olması gereken verileri (`/persist`) korunur.

### 4. Evrensel Donanım Uyumu
- Cihaz bağımsız açık kaynaklı sürücü politikası (Mesa, RADV, Intel VA-API).
- Hibrit grafikler için deklaratif Nvidia ve PRIME offload yapılandırması.
- `nixos-facter` runtime otomatik algılama ve `nixos-hardware` desteği.

### 5. Gray-Hat Siber Güvenlik ve İzolasyon Katmanı
- Kategorize edilmiş araç profilleri: `network`, `recon`, `forensics`, `crypto`, `web` (`modules/security/tools.nix`).
- **`enyxma-sandbox`:** Bubblewrap ve Nixpak tabanlı tecrit kafesi. Şüpheli ikilileri salt-okunur kök dizin, sahte ev dizini ve ağ izolasyonuyla güvenle çalıştırma.
- **Lanzaboote:** UEFI Secure Boot desteği, UKI (Unified Kernel Image) mimarisi ve `/persist` altında korunan `sbctl` PKI anahtarları.

### 6. Canlı ISO ve İnteraktif Kurulum Sihirbazı
- Yerel `nixpkgs` imaj motoru (`system.build.isoImage`) ile üretilen canlı ISO imajı (`nix build .#iso`).
- Canlı ortamda doğrudan Wayland + Hyprland + Quickshell masaüstü karşılaması.
- **`enyxma-install`:** Diski otomatik tarayan, LUKS2 şifreleme ve 5 temadan açılış tercihi sunan TUI kurulum sihirbazı.

---

## 🚀 Hızlı Başlangıç

### Depoyu Klonlama
```bash
git clone https://codeberg.org/xmrah/enyxma.git
cd enyxma
```

### Canlı ISO İmajını Derleme
```bash
nix build .#iso
# İmaj hazır: result/iso/enyxma.iso
```

### Sistemi Sanal Makinede (VM) Simüle Etme
```bash
# Hedef kurulu sistemi QEMU üzerinde çalıştırın
nix build .#nixosConfigurations.enyxma.config.system.build.vm
./result/bin/run-enyxma-vm
```

### Flake Bütünlüğünü Denetleme
```bash
nix flake check
```

---

## 📚 Kapsamlı Dokümantasyon

| Rehber / Belge | Açıklama |
|---|---|
| [Yeni Tema Ekleme Rehberi](docs/guides/tema-ekleme.md) | Deklaratif palet tanımı, tokenler ve anlık IPC geçişi |
| [Canlı ISO ve Kurulum Kılavuzu](docs/guides/kurulum-ve-canli-iso.md) | ISO oluşturma, USB hazırlığı ve `enyxma-install` adımları |
| [Güvenlik ve Sandbox Rehberi](docs/guides/guvenlik-ve-sandbox.md) | Siber güvenlik araçları, `enyxma-sandbox` ve Secure Boot |
| [Geliştirici ve Sistem Mimarisi](docs/guides/gelistirici-ve-mimari.md) | Dizin hiyerarşisi, Pure Lua mimarisi ve VM test döngüsü |
| [Mimarî Karar Kayıtları (ADR)](docs/decisions/README.md) | ADR-0001'den ADR-0008'e kadar tüm mimarî kararlar |

---

## 🛡️ Depo Politikası ve Lisans

- **Ana Depo:** `codeberg.org/xmrah/enyxma`
- **Ayna (Mirror):** `github.com/xmrah/enyxma`
- **Egemenlik:** Harici üçüncü parti dotfiles veya soyutlayıcı kütüphanelere bağımlı olmaksızın, tamamen bağımsız ve sürdürülebilir olarak inşa edilmiştir.
