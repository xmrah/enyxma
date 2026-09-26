# ADR-0004: Masaüstü ve Kabuk Entegrasyon Modeli

- **Tarih:** 2026-09-26
- **Durum:** Kabul Edildi

## Bağlam

enyxma ekosisteminde Quickshell + Hyprland (Pure Lua 0.55+) + yerel tema motorundan oluşan bağımsız bir masaüstü kabuğu (`shell/`) geliştirilmektedir. Bu kabuğun NixOS sistemine entegrasyonu için 3 seçenek değerlendirilmiştir:

1. **Saf NixOS Sistem Modülü:** Yapılandırma `/etc/xdg/` ve sistem seviyesinde tanımlanır. Canlı ISO ve impermanence için idealdir ancak kullanıcı düzeyinde granular yönetimi sınırlar.
2. **Home-Manager Odaklı:** Yalnızca kullanıcı düzeyinde `~/.config/` yönetimi yapılır. Canlı ISO'da ve yeni kullanıcı oluşturulduğunda ek yapılandırma zorunluluğu doğurur.
3. **Hibrit Model (Birincil Saf Sistem Modülü + Opsiyonel Home-Manager):** Çekirdek yapılandırmalar `/etc/xdg` üzerinden saf NixOS modülü olarak sunulur; eşzamanlı olarak dileyen kullanıcılar için home-manager modülü dışa aktarılır.

## Karar

Hibrit model benimsendi:
- **Birincil Entegrasyon:** Saf NixOS sistem modülü (`modules/desktop/default.nix`) ile kabuk ve Hyprland yapılandırmaları `/etc/xdg/hypr` ve `/etc/xdg/quickshell` dizinlerine bağlanır.
- **Canlı ISO ve VM Uyumu:** Canlı ISO açılışında (`nixos` kullanıcısı ile) veya yeni bir kullanıcı açıldığında hiçbir ev dizini kopyalamasına ihtiyaç kalmadan masaüstü ve tema motoru anında çalışır.
- **Genişletilebilirlik:** `flake.nix` üzerinden hem `nixosModules.desktop` hem de opsiyonel `homeManagerModules.desktop` arayüzü sunulur.

## Neden

- Canlı ISO'nun "pro" seviye pürüzsüz açılış hedefi doğrudan sağlanır.
- Impermanence (tmpfs root) kullanımında `/etc` zaten deklaratif olduğu için kullanıcı ev dizini sıfırlansa bile kabuk bütünlüğünü korur.
- Harici bir zorunlu girdi olmaksızın en az bağımlılıkla sistem derlenebilir.
