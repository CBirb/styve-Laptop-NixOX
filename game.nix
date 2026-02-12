{ config, pkgs, lib, ... }:

{

  # AMD Stuff
  boot.initrd.kernelModules = [ "amdgpu" ];  
  services.xserver.videoDrivers = [ "amdgpu" ];

  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  # ];

  # systemd.packages = with pkgs; [ lact ];
  # systemd.services.lactd.wantedBy = ["multi-user.target"];

  # services.lact.enable = true;

  
  # AMD-GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.clr
      libva
      mesa.opencl
    ];  
  };
  hardware.amdgpu.opencl.enable = true;


  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  
   # Steam
   programs = {
     gamescope = {
       enable = true;
       capSysNice = true;
     };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        libkrb5
        keyutils
        # Viele UE4/UE5 Spiele brauchen diese:
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        # xorg.libXscrnsaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
      ];
    };
    };
  };
  # hardware.xone.enable = true; # support for the xbox controller USB dongle
  services.getty.autologinUser = "steve";
  environment = {
    systemPackages = [ pkgs.mangohud ];
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
    '';
  };

  # Gamemode
  programs.gamemode.enable = true;


}
