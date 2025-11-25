{ pkgs, config, lib, inputs, ... }:
let
  marketplace = pkgs.vscode-marketplace;

  # commonSettings = lib.importJSON ./vscode-settings.json;
  # commonKeybindings = lib.importJSON ./vscode-keybindings.json;

  commonExtensions = with marketplace; [
    bbenoist.nix
    docker.docker
    eamodio.gitlens
    formulahendry.docker-explorer
    github.copilot
    github.vscode-github-actions
    h5web.vscode-h5web
    hediet.vscode-drawio
    janisdd.vscode-edit-csv
    johnpapa.vscode-cloak
    mechatroner.rainbow-csv
    mikestead.dotenv
    mkhl.direnv
    ms-azuretools.vscode-containers
    ms-azuretools.vscode-docker
    ms-vsliveshare.vsliveshare
    njpwerner.autodocstring
    pkief.material-icon-theme
    streetsidesoftware.code-spell-checker
    tomoki1207.pdf
    usernamehw.errorlens
  ];
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles = {
      default = {
        enableExtensionUpdateCheck = false;
        extensions = commonExtensions;
      };

      Go = {
        # Concatenate common extensions with Go-specific ones
        extensions = commonExtensions ++ (with marketplace; [
          bradlc.vscode-tailwindcss
          golang.go
          xabikos.javascriptsnippets
        ]);
      };

      Python = {
        extensions = commonExtensions ++ (with marketplace; [
          ms-python.debugpy
          ms-python.python
          ms-python.vscode-pylance
          ms-python.vscode-python-envs
          ms-toolsai.jupyter
          ms-toolsai.jupyter-keymap
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
        ]);
      };
    };
  };

  home.activation.boostrapVscodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Function to bootstrap a profile
    bootstrap_profile() {
      PROFILE_DIR="$1"
      SETTINGS_SOURCE="${./vscode-settings.json}"
      KEYS_SOURCE="${./vscode-keybindings.json}"

      # Ensure the directory exists
      mkdir -p "$PROFILE_DIR"

      # Copy Settings if missing
      if [ ! -f "$PROFILE_DIR/settings.json" ]; then
        echo "Bootstrapping VS Code settings for $PROFILE_DIR"
        cp -f "$SETTINGS_SOURCE" "$PROFILE_DIR/settings.json"
        chmod u+w "$PROFILE_DIR/settings.json"
      fi

      # Copy Keybindings if missing
      if [ ! -f "$PROFILE_DIR/keybindings.json" ]; then
        echo "Bootstrapping VS Code keybindings for $PROFILE_DIR"
        cp -f "$KEYS_SOURCE" "$PROFILE_DIR/keybindings.json"
        chmod u+w "$PROFILE_DIR/keybindings.json"
      fi
    }

    # Bootstrap Default Profile
    bootstrap_profile "${config.home.homeDirectory}/.config/Code/User"

    # Bootstrap Go Profile
    bootstrap_profile "${config.home.homeDirectory}/.config/Code/User/profiles/Go"

    # Bootstrap Python Profile
    bootstrap_profile "${config.home.homeDirectory}/.config/Code/User/profiles/Python"
  '';
}