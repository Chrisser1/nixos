{ self, ... }: {
    flake.nixosModules.kubernetes-deployments = { config, ... }: {
        services.k3s.manifest = {

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

            gym-bros = {
                content = {
                    apiVersion = "apps/v1";
                    kind = "Deployment";
                    metadata = { 
                        name = "gym-bros"; 
                        namespace = "default"; 
                    };
                    spec = {
                        replicas = 1;
                        selector = {
                            matchLabels = { 
                                app = "gym-bros"; 
                            };
                        };
                        template = {
                            metadata = {
                                labels = { 
                                    app = "gym-bros"; 
                                };
                            };
                            spec = {
                                containers = [
                                    {
                                        name = "gym-bros";
                                        image = "";
                                        ports = [
                                            { containerPort = 8080; };
                                        ];
                                    }
                                ];
                            };
                        };
                    };
                }
            }
        }
    };
}