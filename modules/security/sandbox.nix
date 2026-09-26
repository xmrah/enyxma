{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.enyxma.security.sandbox;

  # Bubblewrap tabanlı izole çalıştırma betiği (enyxma-sandbox)
  # Ana sistemdeki /persist, SSH anahtarları ve kalıcı verileri tecrit eder.
  sandboxScript = pkgs.writeShellScriptBin "enyxma-sandbox" ''
    set -euo pipefail

    if [ "$#" -eq 0 ]; then
      echo "Kullanım: enyxma-sandbox [--net] <komut> [argümanlar...]"
      echo "Seçenekler:"
      echo "  --net    Ağ erişimine izin ver (varsayılan: ağ kapalı)"
      exit 1
    fi

    SHARE_NET=""
    if [ "$1" = "--net" ]; then
      SHARE_NET="--share-net"
      shift
    fi

    # Geçici sandbox çalışma dizini
    SANDBOX_TMP=$(mktemp -d /tmp/enyxma-box-XXXXXX)
    trap 'rm -rf "$SANDBOX_TMP"' EXIT

    echo "[enyxma-sandbox] İzolasyon kafesi başlatılıyor: $1" >&2

    exec ${pkgs.bubblewrap}/bin/bwrap \
      --ro-bind /nix/store /nix/store \
      --ro-bind-try /bin /bin \
      --ro-bind-try /usr/bin /usr/bin \
      --ro-bind-try /etc /etc \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      --tmpfs "$HOME" \
      --dir "$SANDBOX_TMP/workspace" \
      --bind "$SANDBOX_TMP/workspace" /workspace \
      --chdir /workspace \
      --unshare-all \
      $SHARE_NET \
      --die-with-parent \
      -- "$@"
  '';
in
{
  options.enyxma.security.sandbox = {
    enable = mkEnableOption "enyxma Bubblewrap & Nixpak tabanlı tecrit kafesi";

    isolateHome = mkOption {
      type = types.bool;
      default = true;
      description = "Kullanıcı ev dizini ve SSH anahtarlarına erişimi sandbox içinde engelle";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.bubblewrap
      sandboxScript
    ];
  };
}
