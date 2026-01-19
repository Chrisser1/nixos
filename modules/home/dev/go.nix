{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    go
    gcc
    gopls   # Go Language Server
    delve   # Debugger
    gotools # Additional tools (goimports, etc.)
  ];

  # Add ~/go/bin to PATH so installed binaries work globally
  home.sessionPath = [
    "${config.home.homeDirectory}/go/bin"
  ];

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
  };
}