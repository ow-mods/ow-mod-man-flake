## How to test the program
You can test it by running
```nix
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli
```
To pass flags and options you need to run the command like this:
```nix
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- <flags and options>
```
Examples:
```nix
#To check the version
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- --version
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- -V
#To list local and remote mods
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- list
nix run github:ShoosGun/ow-mod-man-flake/main#owmods-cli -- list remote
```
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

- 3: Enable the package. You can do that as if it was a normal package, but first writing ` `, like in the following example:
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
You can also check what are the avaiable versions by running
```shell
nix flake show github:ShoosGun/ow-mod-man-flake/main
```

These steps were found in [this reddit post](https://www.reddit.com/r/NixOS/comments/omti3t/how_to_install_a_flake_package/).
