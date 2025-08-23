{
    pkgs,
    ...
}:
{
    home.packages = with pkgs; [
        # C compiler and language server
        clang-tools # Includes clangd for IDEs and clang for compiling

        # Debugger
        gdb

        # Build tools
        cmakep
        pkg-config # Helps find installed libraries
    ];
}