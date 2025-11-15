{ pkgs, config, lib, ... }:
let
  sdk = pkgs.dotnet-sdk_9;
in
{
  # Core CLI
  home.packages = [
    sdk
    pkgs.nuget
  ];

  # Make .NET global tools usable everywhere (`~/.dotnet/tools`)
  home.sessionPath = [
    "${config.home.homeDirectory}/.dotnet/tools"
  ];

  # Quiet, sane defaults
  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";   # disable telemetry
    DOTNET_NOLOGO = "1";                 # mute first-run banner/notice
    DOTNET_ROOT = "${sdk}";              # lets global tools/IDEs find the SDK
  };
}
