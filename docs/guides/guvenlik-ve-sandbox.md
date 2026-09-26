# enyxma :: Siber Güvenlik, Tecrit ve Sandbox Rehberi

enyxma, **gray-hat siber güvenlik uzmanları, araştırmacılar ve güvenlik odaklı geliştiriciler** için tasarlanmış bağımsız bir işletim sistemidir. Sistem araçları rastgele paket yığınları olarak sisteme serpiştirilmez; kategorize modüller, deklaratif sandbox kafesleri ve Secure Boot güvenliği ile izole edilir.

Bu kılavuz, güvenlik araç setinin kullanımını, `enyxma-sandbox` tecrit mekanizmasını ve Lanzaboote güvenli önyükleme katmanını açıklar.

---

## 1. Kategorize Siber Güvenlik Araçları

Güvenlik araçları `modules/security/tools.nix` altında 5 fonksiyonel kategoriye ayrılmıştır.

### Kategoriler ve İçerikler

| Kategori | Araçlar | Kullanım Amacı |
|---|---|---|
| `network` | `nmap`, `masscan`, `wireshark-cli`, `tcpdump`, `iperf3`, `traceroute`, `bind.dnsutils` | Ağ keşfi, paket yakalama ve bant genişliği analizi |
| `recon` | `whois` (ve bağımsız keşif araçları) | Alan adı, IP ve OSINT istihbarat toplama |
| `forensics` | `sleuthkit`, `binwalk`, `radare2`, `hexyl` | İkili dosya analizi, tersine mühendislik ve bellek adli bilişimi |
| `crypto` | `age`, `sops`, `gnupg`, `yubikey-manager`, `tpm2-tools` | Donanım anahtarları, asimetrik şifreleme ve sır yönetimi |
| `web` | `mitmproxy`, `curl`, `jq` | HTTP/HTTPS ve API trafiği manipülasyonu ve denetimi |

### Yapılandırma (`flake.nix` veya `configuration.nix`)

Sisteminize yalnızca ihtiyacınız olan araçları deklaratif olarak ekleyebilirsiniz:

```nix
enyxma.security = {
  enable = true;
  tools = {
    enable = true;
    # İstediğiniz kategorileri belirleyin veya hepsi için ["all"] kullanın:
    categories = [ "network" "crypto" "forensics" ];
  };
};
```

---

## 2. `enyxma-sandbox`: Bubblewrap Tecrit Kafesi

Şüpheli, yabancı veya henüz güvenmediğiniz bir ikiliyi (binary), zararlı yazılım örneğini ya da geliştirme aşamasındaki bir betiği çalıştırırken ana sistemi korumak için `enyxma-sandbox` kullanılır.

### Güvenlik İzolasyon İlkeleri:
- **Salt-Okunur Kök (`/`):** Sistem dosyaları sandbox içinde değiştirilemez.
- **İzole RAM Dizini:** `/tmp` her çalıştırmada sanal bellekte sıfırdan oluşturulur.
- **Sahte Ev Dizini:** `/home/sandbox` geçici olarak tahsis edilir; kullanıcının asıl `~` dizini gizlenir.
- **Kritik Durum Koruması:** `/persist`, `/root`, `/etc/shadow`, `/etc/nixos` dizinleri tecrit kafesi içinden tamamen maskelenir ve erişilemez.
- **Ağ İzolasyonu:** Varsayılan olarak tüm harici ağ bağlantısı kesilir (sadece `lo` loopback aktif).

### Kullanım Örnekleri

#### A. Tam İzole ve Ağsız Çalıştırma (Varsayılan)
```bash
enyxma-sandbox ./supheli_arac
```

#### B. Ağ Erişimi Gerektiren Analizler
```bash
enyxma-sandbox --share-net ./ag_analiz_araci
```

#### C. Belirli Bir İnceleme Klasörünü Bağlama
```bash
enyxma-sandbox --bind /home/enyxma/inceleme /mnt/inceleme ./adli_analiz
```

---

## 3. Lanzaboote ve Secure Boot Katmanı

enyxma, UEFI Secure Boot ortamında UKI (Unified Kernel Image) mimarisiyle tam uyumludur.

### Mimarî Detaylar:
- `lanzaboote` modülü `systemd-boot` yerine doğrudan UEFI tarafından doğrulanabilen imzalı UKI çekirdek imajları üretir.
- **İmpermanence ve PKI Kalıcılığı:**
  Secure Boot anahtarları (`sbctl`) ve UKI sertifikaları kök dizindeki tmpfs silinmelerinden etkilenmez.
  Anahtar dizinleri doğrudan kalıcı `/persist` bölümüne bağlanır:
  ```
  /persist/etc/secureboot/keys/
  ```

### Secure Boot Doğrulama ve Yönetim:
```bash
# Secure Boot durumunu denetle
sudo sbctl status

# Mevcut imzalı önyükleme dosyalarını listele
sudo sbctl verify
```
