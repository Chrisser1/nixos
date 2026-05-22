{ self, ... }:
let 
    vars = builtins.fromJSON (builtins.readFile ./cluster-vars.json);
in {
    flake.nixosModules.kubernetes-server = { pkgs, ... }: {
        services.k3s = {
            enable = true;
            role = "server";
            extraFlags = toString [
                "--disable=traefik"
                "--tls-san ${vars.controlPlaneIp}"
            ];
        };

        networking.firewall.allowedTCPPorts = [ 80 443 6443 10250 ];
        networking.firewall.allowedUDPPorts = [ 8472 ];

        environment.systemPackages = with pkgs; [
            k3s
        ];
    };
}