#!/usr/bin/env bash
# =============================================================================
# enyxma :: Sovereign System Installer
# Pürüzsüz, deklaratif ve interaktif kurulum sihirbazı
# =============================================================================

set -eo pipefail

# ANSI Renk Kodları (enyxma Cyan/Obsidyen Teması)
CYAN='\033[0;36m'
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Yardımcı Yazdırma Fonksiyonları
step() { echo -e "\n${BOLD}${CYAN}[ADIM $1]${NC} ${BOLD}$2${NC}"; }
info() { echo -e "${CYAN}==>${NC} $1"; }
ok()   { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}[UYARI]${NC} $1"; }
err()  { echo -e "${RED}[HATA]${NC} $1" >&2; exit 1; }

# Root Yetkisi Kontrolü
if [ "$EUID" -ne 0 ]; then
  echo -e "${YELLOW}Kurulum için root yetkisi gerekiyor. sudo ile başlatılıyor...${NC}"
  exec sudo "$0" "$@"
fi

clear
echo -e "${CYAN}${BOLD}"
cat << "BANNER"
  ███████╗███╗   ██╗██╗   ██╗██╗  ██╗███╗   ███╗ █████╗ 
  ██╔════╝████╗  ██║╚██╗ ██╔╝╚██╗██╔╝████╗ ████║██╔══██╗
  █████╗  ██╔██╗ ██║ ╚████╔╝  ╚███╔╝ ██╔████╔██║███████║
  ██╔══╝  ██║╚██╗██║  ╚██╔╝   ██╔██╗ ██║╚██╔╝██║██╔══██║
  ███████╗██║ ╚████║   ██║   ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║
  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝
              SOVEREIGN SYSTEM INSTALLER
BANNER
echo -e "${NC}"
echo -e "enyxma canlı kurulum ortamına hoş geldiniz."
echo -e "NixOS + Hyprland + Lua + impermanence/tmpfs tabanlı egemen sisteminizi kurun.\n"

# -----------------------------------------------------------------------------
# ADIM 1: Hedef Disk Seçimi
# -----------------------------------------------------------------------------
step 1 "Hedef Kurulum Diskini Belirleyin"
echo -e "Sistemde bulunan fiziksel ve sanal diskler:\n"
lsblk -d -p -n -o NAME,SIZE,MODEL,TRAN | grep -v "loop" || true
echo ""

read -rp "Kurulum yapılacak hedef disk aygıtı (ör. /dev/nvme0n1 veya /dev/vda): " TARGET_DISK
if [ -z "$TARGET_DISK" ] || [ ! -b "$TARGET_DISK" ]; then
  err "Geçersiz disk aygıtı belirtildi: '$TARGET_DISK'"
fi
ok "Hedef disk seçildi: $TARGET_DISK"

# -----------------------------------------------------------------------------
# ADIM 2: Tam Disk Şifreleme (LUKS2)
# -----------------------------------------------------------------------------
step 2 "Tam Disk Şifreleme (LUKS2)"
read -rp "LUKS2 (Argon2id) tam disk şifreleme aktif edilsin mi? [e/H]: " USE_LUKS
USE_LUKS=${USE_LUKS:-H}
LUKS_PASSWORD=""

if [[ "$USE_LUKS" =~ ^[eEyY]$ ]]; then
  info "Tam disk şifreleme aktif edilecek."
  while true; do
    read -rsp "Disk şifresi belirleyin: " P1
    echo ""
    read -rsp "Disk şifresini doğrulayın: " P2
    echo ""
    if [ "$P1" = "$P2" ] && [ -n "$P1" ]; then
      LUKS_PASSWORD="$P1"
      break
    else
      warn "Şifreler eşleşmedi veya boş bırakıldı. Lütfen tekrar deneyin."
    fi
  done
  ok "Disk şifresi doğrulandı."
else
  info "Şifrelemesiz düz Btrfs bölümü kullanılacak."
fi

