# modules/home/dev/dotnet.nix
{ pkgs, config, lib, ... }:
let
  # Pick your SDK here:
  #   pkgs.dotnet-sdk     -> latest in your channel
  #   pkgs.dotnet-sdk_8   -> .NET 8 LTS
  #   pkgs.dotnet-sdk_9   -> .NET 9 (if present in your channel)
  sdk = pkgs.dotnet-sdk;
in
{
  # Core CLI (SDK includes the runtime)
  home.packages = [
    sdk
    pkgs.nuget        # optional: NuGet CLI alongside `dotnet restore`
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

  # Optional quality-of-life aliases
  programs.bash.shellAliases = {
    dn = "dotnet";
    db = "dotnet build";
    dr = "dotnet run";
    dt = "dotnet test";
  };
}
