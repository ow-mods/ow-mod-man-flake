{
  description = "Flake for owmods-cli and owmods-gui";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/master";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };
        #cli version
        _owmods-cli = pkgs.callPackage ./owmods-cli/default.nix {};
        ##gui version
        _owmods-gui = pkgs.callPackage ./owmods-gui/default.nix {};
      in rec {
        # For `nix build` & `nix run`:
        packages = rec {
          owmods-cli = _owmods-cli;
          owmods-gui = pkgs.callPackage ./owmods-gui/default.nix {};
          default = owmods-cli;
        };        
        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo openssl libsoup ];
        };
      }
    );
}
