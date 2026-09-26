# ADR-0006: Evrensel Donanım ve GPU Sürücü Politikası

- **Tarih:** 2026-09-26
- **Durum:** Kabul Edildi

## Bağlam

enyxma, canlı ISO ve kurulu sistemde her cihazda (AMD, Intel, Nvidia, sanal makineler) otomatik uyum sağlamayı hedefler. Wayland ve Hyprland ortamında grafik hızlandırma ve çevre birimlerinin yönetimi için 3 politika değerlendirilmiştir:

1. **Evrensel Açık Kaynak Sürücüler (Mesa/RADV/VA-API) + Deklaratif Nvidia/Hibrit Anahtarı:** Varsayılan olarak açık kaynak evrensel sürücülerle sıfır yapılandırmayla açılış; Nvidia/hibrit sistemler için deklaratif anahtarlar.
2. **Nvidia Öncelikli Otomatik Hibrit Yapılandırma:** Tescilli Nvidia sürücülerinin her donanımda otomatik tespit edilip zorlanması.
3. **Yalnızca nixos-facter Bağımlı:** Donanım profilinin yalnızca önceden üretilmiş `facter.json` dosyası üzerinden türetilmesi.

## Karar

**Evrensel Açık Kaynak Sürücüler + Deklaratif Nvidia/Hibrit Anahtarı** politikası kabul edildi:

- **Grafik Hızlandırma:** `hardware.graphics.enable = true` ve `hardware.graphics.enable32Bit = true` standart olarak aktiftir.
- **Evrensel Sürücüler:** AMD (RADV/Mesa) ve Intel (Iris/i915 + `intel-media-driver` + `vpl-gpu-rt`) ile VM sanal ekran bağdaştırıcıları (VirtIO-GPU) varsayılan olarak pürüzsüz donanım hızlandırmasıyla açılır.
- **Nvidia / Hibrit Desteği:** `enyxma.hardware.gpu.driver` seçeneği ile deklaratif kontrol sunulur:
  - `"modesetting"` / `"auto"`: Açık kaynak evrensel sürücüler.
  - `"nvidia"`: Resmi açık kaynak çekirdek modülleri (`hardware.nvidia.open = true`), Wayland modesetting ve güç yönetimi.
  - `"hybrid-intel-nvidia"` veya `"hybrid-amd-nvidia"`: PRIME offload desteği.
- **Çevre Birimleri ve Optimizasyon:**
  - Ses: Düşük gecikmeli PipeWire + WirePlumber + RTKit.
  - Bluetooth: Otomatik güç yönetimi ve `blueman` servisi.
  - Güç & Termal: `power-profiles-daemon` ve Intel sistemler için `thermald`.
  - CPU Mikrokodu: Intel ve AMD mikrokod güncellemeleri eşzamanlı aktif.

## Neden

- Canlı ISO'nun yabancı bir makinede veya VM'de boot edildiğinde grafik sunucusunun çökmesi ya da siyah ekranda kalması riski önlenir.
- Açık kaynak grafik yığını Wayland ve Hyprland protokolleriyle tam ve native uyumludur.
- Nvidia kullanıcıları için deklaratif, temiz ve yönetilebilir bir genişletme yolu sunulur.
