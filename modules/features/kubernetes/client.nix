{ self, ... }: {
    flake.homeModules.kubernetes-client = { pkgs, ... }: {
        home.packages = with pkgs; [
            kubectl
            kubernetes-helm
            k9s
        ];
    };
}