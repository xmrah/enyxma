{ config, lib, pkgs, ... }:

with lib;

let
  hwCfg = config.enyxma.hardware;
  pCfg = hwCfg.peripherals;
in
{
  options.enyxma.hardware.peripherals = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Çevre birimleri, ses, bluetooth ve güç optimizasyonlarını etkinleştir";
    };

    bluetooth = mkOption {
      type = types.bool;
      default = true;
      description = "Bluetooth donanım ve eşleşme desteği";
    };

    audio = mkOption {
      type = types.bool;
      default = true;
      description = "PipeWire ve düşük gecikmeli ses altyapısı";
    };

    powerProfiles = mkOption {
      type = types.bool;
      default = true;
      description = "Dizüstü ve masaüstü için power-profiles-daemon yönetimi";
    };
  };

  config = mkIf (hwCfg.enable && pCfg.enable) {
    # 1. Ses Altyapısı (PipeWire + WirePlumber + RTKit)
    security.rtkit.enable = mkIf pCfg.audio true;
    services.pipewire = mkIf pCfg.audio {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    # 2. Bluetooth Desteği
    hardware.bluetooth = mkIf pCfg.bluetooth {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = mkIf pCfg.bluetooth true;

    # 3. Güç Yönetimi ve Termal Optimizasyon
    services.power-profiles-daemon.enable = mkIf pCfg.powerProfiles true;
    services.thermald.enable = mkIf pCfg.powerProfiles true;

    # 4. CPU Mikrokodları (Hem Intel hem AMD için güvenle açılır, donanım eşleşeni yüklenir)
    hardware.cpu.intel.updateMicrocode = true;
    hardware.cpu.amd.updateMicrocode = true;

    # 5. Firmware Güncellemeleri
    services.fwupd.enable = true;
  };
}
