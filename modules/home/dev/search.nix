{ pkgs, ... }:
let
  universal-search = pkgs.writeShellScriptBin "search" ''
    #!/usr/bin/env bash
    
    if ! command -v rga &> /dev/null; then
        echo "Error: ripgrep-all (rga) is not installed."
        exit 1
    fi

    RG_PREFIX="rga --files-with-matches"
    
    # We wrap the preview command in "bash -c" so it works even if your shell is Fish
    # We fixed the quoting so filenames with spaces (like in your screenshot) don't break
    
    file="$(
      FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
      fzf --sort \
          --disabled \
          --query "$1" \
          --bind "change:reload:$RG_PREFIX {q}" \
          --layout=reverse \
          --preview="bash -c '[[ ! -z {} ]] && rga --pretty --context 5 {q} {}'" \
          --preview-window="up,70%:wrap" \
          --header="Type to search content in PDFs, Docs, and Code..."
    )"
    
    if [[ -n "$file" ]]; then
        xdg-open "$file"
    fi
  '';
in
{
  home.packages = with pkgs; [
    ripgrep-all
    fzf
    bat
    universal-search
  ];
}