{
  description = "System-wide tools via Nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system}.default = pkgs.buildEnv {
        name = "system-tools";

        paths = with pkgs; [
          # editors / shell
          tmux

          # cli utils
          ripgrep
          fd
          bat
          eza
          curl
          wget
          git
          zoxide
          stow
          fastfetch
          starship
          fzf
          fd
          gh
          gawk
          acpi
          lazygit
          ffmpeg
          opencode
          cmus
          tokei
          rumno

          # dev tools
          zig
          gnumake
          go_1_24
          nodejs_24
          pnpm
          python315
          uv
          odin

          # BEAM
          inotify-tools
          elixir-ls
          xdg-utils
          watchman
        ];
      };
    };
}
