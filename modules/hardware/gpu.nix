{ config, lib, pkgs, ... }:

with lib;

let
  hwCfg = config.enyxma.hardware;
  gpuCfg = hwCfg.gpu;

  isNvidia = gpuCfg.driver == "nvidia" || gpuCfg.driver == "hybrid-intel-nvidia" || gpuCfg.driver == "hybrid-amd-nvidia";
  isHybridIntel = gpuCfg.driver == "hybrid-intel-nvidia";
  isHybridAmd = gpuCfg.driver == "hybrid-amd-nvidia";
in
{
  options.enyxma.hardware.gpu = {
    driver = mkOption {
      type = types.enum [
        "auto"
        "modesetting"
        "amd"
        "intel"
        "nvidia"
        "hybrid-intel-nvidia"
        "hybrid-amd-nvidia"
      ];
      default = "auto";
      description = "Grafik bağdaştırıcısı ve GPU sürücü profili";
    };

    nvidia = {
      open = mkOption {
        type = types.bool;
        default = true;
        description = "Nvidia açık kaynak çekirdek modülleri (Turing ve daha yeni GPU'lar) kullanılsın mı?";
      };

      intelBusId = mkOption {
        type = types.str;
        default = "";
        description = "Hibrit Intel-Nvidia sistemler için Intel PCI Bus ID (ör. PCI:0:2:0)";
      };

      nvidiaBusId = mkOption {
        type = types.str;
        default = "";
        description = "Hibrit sistemler için Nvidia PCI Bus ID (ör. PCI:1:0:0)";
      };

      amdgpuBusId = mkOption {
        type = types.str;
        default = "";
        description = "Hibrit AMD-Nvidia sistemler için AMD PCI Bus ID (ör. PCI:5:0:0)";
      };
    };
  };

  config = mkIf hwCfg.enable {
    # 1. Donanım Hızlandırmalı Grafikler (Wayland / Hyprland ve Quickshell için zorunlu)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    # 2. X11 / Wayland Video Sürücüleri
    services.xserver.videoDrivers = mkDefault (
      if isNvidia then [ "nvidia" ]
      else [ "modesetting" ]
    );

    # 3. Nvidia Özel Yapılandırması
    hardware.nvidia = mkIf isNvidia {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = gpuCfg.nvidia.open;

      prime = mkIf (isHybridIntel || isHybridAmd) {
        offload.enable = true;
        intelBusId = mkIf isHybridIntel gpuCfg.nvidia.intelBusId;
        amdgpuBusId = mkIf isHybridAmd gpuCfg.nvidia.amdgpuBusId;
        nvidiaBusId = gpuCfg.nvidia.nvidiaBusId;
      };
    };
  };
}