# -----------------------------------------------------------------------------
# ADIM 3: Varsayılan Tema Tercihi
# -----------------------------------------------------------------------------
step 3 "Sistem Açılış Teması Tercihi"
echo -e "enyxma yekpare ekosistemi için varsayılan temayı seçin:"
echo -e "  ${BOLD}1)${NC} ${CYAN}Void Black${NC}   (Minimalist saf siyah, derin kömür ve cyan neon)"
echo -e "  ${BOLD}2)${NC} ${GREEN}Cyber Matrix${NC} (Siber güvenlik obsidyen ve zümrüt neonu)"
echo -e "  ${BOLD}3)${NC} Ghost White   (Yüksek kontrastlı kristal beyaz ve safir mavisi)"
echo -e "  ${BOLD}4)${NC} Slate Cobalt  (Teknik mühendislik antrasiti ve kobalt mavisi)"
echo -e "  ${BOLD}5)${NC} ${RED}Blood Amber${NC}   (Karanlık obsidyen, kızıl kehribar ve alev turuncusu)"

read -rp "Tema seçiminiz [1-5] (Varsayılan: 1): " THEME_CHOICE
THEME_CHOICE=${THEME_CHOICE:-1}

case "$THEME_CHOICE" in
  1) CHOSEN_THEME="void-black" ;;
  2) CHOSEN_THEME="cyber-matrix" ;;
  3) CHOSEN_THEME="ghost-white" ;;
  4) CHOSEN_THEME="slate-cobalt" ;;
  5) CHOSEN_THEME="blood-amber" ;;
  *) CHOSEN_THEME="void-black" ;;
esac
ok "Varsayılan tema belirlendi: $CHOSEN_THEME"

# -----------------------------------------------------------------------------
# ADIM 4: Operatör ve Sistem Kimliği
# -----------------------------------------------------------------------------
step 4 "Kullanıcı ve Sistem Kimliği"
read -rp "Operatör kullanıcı adı (Varsayılan: enyxma): " USERNAME
USERNAME=${USERNAME:-enyxma}

read -rp "Sistem ana makine adı (Hostname, Varsayılan: enyxma): " HOSTNAME
HOSTNAME=${HOSTNAME:-enyxma}

while true; do
  read -rsp "$USERNAME kullanıcısı için şifre belirleyin: " UP1
  echo ""
  read -rsp "Şifreyi tekrar girin: " UP2
  echo ""
  if [ "$UP1" = "$UP2" ] && [ -n "$UP1" ]; then
    USER_PASSWORD="$UP1"
    break
  else
    warn "Kullanıcı şifreleri eşleşmedi. Tekrar deneyin."
  fi
done
ok "Kullanıcı yapılandırması tamamlandı: $USERNAME@$HOSTNAME"

# -----------------------------------------------------------------------------
# ADIM 5: Secure Boot (Lanzaboote)
# -----------------------------------------------------------------------------
step 5 "UEFI Secure Boot (Lanzaboote/sbctl)"
read -rp "Secure Boot (UKI imzalı çekirdek) desteği aktif edilsin mi? [e/H]: " USE_SECUREBOOT
USE_SECUREBOOT=${USE_SECUREBOOT:-H}
ENABLE_SECUREBOOT="false"
if [[ "$USE_SECUREBOOT" =~ ^[eEyY]$ ]]; then
  ENABLE_SECUREBOOT="true"
  info "Secure Boot aktif edilecek."
fi

