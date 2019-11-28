{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixos";
  networking.wireless.enable = true;
  networking.wireless.networks = (import ./networks.nix);

  networking.interfaces.enp14s0.useDHCP = true;
  networking.interfaces.wlp13s0.useDHCP = true;

  time.timeZone = "Europe/Ljubljana";

  environment.systemPackages = with pkgs; [
    neovim 
    firefox
    git
    mpv
    nodejs
    alacritty
    dmenu
    polybar
    xorg.xkbcomp
    wmctrl
    rustc
  ];

  services.printing.enable = true;

  sound.enable = true;

  services.compton = {
    enable = true;
    backend = "glx";
    vSync = true;
  };

  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.startx.enable = true;
    desktopManager.default = "none";

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;

      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
    windowManager.default = "xmonad";
  };

  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  users.users.ziga = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "19.09";
}
