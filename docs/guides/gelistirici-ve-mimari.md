# enyxma :: Geliştirici ve Sistem Mimarisi Kılavuzu

enyxma; modüler, saf, egemen ve kendi kendine yeten bir NixOS ekosistemi olarak tasarlanmıştır. Bu kılavuz; deponun mimarî yapısını, Pure Lua Hyprland ve Quickshell bileşenlerini, yerel test simülasyonunu ve geliştirici iş akışlarını belgeler.

---

## 1. Dizin Hiyerarşisi ve Görev Dağılımı

```
enyxma/
├── flake.nix              # Dağıtımın deklaratif giriş kapısı ve çıktıları
├── hosts/                 # Makine profilleri
│   ├── iso/               # Canlı ISO ortamı profili
│   └── default.nix        # Kurulu hedef sistem ana yapılandırması
├── modules/               # Bağımsız NixOS sistem modülleri
│   ├── desktop/           # Hyprland + Quickshell + Kitty sistem entegrasyonu
│   ├── disko/             # Deklaratif GPT, tmpfs, LUKS2 ve Btrfs disk şeması
│   ├── impermanence/      # Kalıcı durum (/persist) yönetim katmanı
│   ├── hardware/          # Evrensel GPU (Mesa/Nvidia) ve çevre birimleri
│   ├── security/          # Gray-hat araçları, bwrap sandbox ve Lanzaboote
│   └── installer/         # enyxma-install TUI kurulum sihirbazı
├── shell/                 # Kullanıcı arayüzü ve masaüstü kabuğu
│   ├── hypr/              # 0.55+ Pure Lua Hyprland yapılandırması
│   ├── quickshell/        # QtQuick/QML masaüstü paneli, menü ve bildirimler
│   └── themes/            # Tek doğruluk kaynaklı (SSOT) 5-tema motoru
└── docs/                  # Mimarî kararlar (ADR), araştırmalar ve kılavuzlar
    ├── decisions/         # ADR-0001'den ADR-0008'e kadar tüm kararlar
    ├── research/          # Ekosistem araçlarının araştırma notları
    └── guides/            # Tema ekleme, kurulum, güvenlik ve geliştirici rehberleri
```

---

## 2. Pure Lua Hyprland (0.55+) Mimarisi

enyxma, geleneksel statik `hyprland.conf` sözdizimini kullanmaz. Hyprland'in 0.55 sürümüyle olgunlaşan **Pure Lua** API'si üzerine kuruludur:

- `shell/hypr/hyprland.lua`: Ana başlatıcı.
- `shell/hypr/core/env.lua`: Wayland, Qt, GDK ve XDG ortam değişkenleri.
- `shell/hypr/core/autostart.lua`: Quickshell, Kitty ve arka plan süreçleri.
- `shell/hypr/wm/layout.lua`: Dwindle pencere yerleşimi, boşluklar (gaps) ve fare ayarları.
- `shell/hypr/wm/rules.lua`: Dinamik pencere kuralları (yüzen pencereler, opaklık).
- `shell/hypr/wm/binds.lua`: Hızlı klavye kısayolları (`Super + Return`, `Super + Space`, vb.).
- `shell/hypr/ui/borders.lua`: Temadan beslenen aktif ve pasif pencere kenarlıkları.

### Lua Doğrulaması:
Tüm Lua modülleri derleme aşamasında sözdizimi denetiminden geçer:
```bash
luac -p shell/hypr/hyprland.lua
```

---

## 3. Quickshell (QtQuick/QML) Masaüstü Kabuğu

Waybar gibi harici ve kısıtlı araçlar yerine, doğrudan GPU hızlandırmalı modern QML motoru kullanılır:

- **`shell/quickshell/shell.qml`:** Ana kabuk girişi.
- **`components/TopBar.qml`:** Çalışma alanları (workspaces), aktif pencere başlığı, bellek/CPU/saat durumu ve hızlı menü tetikleyicisi.
- **`components/AppLauncher.qml`:** Klavye odaklı (`Super + Space`) minimalist uygulama başlatıcı ve sistem kurulum kısayolu.
- **`components/ControlCenter.qml`:** Ses, parlaklık, Wi-Fi, 5-tema anlık seçicisi ve oturum sonlandırma paneli.
- **`components/OSD.qml`:** Ses ve parlaklık değişimlerinde anlık ekrana gelen animasyonlu gösterge.
- **`Theme.qml`:** Dahili renk paletleri ve anlık IPC dinleyicisi (`quickshell -s theme <ad>`).

---

## 4. Geliştirme, Doğrulama ve Simülasyon Döngüsü

enyxma üzerinde kod geliştirirken fiziksel donanımı yeniden başlatmadan her şeyi sanal ortamda test edebilirsiniz:

### 1. Flake Sözdizimi ve Tip Kontrolü
```bash
nix flake check
```

### 2. Hedef Sistemi Sanal Makinede (VM) Çalıştırma
```bash
# VM türetimini derle
nix build .#nixosConfigurations.enyxma.config.system.build.vm

# VM'i doğrudan çalıştır
./result/bin/run-enyxma-vm
```
*VM açıldığında Hyprland masaüstünü, Quickshell arayüzünü ve araçları güvenle deneyimleyebilirsiniz.*

### 3. Canlı ISO İmajını Test Etme
```bash
# ISO derleme
nix build .#iso

# ISO'yu QEMU ile başlatma
qemu-system-x86_64 -enable-kvm -m 4G -cdrom result/iso/enyxma.iso -boot d
```

---

## 5. Katkı ve Git İş Akışı Standartları

- **Birincil Depo:** `codeberg.org:xmrah/enyxma.git` (GitHub yalnızca aynadır).
- **Mimarî Kararlar:** Büyük mimarî değişiklikler mutlaka `docs/decisions/` altında bir ADR dosyası ile belgelenmelidir.
- **Commit Mesajları:** Standart Türkçe Conventional Commits kuralına uyulmalıdır (`feat(...)`, `fix(...)`, `docs(...)`).
- **Veri Güvenliği:** Depo içine hiçbir kişisel bilgi (`/home/xmrah`, yerel anahtarlar, vb.) gömülemez.
