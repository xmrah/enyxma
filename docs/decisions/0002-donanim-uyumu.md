# ADR-0002: Otomatik Donanım Uyumu Stratejisi

- **Tarih:** 2026-09-26
- **Durum:** Kabul Edildi

## Bağlam

enyxma her cihazda otomatik donanım uyumu hedefler. İki yaklaşım mevcuttu:

1. **nixos-hardware**: Bilinen cihaz modelleri için topluluk tarafından hazırlanmış statik profiller.
2. **nixos-facter**: Çalışma zamanında (runtime) cihazdaki PCI/USB/CPU/GPU donanımını tarayıp deklaratif `facter.json` üreten modern araç.

## Karar

- **Birincil motor:** `nixos-facter` — kurulum anında hedef cihazın donanımını otomatik algılar.
- **İkincil/opsiyonel ek:** `nixos-hardware` — yalnızca bilinen özel cihaz profilleri (Framework, Apple Silicon vb.) için gerektiğinde dahil edilir.

## Neden

- Bilinmeyen donanımlarda manuel profil seçimi gerektirmez; cihaz bağımsız otomatik uyum sağlar.
- nixos-hardware'in statik profilleri, özel quirk'ler ve kernel parametreleri gerektiren bilinen cihazlar için hâlâ değerlidir ancak birincil motor olamaz.
