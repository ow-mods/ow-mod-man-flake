{ lib
, pkg-config
, version
, sha256
, lockFile ? ./Cargo-${version}.lock
, outputHashes ? {}
, openssl
, libsoup
, mono
, fetchFromGitHub
, installShellFiles
, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "owmods-cli";
  inherit version;

  src = fetchFromGitHub {
    inherit sha256;
    owner = "Bwc9876";
    repo = "ow-mod-man";
    rev = "cli_v${version}";
  };

  cargoLock = {
    inherit lockFile;
    inherit outputHashes;
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    libsoup
    mono
  ];

  buildAndTestSubdir = "owmods_cli";

  postInstall = ''
    cargo xtask dist_cli
    installManPage man/man*/*
    installShellCompletion --cmd owmods \
    dist/cli/completions/owmods.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "CLI version of the mod manager for Outer Wilds Mod Loader";
    homepage = "https://github.com/Bwc9876/ow-mod-man/tree/main/owmods_cli";
    downloadPage = "https://github.com/Bwc9876/ow-mod-man/releases/tag/cli_v${version}";
    changelog = "https://github.com/Bwc9876/ow-mod-man/releases/tag/cli_v${version}";
    mainProgram = "owmods";
    license = licenses.gpl3;
    maintainers = with maintainers; [ locochoco ];
  };
}
