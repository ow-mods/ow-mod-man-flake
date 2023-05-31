{
  description = "Flake for owmods-cli and owmods-gui";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        owmods-cli-v0_2_0 = pkgs.callPackage ./owmods-cli/v0.2.0/default.nix {};

      in rec {
        # For `nix build` & `nix run`:
        packages = rec {
          owmods-cli_0_2_0 = owmods-cli-v0_2_0;
          owmods-cli = owmods-cli_0_2_0;
          default = owmods-cli;
        };
        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo openssl libsoup ];
        };
      }
    );
}
