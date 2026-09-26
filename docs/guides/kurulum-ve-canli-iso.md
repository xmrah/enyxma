# enyxma :: Canlı ISO ve Sistem Kurulum Kılavuzu

enyxma; sanal makinelere (QEMU/KVM, VMware, VirtualBox) veya doğrudan fiziksel donanımlara (NVMe/SATA SSD) **pro seviyede pürüzsüz ve deklaratif kurulum** için tasarlanmış bağımsız bir işletim sistemidir.

Bu kılavuz; Canlı ISO imajının derlenmesini, canlı oturum özelliklerini, `enyxma-install` TUI kurulum sihirbazını ve kurulum sonrası ilk açılış adımlarını belgeler.

---

## 1. Canlı ISO İmajının Derlenmesi

enyxma ISO imajı, nixpkgs'in yerel imaj üretim motoru (`system.build.isoImage`) üzerinden üretilir.

Deponun kök dizininde şu komutu çalıştırın:

```bash
# Canlı ISO'yu derle
nix build .#iso
```

Derleme tamamlandığında ISO imajı `result/iso/enyxma.iso` konumuna yerleştirilir.

### Boyut ve Sıkıştırma
- İmaj, Zstandard (`zstd -Xcompression-level 6`) algoritmasıyla sıkıştırılır.
- Hyprland (0.55+ Pure Lua), Quickshell, Kitty, Waybar/QML kabuğu, donanım sürücüleri ve temel siber güvenlik araç takımını canlı ortamda içerir.

---

## 2. Kurulum Medyasının Hazırlanması

### Fiziksel USB Belleğe Yazma (Linux):
Hedef USB aygıtınızı (`lsblk` ile doğrulayarak) belirleyin ve `dd` komutunu kullanın:

```bash
sudo dd if=result/iso/enyxma.iso of=/dev/sdX bs=4M status=progress oflag=sync
```
*(Dikkat: `/dev/sdX` yerine kendi USB aygıtınızın harfini yazın; disk üzerindeki tüm veriler silinir).*

### Ventoy Kullanımı:
`result/iso/enyxma.iso` dosyasını doğrudan Ventoy formatlı USB belleğinize kopyalayabilirsiniz.

---

## 3. Canlı Oturuma Açılış (Live Environment)

enyxma Canlı ISO'su başlatıldığında:

1. **Şifresiz Otomatik Giriş:** `nixos` kullanıcısı `wheel` ve `video` yetkileriyle sisteme giriş yapar.
2. **Doğrudan Grafiksel Masaüstü:** Hyprland pencere yöneticisi ve Quickshell TopBar anında yüklenir.
3. **5-Tema Canlı Deneyimi:** Kuruluma geçmeden önce `Super + Shift + C` ile Control Center'ı açabilir ve 5 farklı temayı sistem üzerinde canlı test edebilirsiniz.
4. **İnteraktif Sihirbaz:** Masaüstü açıldığında kurulum sihirbazı Kitty penceresinde otomatik olarak kullanıcıyı karşılar. Kapatılırsa Quickshell uygulama menüsündeki "Sistem Kurulumu" seçeneğiyle tekrar açılabilir.

---

## 4. `enyxma-install` Kurulum Sihirbazı Adımları

Kurulum süreci 9 mantıksal adımdan oluşur:

### Adım 1: Hedef Kurulum Diskinin Seçimi
Sistemdeki tüm blok aygıtlar taranır ve model/boyut bilgisiyle listelenir (örneğin `/dev/nvme0n1` veya `/dev/vda`).
Kullanıcı kurulum yapacağı diski yazar.

### Adım 2: Tam Disk Şifreleme (LUKS2)
- **Tercih:** Kullanıcıya tam disk şifreleme isteyip istemediği sorulur.
- **Argon2id Güvencesi:** Şifreleme seçilirse güçlü PBKDF Argon2id kullanılır ve girilen parola çift aşamalı doğrulanır.

### Adım 3: Sistem Açılış Teması Seçimi
Hedef sisteme kurulacak varsayılan tema 5 seçenek arasından belirlenir:
1. `void-black` (Minimalist saf siyah ve cyan neon)
2. `cyber-matrix` (Siber güvenlik obsidyeni ve zümrüt yeşili)
3. `ghost-white` (Yüksek kontrastlı kristal beyaz ve safir mavisi)
4. `slate-cobalt` (Teknik antrasit ve kobalt mavisi)
5. `blood-amber` (Derin siyah ve alev kehribarı)

### Adım 4: Operatör ve Sistem Kimliği
- **Kullanıcı Adı:** Sistemin ana operatör hesabı (Varsayılan: `enyxma`).
- **Hostname:** Ağdaki makine adı.
- **Parola:** Operatör parolası alınır ve `mkpasswd -m sha-512` ile şifrelenerek deklaratif yapıya gömülür.

### Adım 5: Secure Boot Tercihi
Hedef sistemde Lanzaboote ve UKI (Unified Kernel Image) Secure Boot altyapısının aktif edilip edilmeyeceği sorulur.

### Adım 6: Deklaratif Disko Bölümlendirmesi
`disko` aracı arka planda çalışarak şu bölümleri milisaniyeler içinde hazırlar:
- **ESP (`/boot`):** 1 GB FAT32 bölümü.
- **Root (`/`):** 8 GB `tmpfs` RAM kök dizini (Her açılışta sıfırlanır, impermanence mimarisi).
- **Btrfs Havuzu (`crypted` veya düz):**
  - `@nix` -> `/nix` (zstd sıkıştırmalı, noatime paket havuzu)
  - `@persist` -> `/persist` (zstd sıkıştırmalı kalıcı durum havuzu)
  - `@swap` -> `/swap/swapfile` (4 GB dinamik takas alanı)

### Adım 7: Hedef Yapılandırmanın Yerleştirilmesi
Mevcut enyxma flake yapılandırması hedef sistemin `/mnt/persist/etc/nixos` dizinine kopyalanır ve kullanıcının seçtiği ayarlar (tema, kullanıcı adı, disk kimliği) `flake.nix` içine işlenir.

### Adım 8: Sistemin Kurulması (`nixos-install`)
Gerekli tüm paketler doğrudan `/mnt` dizinine kurulur ve önyükleyici (systemd-boot veya Lanzaboote) yapılandırılır.

### Adım 9: Yeniden Başlatma
Kurulum tamamlandığında kullanıcıya yeniden başlatma onayı sorulur.

---

## 5. İlk Açılış ve Kalıcılık Kontrolü

Sistem yeniden başlatıldığında:

```bash
# 1. Kök dizinin tmpfs olduğunu doğrulayın
findmnt /

# 2. Kalıcı dizinlerin /persist altına bağlandığını kontrol edin
findmnt /persist
ls -la /persist/etc/nixos
```

Kullanıcı dosyaları (`~/Projects`, `~/Documents`, SSH anahtarları, Wi-Fi bağlantıları ve sistem günlükleri) `/persist` altında güvendedir; kök dizindeki geçici dosyalar ise her açılışta silinerek sistemin daima ilk günkü tazelikte kalmasını sağlar.
