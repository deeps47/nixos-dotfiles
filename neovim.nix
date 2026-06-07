{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
    # LSP servers
    lua-language-server
    typescript-language-server
    vscode-langservers-extracted
    intelephense
    nil
    nixpkgs-fmt
    tree-sitter

    # Tools
    lazygit
    ripgrep # telescope grep
    fd # telescope find
    jq
    fd
    fzf
    gcc
  ];
}
