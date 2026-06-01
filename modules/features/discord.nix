{ self, ... }: {
  flake.nixosModules.discord = { pkgs, ... }: {
    environment.systemPackages = [
      # --disable-gpu-sandbox: GPU process crashes on NVIDIA+Wayland (DMA-BUF v3/v5
      # mismatch causes the GPU process to die when rendering camera/background effects)
      (pkgs.symlinkJoin {
        name = "discord";
        paths = [ pkgs.discord ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/discord \
            --add-flags "--disable-gpu-sandbox"
        '';
      })
    ];
  };
}