# -----------------------------------------------------------------------------
# ADIM 6: Kurulum Özeti ve Onay
# -----------------------------------------------------------------------------
step 6 "Kurulum Özeti ve Kritik Onay"
echo -e "${YELLOW}------------------------------------------------------------${NC}"
echo -e " Hedef Disk     : ${BOLD}$TARGET_DISK${NC} ${RED}(DİKKAT: TÜM VERİLER SİLİNECEK!)${NC}"
echo -e " Kök Dizin      : ${BOLD}tmpfs (RAM tabanlı ephemeral root, 8G)${NC}"
echo -e " Şifreleme      : ${BOLD}$( [[ "$USE_LUKS" =~ ^[eEyY]$ ]] && echo "LUKS2 (Aktif)" || echo "Şifresiz" )${NC}"
echo -e " Başlangıç Teması: ${CYAN}${BOLD}$CHOSEN_THEME${NC}"
echo -e " Kullanıcı      : ${BOLD}$USERNAME@$HOSTNAME${NC}"
echo -e " Secure Boot    : ${BOLD}$ENABLE_SECUREBOOT${NC}"
echo -e "${YELLOW}------------------------------------------------------------${NC}\n"

read -rp "Kuruluma başlamak için 'EVET' yazın: " CONFIRM
if [ "$CONFIRM" != "EVET" ]; then
  echo -e "\n${YELLOW}Kurulum kullanıcı tarafından iptal edildi. Hiçbir değişiklik yapılmadı.${NC}"
  exit 0
fi

# -----------------------------------------------------------------------------
# ADIM 7: Disk Biçimlendirme ve Bağlama
# -----------------------------------------------------------------------------
step 7 "Disk Bölümlendiriliyor ve Biçimlendiriliyor..."

IS_ENCRYPTED="false"
if [[ "$USE_LUKS" =~ ^[eEyY]$ ]]; then
  IS_ENCRYPTED="true"
fi

# Geçici disko yapılandırma dosyası oluştur
TMP_DISKO=$(mktemp /tmp/enyxma-disko-XXXXXX.nix)
trap 'rm -f "$TMP_DISKO"' EXIT

cat << DISKEOF > "$TMP_DISKO"
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "$TARGET_DISK";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = $( if [ "$IS_ENCRYPTED" = "true" ]; then cat << 'LUKE'
            {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/nix" = { mountpoint = "/nix"; mountOptions = [ "compress=zstd" "noatime" ]; };
                  "/persist" = { mountpoint = "/persist"; mountOptions = [ "compress=zstd" "noatime" ]; };
                  "/swap" = { mountpoint = "/swap"; swap.swapfile.size = "4G"; };
                };
              };
            };
LUKE
            else cat << 'PLNE'
            {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/nix" = { mountpoint = "/nix"; mountOptions = [ "compress=zstd" "noatime" ]; };
                "/persist" = { mountpoint = "/persist"; mountOptions = [ "compress=zstd" "noatime" ]; };
                "/swap" = { mountpoint = "/swap"; swap.swapfile.size = "4G"; };
              };
            };
PLNE
            fi );
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=8G" "mode=755" ];
    };
  };
}
DISKEOF

info "Disko ile bölümlendirme ve dosya sistemi oluşturuluyor..."
if [ "$IS_ENCRYPTED" = "true" ]; then
  # Parolayı disko'ya aktar
  KEYFILE=$(mktemp /tmp/luks-key-XXXXXX)
  echo -n "$LUKS_PASSWORD" > "$KEYFILE"
  sed -i "s|settings.allowDiscards = true;|settings = { allowDiscards = true; keyFile = \"$KEYFILE\"; };|" "$TMP_DISKO"
  nix run github:nix-community/disko -- --mode destroy,format,mount "$TMP_DISKO"
  rm -f "$KEYFILE"
else
  nix run github:nix-community/disko -- --mode destroy,format,mount "$TMP_DISKO"
fi
ok "Disk başarıyla biçimlendirildi ve /mnt dizinine bağlandı."

# -----------------------------------------------------------------------------
# ADIM 8: Hedef Sistem Yapılandırmasının Hazırlanması
# -----------------------------------------------------------------------------
step 8 "Hedef NixOS Yapılandırması /mnt/persist Dizinine Yerleştiriliyor..."
mkdir -p /mnt/persist/etc/nixos

