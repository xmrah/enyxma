# ADR-0003: Tema Ekosistemi Dağıtım Stratejisi

- **Tarih:** 2026-09-26
- **Durum:** Kabul Edildi

## Bağlam

enyxma, 4-5 seçkin tema varyasyonuyla (Void Black, Cyber Matrix, Ghost White, Slate Cobalt, Blood Amber) yekpare bir masaüstü ekosistemi sunacak. Tema değişimi için iki yaklaşım mevcuttu:

1. **Tamamen runtime:** Quickshell IPC ile tema anında değişir; rebuild gerekmez ama palet verisi QML'de sabit kodlanmak zorunda kalabilir.
2. **Tamamen build-time:** Her tema Nix modülü olarak derlenir; değişim nixos-rebuild gerektirir.
3. **Hibrit (build-time palet + runtime değişim):** Palet verileri Nix tarafında derleme anında üretilip QML'e enjekte edilir; tema değişimi ise runtime'da Quickshell IPC ile rebuild'siz gerçekleşir.

## Karar

Hibrit yaklaşım: **Palet verisi build-time Nix→QML, tema değişimi runtime Quickshell IPC ile (rebuild'siz).**

## Neden

- Tema renk paletleri Nix diliyle tek bir doğruluk kaynağında tanımlanır; bu hem Quickshell'e hem Hyprland Lua'ya hem de terminal emülatörlerine derleme anında tutarlı şekilde dağıtılır.
- Kullanıcı 4-5 tema arasında geçiş yaparken nixos-rebuild çalıştırmak zorunda kalmaz; Quickshell IPC sinyaliyle aktif palet anında yüklenir ve Hyprland kenarlıkları/Kitty renkleri canlı güncellenir.
- Yeni tema eklemek sadece Nix tarafında bir palet tanımı eklemektir; QML motoru veya Lua modülünde değişiklik gerekmez.
