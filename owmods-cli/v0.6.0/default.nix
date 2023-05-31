{ lib
, pkg-config
, openssl
, libsoup
, fetchFromGitHub
, installShellFiles
, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "owmods-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Bwc9876";
    repo = "ow-mod-man";
    rev = "cli_v${version}";
    sha256 = "sha256-yuiC/BbjGjynOp9MUAhZGL6KBf4f4HUl1KYcKHlCNg0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-fs-watch-0.0.0" = "sha256-M6uGcf4UWAU+494wAK/r2ta1c3IZ07iaURLwJJR9F3U=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    libsoup
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
