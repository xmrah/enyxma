# Araştırma Notu: nixos-anywhere

- **Tarih:** 2026-09-26
- **Kaynak:** https://github.com/nix-community/nixos-anywhere
- **Durum:** Aktif, uzaktan ve kexec tabanlı otomasyon standardı.

## Genel Bakış ve Güncel Deseni
Mevcut herhangi bir Linux kurulu makineye (veya SSH erişimi olan kurtarma ortamına) SSH üzerinden bağlanıp `kexec` ile geçici bir NixOS RAM ortamı başlatan, ardından `disko` ile diski formatlayıp yeni NixOS sistemini uzaktan kuran araçtır.

## Güncel Kullanım Deseni
```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#enyxma-target \
  root@hedef-ip-adresi
```
- Donanım parametrelerini SSH üzerinden geçirir.
- Disko yapılandırmasını otomatik çalıştırır.

## enyxma Açısından Değerlendirme
- Uzaktan sunucu, VPS veya ağ üzerinden kurulumlar için idealdir.
- **Canlı ISO Kurulumu ile Farkı:** Canlı ISO, USB takılarak monitör/klavye karşısında doğrudan kurulurken; `nixos-anywhere` uzaktaki makineleri ağ üzerinden provizyonlamak içindir.
- enyxma'nın "her cihazda otomatik uyum" ve uzaktan yönetilebilirlik hedefleri için ikincil bir kurulum seçeneği olarak konumlandırılabilir.
