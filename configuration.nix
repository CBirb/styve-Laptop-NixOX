# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./game.nix
      ./virt.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_AT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

   # Cinnamon
  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "at";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.steve = {
    isNormalUser = true;
    description = "steve";
    extraGroups = [ "networkmanager" "wheel" "podman" "kvm" "libvirtd" "audio" "video" "input" "disk" "libvirt" "render" "realtime" "openrazer" "gamemode" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  
  # Z-Ram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  # This refers to the uncompressed size, actual memory usage will be lower.
    memoryPercent = 37;
  };

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Udisk
  services.udisks2.enable = true;

  # ClamAv
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;



  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    parted 
    gparted
    stable.insync
    bash
    kdePackages.ffmpegthumbs
    ocamlPackages.ffmpeg
    ffmpeg
    ffmpeg-full
    ffmpeg-normalize
    zenity
    gnome-disk-utility
    clamav
    clamtk
    qemu
    gitFull
    unzip
    unrar
    stable.megasync
    mission-center
    bat
    ptyxis
    freetype
    clinfo 
    unixtools.fdisk
    util-linux
    unixtools.util-linux
    libuuid
    unixtools.fsck
    toybox
    pciutils
    dmidecode    
    samba
    kdePackages.kdenetwork-filesharing
    

    # Other Tools
    stable.woeusb
    smartmontools
    nagiosPlugins.check_smartmon
    gsmartcontrol
    xfsprogs
    libxfs  
    sysstat
    busybox  

    # My Stuff
    unstable.parabolic

    # Container
    distrobox
    podman-compose
    docker-compose
    kubernix
    kubernetes
    kubergrunt
    gearlever

    # Virt-Manager
    dnsmasq 

    # Appimage
    # fetchurl
    appimage-run
    libappimage
    freerdp      

    # Razer
    openrazer-daemon
    polychromatic    
    

    # Pkg
    pkg  
    pkgsite
    pkgdiff
    pkgconf
    pkg-config
 
    ## Sys-Monitoring
    htop
    btop
    fastfetch

    ## BTRFS  Tools
    btrfs-progs
    btrfs-assistant
    btrfs-list
    btrfs-heatmap

    # Uni-Tools
    texliveTeTeX
    texliveFull
    miktex
    texliveGUST
    texliveBookPub
    texstudio
    anki-bin
    
    # GIT
    stable.github-runner
    stable.github-desktop
    stable.github-backup
    stable.github-release

    # Coding Tools
    valgrind
    python314
    python313
    python311
    python310
    libgcc
    zulu
    rustc
    rustup
    go
    rocmPackages.clang

    ## AMD
    mesa.opencl
    mesa
    mesa-demos
    driversi686Linux.mesa
    mesa-gl-headers
    driversi686Linux.mesa-demos
    opencl-headers
    libva
    libva-utils
    vulkan-tools
    vulkan-loader
    vulkan-headers
    vulkan-utility-libraries
    # amdvlk
    # driversi686Linux.amdvlk
    amdgpu_top
    amdenc
    amdctl
    amd-ucodegen
    amd-libflame
    nvtopPackages.amd
    rocmPackages.amdsmi
    lact 
    zluda
    rocmPackages.rocminfo
    # rocmPackages.clr    
     

    ## Desktop Tools  
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.konsole
    kdePackages.yakuake
    kdePackages.qmlkonsole
    kdePackages.partitionmanager
    kdePackages.kpmcore
    gvfs
    gnome-terminal     

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
