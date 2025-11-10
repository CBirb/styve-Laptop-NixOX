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
  programs.home-manager.enable = true;

  # Git
  programs.git = {
    enable = true;
    userEmail = "stephan.heinz@gmx.at";
    userName = "CBirb";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk"; # makes Qt apps like Dolphin follow GTK theme
    style = {
      name = "Adwaita-Dark";
      package = pkgs.adwaita-qt;
    };
  };

  # xdg.portal.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";
}
