{ stdenv
, lib
, dpkg
, version
, sha256
, fileName ? "outer-wilds-mod-manager"
, fetchurl
, autoPatchelfHook
, glib-networking
, openssl_1_1
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "owmods-gui";
  inherit version;

  src = fetchurl {
    inherit sha256;
    url = "https://github.com/Bwc9876/ow-mod-man/releases/download/gui_v${version}/${fileName}_${version}_amd64.deb";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    glib-networking
    openssl_1_1
    webkitgtk
    wrapGAppsHook
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = "mv usr $out";
  meta = with lib; {
    description = "GUI version of the mod manager for Outer Wilds Mod Loader";
    homepage = "https://github.com/Bwc9876/ow-mod-man/tree/main/owmods_gui";
    downloadPage = "https://github.com/Bwc9876/ow-mod-man/releases/tag/gui_v${version}";
    changelog = "https://github.com/Bwc9876/ow-mod-man/releases/tag/gui_v${version}";
    mainProgram = "owmods";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ locochoco ];
  };
}
