{ pkgs, lib, ... }: # [Important] Added 'lib' here to access makeBinPath

let
  # define all runtime dependencies in one list
  my-dependencies = with pkgs; [
    ripgrep-all
    fzf
    bat
    poppler-utils
    pandoc
    ffmpeg
    kdePackages.okular
  ];

  universal-search = pkgs.writeShellScriptBin "search" ''
    #!/usr/bin/env bash

    export PATH="${lib.makeBinPath my-dependencies}:$PATH"

    if ! command -v rga &> /dev/null; then
        echo "Error: ripgrep-all (rga) is not installed."
        exit 1
    fi

    RG_PREFIX="rga --files-with-matches --ignore-case"

    # Run FZF
    output=$(
      FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
      fzf --sort \
          --disabled \
          --print-query \
          --query "$1" \
          --bind "change:reload:$RG_PREFIX {q}" \
          --layout=reverse \
          --preview='rga --ignore-case --pretty --context 5 {q} {}' \
          --preview-window="up,70%:wrap" \
          --header="ENTER to open in Okular | Type to search | ESC to exit"
    )

    # If no file was selected (user hit Esc), exit
    if [[ -z "$output" ]]; then
        exit 0
    fi

    # Extract Query and File from FZF output
    query=$(echo "$output" | head -n 1)
    file=$(echo "$output" | tail -n 1)

    # Open the file
    if [[ -n "$file" ]]; then
        # Check if it's a PDF
        if [[ "$file" == *.pdf ]]; then
            echo "Opening $file matching '$query' in Okular..."
            # --find highlights the search term in Okular
            nohup okular --find "$query" "$file" >/dev/null 2>&1 &
        else
            # Fallback for other file types
            xdg-open "$file"
        fi
    fi
  '';
in
{
  home.packages = my-dependencies ++ [ universal-search ];
}