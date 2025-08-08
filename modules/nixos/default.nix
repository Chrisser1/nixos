{ ... }: {
  imports = [
    ./base.nix
    ./desktop.nix
    # dev.nix is optional; import it per-host if you want it everywhere, add it here.
  ];
}
