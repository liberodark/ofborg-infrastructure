{ inputs, ... }:

{
  imports = [
    ../../modules/ofborg/builder.nix
    ./hardware.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];
  nix.settings = {
    extra-platforms = [
      "aarch64-linux"
      "riscv64-linux"
    ];
  };

  deployment.targetHost = "185.119.168.14";

  networking = {
    hostName = "ofborg-build05";
    domain = "ofborg.org";
    hostId = "007f0305";
  };

  disko.devices = import ./disko.nix;

  systemd.network.networks."10-uplink" = {
    matchConfig.MACAddress = "22:17:4d:04:90:cb";
    address = [ "185.119.168.14/32" ];
    routes = [
      {
        Gateway = "91.224.148.0";
        GatewayOnLink = true;
      }
    ];
    linkConfig.RequiredForOnline = "routable";
  };

  # Enable Deduplication
  nix.settings.auto-optimise-store = true;

  # Enable Garbage Collector
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 1d";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ5hBVVKK72ZX+n+BVnPocx+AG5u6ht8bM++G1lhufp liberodark@gmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJfOUACs5oAn4Hyt6uMM5e/Xux0/5ODvSeg5zOy4MY1b gaetan@glepage.com"
  ];

  system.stateVersion = "24.11";
}
