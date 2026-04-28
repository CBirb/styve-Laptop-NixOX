{ config, pkgs, ... }:

{

  # ----------------------------
  # Basic user settings
  # ----------------------------
  home.username = "steve";
  home.homeDirectory = "/home/steve";

  # ----------------------------
  # Enable Home Manager programs
  # ----------------------------
 
  # wayland.windowManager.hyprland.enable = true;  
 
  programs = {
    home-manager.enable = true;
    kitty.enable = true;
  };
  
  programs.git.settings = {
    enable = true;
    userName  = "CBirb";
    userEmail = "stephan.heinz@gmx.at";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.sessionPath = [
    "${builtins.getEnv "HOME"}/bin"
    "${builtins.getEnv "HOME"}/.miktex/texmfs/install/miktex/bin"
  ];

  # services.picom = {
  #   enable = true;
  # };
  ## Force Section Start

  ## Force Section End

  programs.fuzzel = {
  enable = true;
  settings = {
    main = {
      font = "JetBrainsMono Nerd Font:size=14"; # Größere Schrift
      width = 40;                              # Breite in Zeichen
      line-height = 25;                        # Zeilenabstand für mehr vertikalen Raum
      fields = "name,generic,comment,categories,filename,keywords";
      terminal = "kitty";
    };
    colors = {
      background = "282a36ff";                 # Beispiel-Farbe (Dracula)
      text = "f8f8f2ff";
    };
    border = {
      width = 2;
      radius = 10;
    };
  };
};
 
  
  home.sessionVariables = {
    XDG_DATA_DIRS = "/usr/share:/usr/local/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    FONTCONFIG_PATH = "/etc/fonts";
  };  

  

  home.stateVersion = "24.11";
}
