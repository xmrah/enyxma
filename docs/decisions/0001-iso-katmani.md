# ADR-0001: Canlı ISO Üretim Katmanı

- **Tarih:** 2026-09-26
- **Durum:** Kabul Edildi

## Bağlam

enyxma, canlı ISO ile VM veya SSD'ye kurulum hedefler. ISO üretimi için iki seçenek mevcuttu:

1. **nixos-generators** (harici flake): 30 Ocak 2026'da arşivlendi, artık bakım almıyor.
2. **Yerel nixpkgs** (`config.system.build.images.iso`): İmaj üretim yetenekleri NixOS 25.05 itibarıyla doğrudan nixpkgs çekirdeğine alındı.

## Karar

Yerel nixpkgs imaj motoru kullanılacak. `nixos-generators` kullanılmayacak.

- Doğru çıktı attribute'u: `config.system.build.images.iso`
- `isoImage` değil.

## Neden

- Harici bağımlılık sıfırlanır.
- Arşivlenmiş bir projeye bağlı kalmanın güvenlik ve bakım riski ortadan kalkar.
- nixpkgs upstream ile tam uyum sağlanır.
