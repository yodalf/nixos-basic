{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  virtualisation.vmware.guest.enable = true;

  security.tpm2 =
    {
      enable = true;
      abrmd.enable = true;
    };

  # Bootloader.
  boot =
    {
      loader.systemd-boot.enable = true;
      binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
      loader.efi.canTouchEfiVariables = true;
    };

  nixpkgs.config.allowUnfree = true;

  nix =
    {
      settings =
        {
          experimental-features = [ "nix-command" "flakes" "repl-flake" ];
          max-jobs = "auto";
          cores = 0;
          auto-optimise-store = true;
        };

      gc =
        {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 7d";
        };
    };

  system =
    {
      autoUpgrade.enable = true;
    };

  networking =
    {
      hostName = "nixos";
      networkmanager.enable = true;
    };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  services =
    {
      printing.enable = false;

      xserver =
        {
          enable = true;
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
          layout = "us";
          xkbVariant = "";
          displayManager =
            {
              autoLogin.enable = true;
              autoLogin.user = "realo";
            };
        };

    };

  # Enable sound with pipewire.
  #sound.enable = true;
  #hardware.pulseaudio.enable = false;
  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  # If you want to use JACK applications, uncomment this
  #  #jack.enable = true;
  #};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.realo = {
    isNormalUser = true;
    description = "realo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;


  environment.systemPackages = with pkgs; [
    vim-full
    wget
    tpm2-tools
    tpm2-tss
    tpm2-pkcs11
    openssl
    s3fs
    awscli2
    git
    hugo
    go
    btop
    qemu
    nixpkgs-fmt
    brave
    firefox
  ];

  programs.ssh.startAgent = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "23.05"; # Did you read the comment?

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

}
