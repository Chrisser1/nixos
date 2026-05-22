{ self, ... }: {
    flake.nixosModules.kubernetes-deployments = { config, ... }: {
        services.k3s.manifests = {

            prometheus-stack = {
                content = {
                    apiVersion = "helm.cattle.io/v1";
                    kind = "HelmChart";
                    metadata = { name = "kube-prometheus-stack"; namespace = "kube-system"; };
                    spec = {
                        chart = "kube-prometheus-stack";
                        repo = "https://prometheus-community.github.io/helm-charts";
                        targetNamespace = "monitoring";
                        createNamespace = true;
                    };
                };
            };

            argo-cd = {
                content = {
                    apiVersion = "helm.cattle.io/v1";
                    kind = "HelmChart";
                    metadata = { 
                        name = "argo-cd"; 
                        namespace = "kube-system"; 
                    };
                    spec = {
                        chart = "argo-cd";
                        repo = "https://argoproj.github.io/argo-helm";
                        targetNamespace = "argocd";
                        createNamespace = true;
                    };
                };
            };
        };
    };
}