{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, glib
, gjs
, blueprint-compiler
, gtk4
, wrapGAppsHook4
, desktop-file-utils
, appstream
, appstream-glib
, pkg-config
, cmake
, 
}:

stdenv.mkDerivation rec {
  pname = "biblioteca";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "workbenchdev";
    repo = "Biblioteca";
    rev = "v${version}";
    hash = "sha256-Ws2ZusFYDY/Jurb5ouRklmIVckgotxHaWEgYUGlsXYA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
    appstream
    appstream-glib
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    gtk4
    gjs
    
  ];

  patches = [
    ./find-blueprint-compiler.patch
    ./fix-gjspack.patch
  ];

  meta = with lib; {
    description = "Documentation viewer for GNOME";
    homepage = "https://github.com/workbenchdev/Biblioteca";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "biblioteca";
    platforms = platforms.all;
  };
}
