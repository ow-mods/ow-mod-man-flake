# ow-mod-man-flake

Flake to easily install the [outer wilds mod manager](https://github.com/Bwc9876/ow-mod-man) (both cli and gui versions) in nix.

## Prerequisites
While the tools by them selfs, the manager calls .Net Framework programs, so to have it fully functional you need to enable [mono](https://search.nixos.org/packages?show=mono).

## How to Test the Program

### Testing owmods-cli
You can test it by running
```sh
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli
```
To pass flags and options you need to run the command like this:
```sh
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- <flags and options>
```
Examples:
```sh
#To check the version
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- --version
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- -V
#To list local and remote mods
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- list
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- list remote
```

### Testing owmods-gui
Because it uses tauri, and it is, for now (version 1.3), using `openssl-1.1.1t` (an insecure package), trying to run `nix run github:ShoosGun/ow-mod-man-flake/main#owmods-gui` will fail with a message saying the derivation uses insecure packages. To run it then you first need to do:

```sh
export NIXPKGS_ALLOW_INSECURE=1
```

Then run:
```sh
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-gui --impure
```

Now, you should have the latest version of the gui version running.

## How to Install in the System
Imagining you have a system configuration using flakes, following [this style](https://github.com/ShoosGun/dotfiles), all you need to do is:

- 1: Add the flake in the inputs, and the outputs
```nix
#Adding it to the inputs
inputs = {
  nixpkgs.url = "...";
  home-manager.url = "...";
  #Add these two lines
  ow-mod-man.url = "github:ShoosGun/ow-mod-man-flake/main";
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
You can then specify one of the following versions
```nix
owmods-cli_0_2_0
owmods-cli_0_3_0
owmods-cli_0_3_1
owmods-cli_0_4_0
owmods-cli_0_5_0
owmods-cli_0_5_1
owmods-cli_0_6_0
owmods-cli_0_6_1
```
or keep it as `owmods-cli` to always use the latest version (v0.6.1).

For owmods-gui, [like mentioned in here](#testing-owmods-gui), you need to allow insecure packages (for now), to do this [follow the manual](https://nixos.org/manual/nixpkgs/stable/#sec-allow-insecure) to allow the `openssl-1.1.1t` package. 
If you are building your system with flakes, you will need to run your `nix build` with the `--impure` flag and `export NIXPKGS_ALLOW_INSECURE=1` exported.

You can also check what are the avaiable versions by running
```shell
nix flake show github:ShoosGun/ow-mod-man-flake/main
```

These steps were found in [this reddit post](https://www.reddit.com/r/NixOS/comments/omti3t/how_to_install_a_flake_package/).
