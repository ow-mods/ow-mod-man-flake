#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch nix-prefetch-github jq wget

#modified version of https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/servers/readarr/update.sh
set -e

dirname="$(dirname "$0")"

updateGuiHash()
{
    version=$1

    url="https://github.com/ow-mods/ow-mod-man/releases/download/gui_v$version/outer-wilds-mod-manager_${version}_amd64.deb"
    sha256=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash to-sri --type sha256 $sha256)"

    sed -i "s|hash = \"[a-zA-Z0-9\/+-=]*\";|hash = \"$sriHash\";|g" "$dirname/owmods-gui/default.nix"
}

updateCliHash()
{
    version=$1

    url="https://github.com/ow-mods/ow-mod-man/releases/cli_v$version"
    prefetchJson=$(nix-prefetch-github ow-mods ow-mod-man --rev cli_v$version)
    sha256="$(echo $prefetchJson | jq -r ".sha256")"

    sed -i "s|hash = \"[a-zA-Z0-9\/+-=]*\";|hash = \"sha256-$sha256\";|g" "$dirname/owmods-cli/default.nix"

    #download and replace funny .lock file
    wget https://raw.githubusercontent.com/ow-mods/ow-mod-man/cli_v$version/Cargo.lock -q -O $dirname/owmods-cli/Cargo.lock
    
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/owmods-cli/default.nix"
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/owmods-gui/default.nix"
}

currentVersionName="$(cd $dirname && nix flake show . --json | jq -r '.packages."x86_64-linux"."owmods-gui".name')"
currentVersion="$(expr $currentVersionName : 'owmods-gui-\(.*\)')"
echo "current version: ${currentVersion}" 

latestTag=$(curl https://api.github.com/repos/ow-mods/ow-mod-man/releases | jq -r ".[0].tag_name")
latestVersion=${latestTag#*v} 
echo "latest version: ${latestVersion}"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "owmods is up-to-date!"
    exit 0
fi
echo "updating..."
updateVersion $latestVersion

updateGuiHash $latestVersion
echo "updated gui"
updateCliHash $latestVersion
echo "updated cli"
