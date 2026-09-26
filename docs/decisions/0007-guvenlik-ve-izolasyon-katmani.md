# ADR-0007: Gray-Hat Siber Güvenlik, İzolasyon ve Secure Boot Mimarisi

- **Tarih:** 2026-09-26
- **Durum:** Kabul Edildi

## Bağlam

enyxma ekosistemi, siber güvenlik araştırmacıları ve geliştiriciler için tasarlanmış bağımsız bir işletim sistemidir. Sistemde güvenlik araçlarının dağıtımı, riskli uygulamaların tecrit edilmesi ve önyükleme güvenliği için 3 yaklaşım değerlendirilmiştir:

1. **Modüler & İzolasyon Odaklı:** Araçlar kategorilere (network, recon, forensics, crypto, web) bölünür; Nixpak ile Bubblewrap tabanlı sandbox oluşturulur; Lanzaboote ile Secure Boot opsiyonel yönetilir.
2. **Monolitik Kurulum:** Yüzlerce siber güvenlik aracı temel sisteme toptan yüklenir.
3. **Minimalist / Anlık Shell Odaklı:** Sistemde hiçbir araç tutulmaz, her şey anlık RAM'de `nix-shell` ile açılır.

## Karar

**Modüler & İzolasyon Odaklı** mimari kabul edildi:

- **Kategorize Araç Seti (`modules/security/tools.nix`):**
  - `network`: `nmap`, `tshark`, `tcpdump`, `socat`, `netcat`, `iperf3`.
  - `recon`: `dnsutils`, `whois`, `traceroute`, `masscan`.
  - `forensics`: `binwalk`, `radare2`, `hexyl`.
  - `crypto`: `age`, `sops`, `gnupg`, `openssl`, `yubikey-manager`.
  - `web`: `curl`, `wget`, `mitmproxy`.
  - Kullanıcı `enyxma.security.tools.categories` üzerinden istediği profilleri seçer veya `all` ile tamamını açabilir.
- **Deklaratif Sandbox Katmanı (`modules/security/sandbox.nix`):**
  - `nixpak` (Bubblewrap) entegrasyonu ile tecrit edilmiş çalışma alanı (`enyxma-sandbox`).
  - Riskli analizler ve bilinmeyen betikler için ana dosya sistemine ve `/persist` altındaki SSH/GPG anahtarlarına erişim tamamen kesilir; yalnızca geçici tmpfs dizini tahsis edilir.
- **Secure Boot Entegrasyonu (`modules/security/secureboot.nix`):**
  - `lanzaboote` modülü `enyxma.security.secureboot.enable` seçeneğiyle parametrik sunulur (VM testlerinde false, prodüksiyon SSD kurulumunda true).
  - Açıldığında `systemd-boot` yerine UKI (Unified Kernel Image) imzalaması devreye girer; `sbctl` aracı sisteme dahil edilir ve `/etc/secureboot` yolu impermanence altına alınır.

## Neden

- Sistemin gereksiz yüzlerce paketle şişmesi engellenir; temiz ve profesyonel bir çalışma alanı korunur.
- Analiz araçlarının ve şüpheli ikililerin ana sistem belleğine veya kalıcı dosya yollarına sızması Bubblewrap kafesiyle mutlak olarak engellenir.
- Donanım düzeyinde fiziksel saldırılara ve bootkit'lere karşı Secure Boot kalkanı sağlanır.
