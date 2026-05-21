{ self, ... }: {
    flake.homeModules.kubernetes-server = { pkgs, ... }: {
        services.k3s = {
            enable = true;
            role = "server";
            extraFlags = toString [
                "--disable=traefik"
            ];
        };

        networking.firewall.allowedTCPPorts = [ 6443 10250 ];
        networking.firewall.allowedUDPPorts = [ 8472 ];

        environment.systemPackages = with pkgs; [
            k3s
        ];
    };
}