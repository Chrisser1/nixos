# NixOS Kubernetes (K3s) Infrastructure

This module manages the core Kubernetes infrastructure for our cloud environment. It uses K3s for lightweight container orchestration and ArgoCD for GitOps deployments.

## 📂 Architecture

* **`client.nix`**: Installs local CLI tools (`kubectl`, `k9s`) and the `fetch-kubeconfig` script. Apply this to your developer machine.
* **`server.nix`**: Configures the Master Node (Control Plane). Opens public web ports and the Kubernetes API.
* **`agent.nix`**: Configures Worker Nodes. Joins existing servers securely via token.
* **`deployments.nix`**: Bootstraps the core cluster infrastructure (Prometheus, ArgoCD) directly into the Master Node.

---

## 🛠️ Operating Procedures

### 1. Setting up a new Developer Machine (Client)
1. Add the `kubernetes-client` module to your local NixOS/Home-Manager config.
2. Run `rebuild` (or your equivalent rebuild command).
3. Run the custom command: `fetch-kubeconfig`.
4. Type `k9s` to access the cluster dashboard.

### 2. Setting up a new Server (Control Plane)
1. Add the `kubernetes-server` and `kubernetes-deployments` modules to the target server's Nix config.
2. Ensure the Oracle Cloud hardware firewall has ports `80`, `443`, and `6443` open.
3. Deploy the configuration. The server will boot, start K3s, and automatically install ArgoCD.

### 3. Adding a new Worker Node (Agent)
