{ pkgs, scripts }:

let
  # Import the modules from the separate file
  modules = import ./modules.nix { inherit pkgs scripts; };
in 
{
  mainBar = {
    position = "top";
    layer = "top";
    height = 18;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 10;
    margin-right = 10;
    
    # Left: Hardware stats
    "modules-left" = [ 
      "group/hardware"
      "mpris"
    ];

    # Center: Workspaces
    "modules-center" = [ 
      "hyprland/workspaces" 
    ];

    # Right: Tools (Audio, Net, Battery) + Clock
    "modules-right" = [ 
      "group/tools"
      "clock"
      "custom/power"
    ];
  } // modules; # Merge the module definitions into the main config
}