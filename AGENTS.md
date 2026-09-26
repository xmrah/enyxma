# AGENTS.md — enyxma

Bu dosya, bu repoda çalışan her AI ajanının (Claude Opus, Gemini Pro/Flash, veya başka bir model) ilk okuması gereken tek doğruluk kaynağıdır. Model değişse bile kurallar değişmez.

## Proje ne, ne değil

- **enyxma**: NixOS + Hyprland + Lua + impermanence/tmpfs tabanlı, her cihazda otomatik uyum hedefleyen, gray-hat siber güvenlik ve geliştirici odaklı egemen bir sistem.
- **DEĞİL**: Omarchy veya CachyOS gibi genel amaçlı bir "dağıtım" değil. Hedefli, teknik ve profesyonel bir ekosistem.
- **SIFIRDAN TASARIM**: Quickshell + Hyprland + Lua ekosistemi sıfırdan tasarlanır; kimsenin kişisel dotfiles'ı veya dışarıdan rastgele ayarlar kopyalanmaz. Tertemiz ve bağımsızdır.
- **Tema ekosistemi**: stylix gibi soyut ve hantal bir katman DEĞİL. Native Quickshell + Hyprland + Lua'nın kendisi yekpare ekosistemdir. İlk sürümde 4-5 seçkin varyasyon gelir (Void Black, Cyber Matrix, Ghost White, Slate Cobalt, Blood Amber), ileride genişletilebilir.
- **Kurulum hedefi**: Canlı ISO ile sanal makineye (VM) veya doğrudan SSD'ye "pro" seviye pürüzsüz kurulum.

## Sert kurallar

1. **Ezber yasak.** Paket adı, seçenek adı, flake girdisi veya API kullanımı yazmadan önce `nix search` ile veya web'den doğrula. Tahmin etme, halüsinasyon üretme.
2. **Her araştırma tarihli ve kaynaklı olsun.** `docs/research/` altına, "ne zaman kontrol edildi + hangi link" ile not düş.
3. **Her mimari karar bir ADR'dir.** `docs/decisions/NNNN-baslik.md` formatında yaz: bağlam, seçenekler, karar, neden. Sohbette kalan bir karar yok sayılır.
4. **Ajan tek başına mimari karar vermez.** Seçenekleri, artı/eksilerini ve kaynaklarını kullanıcıya sunar; kararı kullanıcı verir.
5. **Her görev sonunda ROADMAP.md güncellenir.** İşaretlenmemiş bir sonraki maddeye geçmeden önce mutlaka önce onu oku.
6. **Build/test zorunlu.** Her modül değişikliğinden sonra en azından `nixos-rebuild build-vm` veya `nix eval` ile doğrula. "Derlendi ama denemedim" kabul edilmez.
7. **Gray-hat araçları izole modüllerde tutulur** (`modules/security/`), sistemin geri kalanına sızdırılmaz.

## Yeni bir ajan/model devraldığında ilk yapacağı şey

1. Bu dosyayı oku.
2. `ROADMAP.md`'yi oku, hangi fazda olunduğunu tespit et.
3. `docs/decisions/`i oku, önceki kararları öğren.
4. İşaretlenmemiş ilk ROADMAP maddesine geç.

## Referans araçlar ve Güncel Durum (2026-09-26 itibarıyla doğrulandı)

| İhtiyaç | Araç / Yöntem | Durum (2026) | Kaynak |
|---|---|---|---|
| Deklaratif disk kurulumu | `disko` | Aktif (Standart) | https://github.com/nix-community/disko |
| Impermanence (tmpfs/btrfs root) | `impermanence` | Aktif (Standart) | https://github.com/nix-community/impermanence |
| Live ISO üretimi | `nixpkgs native` (`system.build.isoImage`) | Aktif (`nixos-generators` arşivlendi) | `nixpkgs/nixos/modules/installer/cd-dvd/` |
| Uzaktan kurulum | `nixos-anywhere` | Aktif (Opsiyonel) | https://github.com/nix-community/nixos-anywhere |
| Donanım uyumu | `nixos-hardware` & `nixos-facter` | Aktif | https://github.com/NixOS/nixos-hardware |
| Secure boot | `lanzaboote` | Aktif (UKI/sbctl) | https://github.com/nix-community/lanzaboote |
| Uygulama sandbox'lama | `nixpak` | Aktif (bwrap tabanlı) | https://github.com/nixpak/nixpak |