# Mevcut repo şablonunu hedef sisteme kopyala
REPO_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
if [ -d "$REPO_ROOT/shell" ]; then
  cp -r "$REPO_ROOT"/* /mnt/persist/etc/nixos/ || true
fi

# Kullanıcı şifre özetini (hash) üret
USER_HASH=$(echo "$USER_PASSWORD" | mkpasswd -m sha-512 -s)

# Hedef flake.nix'i kullanıcı tercihlerine göre güncelle
cat << TARGETFLAKE > /mnt/persist/etc/nixos/flake.nix
{
  description = "enyxma — Gray-hat siber güvenlik ve geliştirici odaklı egemen sistem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, impermanence, nixos-facter-modules, nixos-hardware, lanzaboote, nixpak, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.\${system};
  in {
    nixosModules = {
      desktop = import ./modules/desktop;
      disko = import ./modules/disko;
      impermanence = import ./modules/impermanence;
      hardware = import ./modules/hardware;
      security = import ./modules/security;
      homeManager = (import ./shell { inherit (pkgs) lib; inherit pkgs; }).homeManagerModule;
    };

    nixosConfigurations.$HOSTNAME = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        impermanence.nixosModules.impermanence
        nixos-facter-modules.nixosModules.facter
        lanzaboote.nixosModules.lanzaboote
        self.nixosModules.desktop
        self.nixosModules.disko
        self.nixosModules.impermanence
        self.nixosModules.hardware
        self.nixosModules.security
        {
          nixpkgs.hostPlatform = system;
          system.stateVersion = "26.05";
          networking.hostName = "$HOSTNAME";

          enyxma.desktop = {
            enable = true;
            defaultTheme = "$CHOSEN_THEME";
          };

          enyxma.hardware = {
            enable = true;
            gpu.driver = "auto";
          };

          enyxma.disko = {
            enable = true;
            device = "$TARGET_DISK";
            encrypted = $IS_ENCRYPTED;
            tmpfsSize = "8G";
          };

          users.users.$USERNAME = {
            isNormalUser = true;
            hashedPassword = "$USER_HASH";
            extraGroups = [ "wheel" "video" "audio" "networkmanager" "wireshark" ];
            description = "enyxma operator";
          };

          enyxma.impermanence = {
            enable = true;
            persistPath = "/persist";
            users = [ "$USERNAME" ];
          };

          enyxma.security = {
            enable = true;
            tools.enable = true;
            tools.categories = [ "all" ];
            sandbox.enable = true;
            secureboot.enable = $ENABLE_SECUREBOOT;
          };

          boot.loader.systemd-boot.enable = $( if [ "$ENABLE_SECUREBOOT" = "true" ]; then echo "false"; else echo "true"; fi );
        }
      ];
    };
  };
}
TARGETFLAKE

ok "Hedef sistem flake.nix oluşturuldu."

# -----------------------------------------------------------------------------
# ADIM 9: nixos-install Çalıştırılması
# -----------------------------------------------------------------------------
step 9 "Sistem Kuruluyor (nixos-install)..."
nixos-install --flake "/mnt/persist/etc/nixos#$HOSTNAME" --no-root-passwd

ok "Sistem kurulumu başarıyla tamamlandı!"
echo -e "\n${GREEN}${BOLD}============================================================${NC}"
echo -e "${GREEN}${BOLD} Kurulum başarıyla tamamlandı!${NC}"
echo -e " Egemen işletim sisteminiz yeniden başlatılmaya hazır."
echo -e "${GREEN}${BOLD}============================================================${NC}\n"

read -rp "Sistemi şimdi yeniden başlatmak ister misiniz? [E/h]: " REBOOT_NOW
REBOOT_NOW=${REBOOT_NOW:-E}
if [[ "$REBOOT_NOW" =~ ^[eEyY]$ ]]; then
  info "Sistem yeniden başlatılıyor..."
  reboot
else
  info "Canlı oturumdasınız. Dilediğiniz zaman 'reboot' komutuyla sistemi başlatabilirsiniz."
fi
