{
  # --- Network Settings ---
  controlPlaneIp = "158.180.42.198";
  
  # --- SSH Settings ---
  controlPlaneSshAlias = "oracle-server";
  controlPlaneSshUser = "root";
  controlPlaneSshKey = "~/.ssh/ssh-key-2025-11-12.key";
  
  # --- Cluster Settings ---
  kubernetesVersion = "v1.30.0+k3s1"; 
}