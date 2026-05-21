{ self, ... }: {
    flake.homeModules.kubernetes-client = { pkgs, ... }: {
        home.packages = with pkgs; [
            kubectl
            kubernetes-helm
            k9s

            (writeShellScriptBin "fetch-kubeconfig" ''
                set -e # Stop the script if any command fails

                echo "☁️  Fetching kubeconfig from Oracle Server..."
                mkdir -p ~/.kube
                scp oracle-server:/etc/rancher/k3s/k3s.yaml ~/.kube/config

                echo "🔒 Securing permissions..."
                chmod 600 ~/.kube/config

                echo "🌐 Patching IP address..."
                # Automatically replace localhost with your Oracle public IP
                sed -i 's/127.0.0.1/158.180.42.198/g' ~/.kube/config

                echo "✅ Kubeconfig successfully configured!"
                echo "🚀 Type 'k9s' to connect to your cluster."
            '')
        ];
    };
}