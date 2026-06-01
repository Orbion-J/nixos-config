# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./local/configuration.nix
      # <home-manager/nixos>
    ];

  # Automatic upgrade (via channel)
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "lama-e121"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     # keyMap = "fr";
     useXkbConfig = true; # use xkb.options in tty.
  };

  
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
    	addons = with pkgs; [
      	# fcitx5-mozc
      	# fcitx5-gtk
    	];
	quickPhrase = {
		bla = "";
	};
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager.lightdm.greeters.gtk = {
    	enable = true;
	indicators = [ "~host" "~space" "~clock" "~language" "~power" ];
	extraConfig =
	''
	[greeter]
	background=/etc/lightdm/background.jpg
	active-monitor=0
	'';
    };

    windowManager.i3.enable = true;

    # Configure keymap in X11
    xkb.layout = "fr";
    xkb.options = "compose:menu";
    # xkb.options = "eurosign:e,caps:escape";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.picom.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # services.pipewire.enable = false;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ClamAV antivirus
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robin = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio"
      "video"
      "networkmanager"
    ];
    packages = with pkgs; [
      firefox	# browser
      chromium	# browser
      zathura	# pdf viewer
      evince	# pdf viewer
      nomacs	# image viewer
      vlc	# video viewer
      rclone	# cloud
      lazygit	# gitutils
      libreoffice	# bureautique
      gimp	# image manipulation
      pulseaudio	# sound management
      pavucontrol	# sound management
      xclip	# for clipboard in console (eg neovim)
      wine64	# windows emulation
      
      zotero	# bibliography
      typst	# Typst
      tinymist	# Typst lsp
      texlive.combined.scheme-full	# LaTeX

      python312	# Python
      coq	# Rocq
      # rocq-core	# Rocq
      rocqPackages.vsrocq-language-server
      vscodium	# editor for Rocq

    ];
  };

  # users.users.admin-lama = {
  #   isNormalUser = true;
  #   createHome = false;
  #   extraGroups = [ "wheel" "networkmanager" ];
  # };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
     # Editors
     vim
     neovim
     # Utils
     wget
     htop
     killall
     git
     unzip
     tree
     gnumake
     gcc
     rocmPackages.llvm.clang-unwrapped	# clang utilities (including c formatter)
     stylua	# lua formatter
     file
     man-pages
     man-pages-posix
     # Environment
     kitty	# terminal
     polybarFull	# bar
     nitrogen	# wallpaper
     flameshot	# snapshot
     arandr	# multi screen
     fastfetch	# display system info
     # Misc
     clamav	# antivirus
  ];

  fonts.packages = with pkgs; [
    ibm-plex
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  environment.shellAliases = { 
    n = "nvim";
    g = "lazygit";
    z = "zathura";
    k = "kitty &";
    icat = "kitty +icat";
  };

  programs.bash.promptInit = 
  ''
    # Provide a nice prompt
    PROMPT_COLOR="1;31m"
    ((UID)) && PROMPT_COLOR="1;32m"
    PS1="\n\[\033[$PROMPT_COLOR\]\u@\h \w \\$\[\033[0m\] "
  '';

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

}

