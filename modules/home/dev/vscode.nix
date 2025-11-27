{ pkgs, config, lib, inputs, ... }:
let
  marketplace = pkgs.vscode-marketplace;

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
    yzane.markdown-pdf
  ];
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles = {
      default = {
        extensions = commonExtensions;
      };

      Go = {
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

      Cpp = {
        extensions = commonExtensions ++ (with marketplace; [
          ms-vscode.cpptools-extension-pack
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

      if [ -L "$PROFILE_DIR/settings.json" ]; then
        echo "Removing read-only symlink for settings in $PROFILE_DIR"
        rm -f "$PROFILE_DIR/settings.json"
      fi

      # Copy Settings if missing
      if [ ! -f "$PROFILE_DIR/settings.json" ]; then
        echo "Bootstrapping settings for $PROFILE_DIR"
        cp -f "$SETTINGS_SOURCE" "$PROFILE_DIR/settings.json"
        chmod u+w "$PROFILE_DIR/settings.json"
      fi

      if [ -L "$PROFILE_DIR/keybindings.json" ]; then
        echo "Removing read-only symlink for keybindings in $PROFILE_DIR"
        rm -f "$PROFILE_DIR/keybindings.json"
      fi

      # Copy Keybindings if missing
      if [ ! -f "$PROFILE_DIR/keybindings.json" ]; then
        echo "Bootstrapping keybindings for $PROFILE_DIR"
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

    # Bootstrap C Profile
    bootstrap_profile "${config.home.homeDirectory}/.config/Code/User/profiles/Cpp"
  '';
}