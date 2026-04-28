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
      ./coding.nix
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

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
    # desktopManager = {
    #   xterm.enable = false;
    #   xfce.enable = true;
    # };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  # Cinnamon Desktop
  # services.xserver.desktopManager.cinnamon.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Gnome QT
  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  #   style = "adwaita-dark";
  # };

  # Gnome Services
  # networking.networkingManager.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-hyprland
    #   lxqt.xdg-desktop-portal-lxqt
    ];
  };
    
  fonts.packages = with pkgs;
    (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)) ++ [
      # Add any extra fonts here, e.g. dejavu_fonts, noto-fonts, etc.
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        noto-fonts-cjk-serif
        julia-mono
        liberation_ttf
        dejavu_fonts
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
        bront_fonts
        ucs-fonts
        nerd-fonts.droid-sans-mono
        nerd-fonts.fira-code 
    ];

  fonts.fontconfig.enable = true;

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

  # Power Management
  # 1. Disable the default GNOME power manager to avoid conflicts
  services.power-profiles-daemon.enable = false;

  # 2. Enable TLP
  services.tlp = {
    enable = true;
    settings = {
      # Optional: Fine-tune for your Ryzen 5 7530U
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      # Helps with AMD-specific power saving
      PLATFORM_PROFILE_ON_BAT = "low-power";
      PLATFORM_PROFILE_ON_AC = "performance";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.steve = {
    isNormalUser = true;
    description = "steve";
    extraGroups = [ "networkmanager" "wheel" "podman" "kvm" "libvirtd" "audio" "video" "input" "disk" "libvirt" "libvirtd" "render" "realtime" "openrazer" "gamemode" "podman" ];
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
    neovim
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
    lsb-release
    eza

    # Terminal
    ghostty
    yazi
    yaziPlugins.git 
    yaziPlugins.sudo
    yaziPlugins.ouch
    yaziPlugins.nord
    yaziPlugins.lsar
    yaziPlugins.glow
    yaziPlugins.diff
    yaziPlugins.rsync
    yaziPlugins.piper
    yaziPlugins.mount
    yaziPlugins.gitui
    yaziPlugins.dupes
    yaziPlugins.chmod
    yaziPlugins.miller
    # yaziPlugins.mactag
    yaziPlugins.duckdb
    yaziPlugins.bypass
    yaziPlugins.yatline
    yaziPlugins.restore
    yaziPlugins.lazygit
    yaziPlugins.starship
    yaziPlugins.projects
    yaziPlugins.mime-ext
    yaziPlugins.compress
    yaziPlugins.vcs-files
    yaziPlugins.mediainfo
    yaziPlugins.bookmarks

    # Other Tools
    stable.woeusb
    smartmontools
    nagiosPlugins.check_smartmon
    gsmartcontrol
    xfsprogs
    libxfs  
    sysstat
    busybox  
    steghide
    uutils-coreutils-noprefix
    coreutils-full
    gnupg

    # My Stuff
    unstable.parabolic

    # Container
    distrobox
    podman
    podman-desktop
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
    # openrazer-daemon
    # polychromatic    
    

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
    postgrest
    postgresql
    pgadmin4-desktopmode
    
    # GIT
    # stable.github-runner
    # stable.github-desktop
    # stable.github-backup
    # stable.github-release

    # Codeberg
    stable.codeberg-cli
    stable.codeberg-pages
    stable.fjo

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

    # Coding Editors
    zed-editor

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
    
    # Gaming
    angband
    crawl
    nethack
    # dungeon
    nudoku
    # 2048-cli
    bastet
    dwarf-fortress
    brogue-ce
    # empire
    vitetris

    # Fun Tools
    ani-cli
    mpv
    browsh

    ## Desktop Tools  
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.konsole
    kdePackages.yakuake
    kdePackages.qmlkonsole
    kdePackages.partitionmanager
    kdePackages.kpmcore
    kdePackages.discover
    gvfs
    gnome-terminal     
    stable.xfce.thunar
    stable.xfce.thunar-volman
    stable.xfce.thunar-dropbox-plugin
    stable.xfce.thunar-vcs-plugin
    stable.xfce.thunar-archive-plugin
    stable.xfce.thunar-media-tags-plugin
    cinnamon-control-center
    cinnamon-menus
    cinnamon-control-center
    cinnamon
    cinnamon-desktop
    cinnamon-translations
    mint-l-theme
    mint-themes
    andromeda-gtk-theme
    nemo-with-extensions
    nemo-python
    nemo-preview
    nemo-emblems
    nemo-seahorse
    nemo-fileroller
    nemo-qml-plugin-dbus
    folder-color-switcher
    gvfs
    gnome.gvfs
    xfce.tumbler
    gdk-pixbuf
    gdk-pixbuf-xlib
    ffmpegthumbnailer    
    gnome-tweaks
 
    # Hyprland
    waybar
    kitty
    hyprpaper
    hyprpicker
    hyprlauncher
    hypridle
    hyprlock
    hyprsysteminfo
    hyprsunset
    hyprpolkitagent
    hyprland-qt-support
    # hyprqt6engine
    hyprpwcenter
    # hyprshutdown
    hyprtoolkit
    hyprcursor
    hyprutils
    hyprlang
    hyprwayland-scanner
    aquamarine
    hyprgraphics
    # hyprland-guiutils    
    fuzzel
    brightnessctl
    pavucontrol
    # brightness-controller

    # Gnome Tools
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.arc-menu

    # Surfing
    gnunet
    gnunet-gtk
    gnunet-messenger-cli
    libgnurl
    libgnunetchat

  ];

  # T
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
    DISTROBOX_HOST_PACKAGE_PATH = "/run/current-system/sw";
  };
  
  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };
  nix.settings.auto-optimise-store = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

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
