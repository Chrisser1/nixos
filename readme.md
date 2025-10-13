# Setup Github secret token for nix flake update
1.  **Generate the Token**: [Create a new token on GitHub](https://github.com/settings/tokens/new). No scopes/
2. **Create secrets.nix**: Create a file called secrets.nix in the root of the project and add the following.
```nix
{
  githubToken = "ghp_YOUR_PERSONAL_ACCESS_TOKEN_HERE";
}
```

# wifi login code
```bash
nmcli con add type wifi con-name "DTUsecure" ssid "DTUsecure" 802-1x.identity "USERNAME" 802-1x.password "PASSWORD" 802-1x.eap "peap" 802-1x.phase2-auth "mschapv2"
```

# Python environment
To download a python environment use:
```bash
nix-shell -E 'with import <nixpkgs> {}; (pkgs.buildFHSEnv { name = "fhs"; }).env'
```
and then
```bash
micromamba env create -f environment.yml
```