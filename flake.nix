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

        owmods-gui-v0_2_0 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.2.0";
                                                                        fileName = "ow-mod-manager";
                                                                        sha256="sha256-2oeK1IetR5Ui9zhocP8r1nGIs7hSGp88tzc4ck4Jwo4=";});
        owmods-gui-v0_2_1 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.2.1";
                                                                        fileName = "ow-mod-manager";
                                                                        sha256="sha256-Kt41DDW3jf569z9Rt+It37KkiL4d0AuPggPfaHWa2nw=";});
        owmods-gui-v0_2_2 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.2.2";
                                                                        fileName = "ow-mod-manager";
                                                                        sha256="sha256-7+GZJVV1GsddJM1uzvFQE9ig6ApeREC0Q5nACKIiRRk=";});
        owmods-gui-v0_3_0 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.3.0";
                                                                        sha256="sha256-+/GW3gNlEMbzjvtplwEpjjf8R/yBNQHPUZeMFUHEP1g=";});
        owmods-gui-v0_3_1 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.3.1";
                                                                        sha256="sha256-nsf5x7qw8Ld5cGcbjfx0xqJQ3DjtiOZGqDBTKc6kX0k=";});
        owmods-gui-v0_4_0 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.4.0";
                                                                        sha256="sha256-0rfr1Xdwviv3JSxpeowoo3wHOfEGF1NiA+jUVv910mw=";});
        owmods-gui-v0_5_0 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.5.0";
                                                                        sha256="sha256-0QGc9bblEKiLrviggLzYQNFpN6XwmQp4eDMH0ysFYeE=";});
        owmods-gui-v0_5_1 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.5.1";
                                                                        sha256="sha256-squMH8TIdMAQsl6b428fWvh1fzT+VLa3RcNkjJ/kteU=";});
        owmods-gui-v0_6_0 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.6.0";
                                                                        sha256="sha256-rm7KZEGkEH8z8Jb39Qc3tlt1xSMFEAPnkHuoGQ+ad/U=";});
        owmods-gui-v0_6_1 = pkgs.callPackage ./owmods-gui/generic.nix ({version="0.6.1";
                                                                        sha256="sha256-lMBUrVfAeTwwtwyGY2J331O3dODSUK/YjF+1V1bRggI=";});

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

          owmods-gui_0_2_0 = owmods-gui-v0_2_0;
          owmods-gui_0_2_1 = owmods-gui-v0_2_1;
          owmods-gui_0_2_2 = owmods-gui-v0_2_2;
          owmods-gui_0_3_0 = owmods-gui-v0_3_0;
          owmods-gui_0_3_1 = owmods-gui-v0_3_1;
          owmods-gui_0_4_0 = owmods-gui-v0_4_0;
          owmods-gui_0_5_0 = owmods-gui-v0_5_0;
          owmods-gui_0_5_1 = owmods-gui-v0_5_1;
          owmods-gui_0_6_0 = owmods-gui-v0_6_0;
          owmods-gui_0_6_1 = owmods-gui-v0_6_1;

          owmods-cli = owmods-cli_0_6_1;
          owmods-gui = owmods-gui_0_6_1;
          default = owmods-cli;
        };
        apps = {
          type = "app";
          program = "${self.packages.${system}.owmods-gui}/bin/outer-wilds-mod-manager";
        };

        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo openssl libsoup ];
        };
      }
    );
}
