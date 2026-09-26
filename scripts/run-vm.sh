#!/usr/bin/env bash
# =============================================================================
# enyxma :: Sanal Makine (VM) Test ve Simülasyon Aracı
# =============================================================================

set -eo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${CYAN}==>${NC} ${BOLD}$1${NC}"; }
ok()   { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}[UYARI]${NC} $1"; }
err()  { echo -e "${RED}[HATA]${NC} $1" >&2; exit 1; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

VM_DIR="$REPO_DIR/.vm-test"
DISK_IMG="$VM_DIR/disk.qcow2"
DISK_SIZE="25G"

# QEMU ve KVM Denetimi
if ! command -v qemu-system-x86_64 &>/dev/null; then
  err "qemu-system-x86_64 bulunamadı. Lütfen QEMU paketini yükleyin."
fi

KVM_FLAG=""
if [ -e /dev/kvm ] && [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
  KVM_FLAG="-enable-kvm"
  ok "KVM donanım hızlandırması devrede."
else
  warn "/dev/kvm erişilebilir değil veya desteklenmiyor. VM emülasyon modunda çalışacak (yavaş olabilir)."
fi

# -----------------------------------------------------------------------------
# FONKSİYON 1: Hedef Kurulu Masaüstü VM Testi
# -----------------------------------------------------------------------------
run_desktop_vm() {
  info "1. Hedef Kurulu Sistem VM Derleniyor ve Başlatılıyor..."
  echo -e "Bu mod, enyxma'nın hedef kurulu sistemini (Pure Lua Hyprland, Quickshell, 5 tema) doğrudan QEMU içinde başlatır.\n"
  
  nix run .#vm
}

# -----------------------------------------------------------------------------
# FONKSİYON 2: Canlı ISO ve Kurulum Sihirbazı VM Testi
# -----------------------------------------------------------------------------
run_iso_vm() {
  info "2. Canlı ISO ve Kurulum VM Ortamı Hazırlanıyor..."
  mkdir -p "$VM_DIR"

  if [ ! -f "$DISK_IMG" ]; then
    info "Hedef sanal disk oluşturuluyor: $DISK_IMG ($DISK_SIZE)..."
    qemu-img create -f qcow2 "$DISK_IMG" "$DISK_SIZE"
    ok "Sanal test diski hazırlandı."
  else
    ok "Mevcut sanal disk kullanılacak: $DISK_IMG"
  fi

  info "Canlı ISO imajı derleniyor (nix build .#iso)..."
  nix build .#iso

  ISO_PATH="$REPO_DIR/result/iso/enyxma.iso"
  if [ ! -f "$ISO_PATH" ]; then
    err "ISO imajı bulunamadı: $ISO_PATH"
  fi

  ok "Canlı ISO imajı hazır: $ISO_PATH"
  info "QEMU başlatılıyor..."
  echo -e "${YELLOW}İpucu: Live oturum açıldığında 'enyxma-install' sihirbazını sanal disk (/dev/vda) üzerinde güvenle deneyebilirsiniz.${NC}\n"

  # QEMU Grafik Sürücüsü Seçimi (Wayland / GL)
  qemu-system-x86_64 \
    $KVM_FLAG \
    -m 4G \
    -smp 4 \
    -cpu host \
    -cdrom "$ISO_PATH" \
    -boot d \
    -drive file="$DISK_IMG",if=virtio,format=qcow2 \
    -vga virtio \
    -device intel-hda -device hda-duplex \
    -net nic,model=virtio -net user \
    -name "enyxma Live ISO Test VM"
}

# -----------------------------------------------------------------------------
# FONKSİYON 3: Kurulmuş Sanal Diskten Başlatma
# -----------------------------------------------------------------------------
run_installed_vm() {
  info "3. Kurulmuş Sanal Diskten Boot Ediliyor..."
  if [ ! -f "$DISK_IMG" ]; then
    err "Henüz bir sanal disk oluşturulmamış veya kurulum yapılmamış. Önce '2' (Canlı ISO) seçeneğiyle kurulum yapın."
  fi

  info "Sanal diskten önyükleme yapılıyor ($DISK_IMG)..."
  qemu-system-x86_64 \
    $KVM_FLAG \
    -m 4G \
    -smp 4 \
    -cpu host \
    -drive file="$DISK_IMG",if=virtio,format=qcow2 \
    -boot c \
    -vga virtio \
    -device intel-hda -device hda-duplex \
    -net nic,model=virtio -net user \
    -name "enyxma Installed Disk VM"
}

# -----------------------------------------------------------------------------
# FONKSİYON 4: Test Ortamını Temizleme
# -----------------------------------------------------------------------------
clean_vm() {
  warn "Sanal makine test diski ($DISK_IMG) silinecek."
  read -rp "Onaylıyor musunuz? [e/H]: " CONFIRM
  if [[ "$CONFIRM" =~ ^[eEyY]$ ]]; then
    rm -rf "$VM_DIR"
    ok "Test ortamı temizlendi."
  else
    info "İptal edildi."
  fi
}

# -----------------------------------------------------------------------------
# Giriş Noktası ve Menü
# -----------------------------------------------------------------------------
MODE="${1:-}"

case "$MODE" in
  desktop|d|1)
    run_desktop_vm
    ;;
  iso|i|2)
    run_iso_vm
    ;;
  installed|disk|s|3)
    run_installed_vm
    ;;
  clean|c|4)
    clean_vm
    ;;
  help|-h|--help)
    echo "Kullanım: $0 [desktop | iso | installed | clean]"
    exit 0
    ;;
  *)
    clear
    echo -e "${CYAN}${BOLD}"
    cat << "BANNER"
  ███████╗███╗   ██╗██╗   ██╗██╗  ██╗███╗   ███╗ █████╗ 
  ██╔════╝████╗  ██║╚██╗ ██╔╝╚██╗██╔╝████╗ ████║██╔══██╗
  █████╗  ██╔██╗ ██║ ╚████╔╝  ╚███╔╝ ██╔████╔██║███████║
  ██╔══╝  ██║╚██╗██║  ╚██╔╝   ██╔██╗ ██║╚██╔╝██║██╔══██║
  ███████╗██║ ╚████║   ██║   ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║
  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝
              VM TEST VE SİMÜLASYON SİSTEMİ
BANNER
    echo -e "${NC}"
    echo -e "Lütfen test etmek istediğiniz VM modunu seçin:\n"
    echo -e "  ${BOLD}1)${NC} ${CYAN}Hedef Masaüstü VM Testi${NC} (Kurulu Hyprland + Quickshell sistemini doğrudan VM'de çalıştırır)"
    echo -e "  ${BOLD}2)${NC} ${GREEN}Canlı ISO & Kurulum Testi${NC} (Canlı ISO'yu 25G sanal disk ile açar, enyxma-install'ı test eder)"
    echo -e "  ${BOLD}3)${NC} ${YELLOW}Kurulmuş Sanal Diski Başlat${NC} (ISO ile kurulan sanal diskten boot eder)"
    echo -e "  ${BOLD}4)${NC} ${RED}Sanal Test Diskini Temizle${NC} (.vm-test/ dizinini sıfırlar)"
    echo -e "  ${BOLD}5)${NC} Çıkış\n"

    read -rp "Seçiminiz [1-5]: " CHOICE
    case "$CHOICE" in
      1) run_desktop_vm ;;
      2) run_iso_vm ;;
      3) run_installed_vm ;;
      4) clean_vm ;;
      *) exit 0 ;;
    esac
    ;;
esac
