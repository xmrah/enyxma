{ config, lib, ... }:

with lib;

let
  cfg = config.enyxma.disko;

  btrfsSubvolumes = {
    "/nix" = {
      mountpoint = "/nix";
      mountOptions = [ "compress=zstd" "noatime" ];
    };
    "/persist" = {
      mountpoint = "/persist";
      mountOptions = [ "compress=zstd" "noatime" ];
    };
    "/swap" = {
      mountpoint = "/swap";
      swap.swapfile.size = cfg.swapSize;
    };
  };

  rootPartitionContent = if cfg.encrypted then {
    type = "luks";
    name = "crypted";
    settings = {
      allowDiscards = true;
    };
    content = {
      type = "btrfs";
      extraArgs = [ "-f" ];
      subvolumes = btrfsSubvolumes;
    };
  } else {
    type = "btrfs";
    extraArgs = [ "-f" ];
    subvolumes = btrfsSubvolumes;
  };
in
{
  options.enyxma.disko = {
    enable = mkEnableOption "enyxma deklaratif disk şeması (disko + tmpfs root + btrfs)";

    device = mkOption {
      type = types.str;
      default = "/dev/vda";
      description = "Bölümlendirilecek ana hedef disk aygıtı (ör. /dev/vda veya /dev/nvme0n1)";
    };

    encrypted = mkOption {
      type = types.bool;
      default = false;
      description = "LUKS2 tam disk şifreleme aktif edilsin mi? (VM için false, prodüksiyon SSD için true)";
    };

    tmpfsSize = mkOption {
      type = types.str;
      default = "8G";
      description = "RAM tabanlı tmpfs kök dizini boyutu";
    };

    swapSize = mkOption {
      type = types.str;
      default = "4G";
      description = "Btrfs swap subvolume içerisindeki swapfile boyutu";
    };
  };

  config = mkIf cfg.enable {
    disko.devices = {
      disk.main = {
        type = "disk";
        device = cfg.device;
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
              content = rootPartitionContent;
            };
          };
        };
      };
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=${cfg.tmpfsSize}"
          "mode=755"
        ];
      };
    };

    # Impermanence için /persist bağlama noktasının erken boot aşamasında hazır olmasını sağla
    fileSystems."/persist".neededForBoot = true;
  };
}
