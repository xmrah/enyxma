# AGENTS.md — enyxma

Bu dosya, bu repoda çalışan her AI ajanının (Claude Opus, Gemini Pro/Flash, veya başka bir model) ilk okuması gereken tek doğruluk kaynağıdır. Model değişse bile kurallar değişmez.

## Proje ne, ne değil

- **enyxma**: NixOS + Hyprland + Lua + impermanence/tmpfs tabanlı, gray-hat siber güvenlik ve geliştirici odaklı bir sistem. Her cihazda otomatik donanım uyumu hedefler.
- **DEĞİL**: Omarchy veya CachyOS gibi genel amaçlı bir "dağıtım" değil. Kullanıcı kitlesi genel değil, hedefli.
- **VAR OLAN**: Kullanıcının halihazırda çalışan bir Quickshell + Hyprland + Lua dotfiles kurulumu var. Bu sıfırdan tasarlanmayacak — mevcut yapı `shell/` altına declarative şekilde taşınacak.
- **Tema ekosistemi**: stylix gibi soyut bir tema katmanı DEĞİL. Native Quickshell + Hyprland + Lua dotfiles'ın kendisi ekosistem. İlk sürümde 4-5 varyasyon, ileride genişletilebilir.
- **Kurulum hedefi**: Canlı ISO ile VM'e veya SSD'ye "pro" seviye kurulum. ISO üretimi ve kurulum akışı prodüksiyon kalitesinde olmalı.

## Sert kurallar

1. **Ezber yasak.** Paket adı, seçenek adı, flake girdisi veya API kullanımı yazmadan önce `nix search` ile veya web'den doğrula. Tahmin etme, halüsinasyon üretme.
2. **Her araştırma tarihli ve kaynaklı olsun.** `docs/research/` altına, "ne zaman kontrol edildi + hangi link" ile not düş.
3. **Her mimari karar bir ADR'dir.** `docs/decisions/NNNN-baslik.md` formatında yaz: bağlam, seçenekler, karar, neden. Sohbette kalan bir karar yok sayılır — çünkü bir sonraki ajan (farklı model) sadece dosyaları görecek, sohbet geçmişini değil.
4. **Her görev sonunda ROADMAP.md güncellenir.** İşaretlenmemiş bir sonraki maddeye geçmeden önce mutlaka önce onu oku.
5. **Sıfırdan tasarım yok.** Kullanıcının var olan dotfiles/config'i öncelik. Önce envanter çıkar, sonra declarative hale getir.
6. **Build/test zorunlu.** Her modül değişikliğinden sonra en azından `nixos-rebuild build-vm` ile doğrula. "Derlendi ama denemedim" kabul edilmez.
7. **Gray-hat araçları izole modüllerde tutulur** (`modules/security/`), sistemin geri kalanına sızdırılmaz.

## Yeni bir ajan/model devraldığında ilk yapacağı şey

1. Bu dosyayı oku.
2. `ROADMAP.md`'yi oku, hangi fazda olunduğunu tespit et.
3. `docs/decisions/`i oku, önceki kararları öğren.
4. İşaretlenmemiş ilk ROADMAP maddesine geç.

## Referans araçlar (2026 itibarıyla aktif, güncelliğini doğrula)

| İhtiyaç | Araç |
|---|---|
| Deklaratif disk kurulumu | disko |
| Impermanence (tmpfs/btrfs root) | nix-community/impermanence |
| Live ISO üretimi | nixos-generators |
| Uzaktan kurulum | nixos-anywhere |
| Donanım uyumu | nixos-hardware |
| Secure boot | lanzaboote |
| Uygulama sandbox'lama | nixpak |