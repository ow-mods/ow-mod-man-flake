# ow-mod-man-flake

Flake to easily install the [outer wilds mod manager](https://github.com/ow-mods/ow-mod-man) (both cli and gui versions) in nix.

## How to Test the Program

### Testing owmods-cli
You can test it by running
```sh
nix run github:loco-choco/ow-mod-man-flake#owmods-cli
```
To pass flags and options you need to run the command like this:
```sh
nix run github:loco-choco/ow-mod-man-flake#owmods-cli -- <flags and options>
```
Examples:
```sh
#To check the version
nix run github:loco-choco/ow-mod-man-flake#owmods-cli -- --version
nix run github:loco-choco/ow-mod-man-flake#owmods-cli -- -V
#To list local and remote mods
nix run github:loco-choco/ow-mod-man-flake#owmods-cli -- list
nix run github:loco-choco/ow-mod-man-flake#owmods-cli -- list remote
```

### Testing owmods-gui
Because it uses tauri, and it is, for now (version 1.3), using `openssl-1.1.1t` (an insecure package), trying to run `nix run github:loco-choco/ow-mod-man-flake#owmods-gui` will fail with a message saying the derivation uses insecure packages. To run it then you first need to do:

```sh
export NIXPKGS_ALLOW_INSECURE=1
```

Then run:
```sh
nix run github:loco-choco/ow-mod-man-flake#owmods-gui --impure
```

Now, you should have the latest version of the gui version running.

## How to Install in the System
Imagining you have a system configuration using flakes, following [this style](https://github.com/loco-choco/dotfiles), all you need to do is:

- 1: Add the flake in the inputs, and the outputs
```nix
#Adding it to the inputs
inputs = {
  nixpkgs.url = "...";
  home-manager.url = "...";
  #Add these two lines
  ow-mod-man.url = "github:loco-choco/ow-mod-man-flake";
  ow-mod-man.inputs.nixpkgs.follows = "nixpkgs"; #Makes the flake follow the package versions in your nixpkgs versions
};

#Adding it to the outputs
outputs = { nixpkgs, home-manager, ow-mod-man, ... }@inputs: #we need the '@inputs' part to allow us to use the flake more easily
```
- 2: Pass the flake in your packages, for home-manager you would do:
```nix
home-manager.lib.homeManagerConfiguration {
  #...
  extraSpecialArgs.inputs = inputs; # inside your homeManagerConfiguration you need to add this line
  #...
};
```
And in your `home.nix` add to the input `inputs`:
```nix
{ pkgs, inputs, ... }: #add 'inputs' to the inputs of 'home.nix'
```

For the nixos configuration you would do:
```nix
nixosSystem {
  #...
  specialArgs.inputs = inputs; # inside your nixosSystem you need to add this line
  #...
};
```

And in your `configuration.nix` add the inputs:
```nix
{ config, pkgs, inputs, ...}: #add 'inputs' to the inputs of 'configuration.nix'
```

- 3: Enable the package. You can do that as if it was a normal package, but apending `inputs.ow-mod-man.packages.${system}`, like in the following example:
```nix
inputs.ow-mod-man.packages.${system}.owmods-cli
```

For owmods-gui, [like mentioned in here](#testing-owmods-gui), you need to allow insecure packages (for now), to do this [follow the manual](https://nixos.org/manual/nixpkgs/stable/#sec-allow-insecure) to allow the `openssl-1.1.1t` package. 
If you are building your system with flakes, you will need to run your `nix build` with the `--impure` flag and `export NIXPKGS_ALLOW_INSECURE=1` exported.

You can also check the current version by running
```shell
nix flake show github:loco-choco/ow-mod-man-flake
```

These steps were found in [this reddit post](https://www.reddit.com/r/NixOS/comments/omti3t/how_to_install_a_flake_package/).
