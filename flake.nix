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
        owmods-cli-v0_3_0 = pkgs.callPackage ./owmods-cli/v0.3.0/default.nix {};
        owmods-cli-v0_3_1 = pkgs.callPackage ./owmods-cli/v0.3.1/default.nix {};
        owmods-cli-v0_4_0 = pkgs.callPackage ./owmods-cli/v0.4.0/default.nix {};
        owmods-cli-v0_5_0 = pkgs.callPackage ./owmods-cli/v0.5.0/default.nix {};
        owmods-cli-v0_5_1 = pkgs.callPackage ./owmods-cli/v0.5.1/default.nix {};
        owmods-cli-v0_6_0 = pkgs.callPackage ./owmods-cli/v0.6.0/default.nix {};
        owmods-cli-v0_6_1 = pkgs.callPackage ./owmods-cli/v0.6.1/default.nix {};


      in rec {
        # For `nix build` & `nix run`:
        packages = rec {
          owmods-cli_0_2_0 = owmods-cli-v0_2_0;
          owmods-cli_0_3_0 = owmods-cli-v0_3_0;
          owmods-cli_0_3_1 = owmods-cli-v0_3_1;
          owmods-cli_0_4_0 = owmods-cli-v0_4_0;
          owmods-cli_0_5_0 = owmods-cli-v0_5_0;
          owmods-cli_0_5_1 = owmods-cli-v0_5_1;
          owmods-cli_0_6_0 = owmods-cli-v0_6_0;
          owmods-cli_0_6_1 = owmods-cli-v0_6_1;

          owmods-cli = owmods-cli_0_6_1;
          default = owmods-cli;
        };
        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo openssl libsoup ];
        };
      }
    );
}
