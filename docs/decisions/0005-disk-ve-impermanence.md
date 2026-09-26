# ADR-0005: Disk Bölümleme ve Ephemeral Kök (Impermanence) Mimarisi

- **Tarih:** 2026-09-26
- **Durum:** Kabul Edildi

## Bağlam

enyxma; siber güvenlik, iz bırakmama ve sistem kirlenmesini önleme amacıyla "ephemeral root" (geçici kök) mimarisini benimser. Bu mimarinin disko ve impermanence ile nasıl kurgulanacağı konusunda 3 seçenek değerlendirilmiştir:

1. **Parametrik tmpfs root + Btrfs (Opsiyonel LUKS2):** Kök dizin RAM'de (`tmpfs`) yaşar; kalıcı veriler Btrfs subvolume'larında tutulur. LUKS2 şifrelemesi parametrik olarak açılıp kapatılabilir.
2. **Zorunlu LUKS2 + Btrfs + tmpfs root:** Her ortamda (VM dahil) LUKS şifreleme zorunlu olur.
3. **Btrfs Snapshot Rollback:** Kök dizin diskte bir Btrfs subvolume'u olarak tutulur ve her boot anında boş bir snapshot'a geri döndürülür.

## Karar

**Parametrik tmpfs root + Btrfs (Opsiyonel LUKS2)** mimarisi kabul edildi:

- **Kök Dizin (`/`):** RAM tabanlı `tmpfs` (boyut: `size=8G` veya RAM'in %50'si, `mode=755`). Her yeniden başlatmada sistem durumu tamamen sıfırlanır.
- **Kalıcı Katman (`/persist`):** Btrfs `@persist` subvolume'u. Yalnızca deklaratif olarak belirlenen kritik sistem anahtarları, günlükler ve kullanıcı verileri bu alana yönlendirilir.
- **Nix Deposu (`/nix`):** Btrfs `@nix` subvolume'u (ZSTD sıkıştırması aktif, `noatime`).
- **Disk Şifrelemesi:** `enyxma.disko.encrypted` seçeneğiyle kontrol edilir.
  - VM ve geliştirme ortamında: Şifresiz Btrfs (otomatik pürüzsüz açılış).
  - Canlı ISO kurulumu ve SSD ortamında: LUKS2 (Argon2id) tam disk şifreleme.
- **Impermanence Katmanı:** `nix-community/impermanence` modülü entegre edilerek `/persist` altındaki kalıcı yollar açıkça tanımlanır.

## Neden

- RAM tabanlı tmpfs kökü, fiziksel diske geçici veri yazılmasını önleyerek hem SSD ömrünü korur hem de kapatılan sistemde disk üzerinden adli/kriminal veri kurtarmayı imkansız kılar.
- Parametrik LUKS desteği, geliştirici ve test aşamasında (VM boot testleri) parola bekleme darboğazını ortadan kaldırırken, nihai donanımda azami güvenlik sağlar.
