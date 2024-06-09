{ lib
, clangStdenv
, fetchFromGitHub
, fetchzip
, cmake

, openssl
, curl
, kdePackages

, pulseaudio
, xorg

, libzip
}: let
  nlohmann_json = fetchzip {
    url = "https://github.com/nlohmann/json/releases/download/v3.7.3/include.zip";
    hash = "sha256-h8czZ4f5vZqvHkDVQawrQdUeQnWxewu4OONisqlrmmM=";
    stripRoot = false;
  };

  glfw = fetchzip {
    url = "https://github.com/minecraft-linux/glfw/archive/fce9121962bc0a21c39e2d6f8e08bad30c566c72.zip";
    hash = "sha256-fV1BZtPAjrHY+eYrkTiItU3PaU7EeV/nBxQc7mxzsDo=";
  };
  
  stdenv = clangStdenv;
in rec {
  mcpelauncher-msa = stdenv.mkDerivation (finalAttrs: {
    pname = "mcpelauncher-msa";
    version = "0.9.0";

    src = fetchFromGitHub {
      owner = "minecraft-linux";
      repo = "msa-manifest";
      rev = "v${finalAttrs.version}";
      hash = "sha256-DzYRW0xt3/bUEEh7onUIt6DSt+LiyDhX/Iln7lEerdw=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      kdePackages.wrapQtAppsHook
    ];

    buildInputs = [
      openssl
      curl
      kdePackages.qtbase
      kdePackages.qtwebengine
    ];

    cmakeFlags = [
      "-DENABLE_MSA_QT_UI=ON"
      "-DMSA_UI_PATH_DEV=OFF"
      "-DFETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON_EXT=${nlohmann_json}"
      "-DQT_VERSION=6"
      "-DUSE_SYSTEM_CURL=ON"
    ];
    
    meta = with lib; {
      description = "The manifest (main) repository for Microsoft Account login daemon";
      homepage = "https://github.com/minecraft-linux/msa-manifest";
      license = with licenses; [gpl3Only mit];
      maintainers = with maintainers; [ arthsmn ];
      mainProgram = "msa-ui-qt";
      platforms = platforms.all;
    };
  });

  mcpelauncher-client = stdenv.mkDerivation (finalAttrs: {
    pname = "mcpelauncher-client";
    version = "0.15.0-qt6";

    src = fetchFromGitHub {
      owner = "minecraft-linux";
      repo = "mcpelauncher-manifest";
      rev = "v${finalAttrs.version}";
      hash = "sha256-yiJqYtccdvp7hwYlz+e8nMCylCYOU1IRJDYCmsA2Ij8=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      kdePackages.wrapQtAppsHook
    ];

    buildInputs = [
      openssl
      curl
      kdePackages.qtbase
      kdePackages.qtwebengine
      kdePackages.qttools
      pulseaudio
      xorg.libXinerama
    ];

    cmakeFlags = [
      "-DGAMEWINDOW_SYSTEM=GLFW"
      "-DGLFW_BUILD_WAYLAND=ON"
      "-DENABLE_DEV_PATHS=OFF"
      "-DFETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON_EXT=${nlohmann_json}"
      "-DFETCHCONTENT_SOURCE_DIR_GLFW3_EXT=${glfw}"
      "-DJNI_USE_JNIVM=ON"
      "-DBUILD_UI=ON"
      "-DBUILD_CLIENT=ON"
      "-DUSE_OWN_CURL=OFF"
      "-DMSA_DAEMON_PATH=${mcpelauncher-msa}"
    ];
    
    meta = with lib; {
      description = "The manifest (main) repository for Microsoft Account login daemon";
      homepage = "https://github.com/minecraft-linux/msa-manifest";
      license = with licenses; [gpl3Only mit];
      maintainers = with maintainers; [ arthsmn ];
      mainProgram = "mcpelauncher-client";
      platforms = platforms.all;
    };
  });

  mcpelauncher-ui = stdenv.mkDerivation (finalAttrs: {
    pname = "mcpelauncher-ui";
    version = "0.15.0-qt6";

    src = fetchFromGitHub {
      owner = "minecraft-linux";
      repo = "mcpelauncher-ui-manifest";
      rev = "v${finalAttrs.version}";
      hash = "sha256-F+8jizhJMfL6WCI+zbVT8jh1PeHkn6vQOrChs2kmoK0=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      kdePackages.wrapQtAppsHook
    ];

    buildInputs = [
      openssl
      curl
      kdePackages.qtbase
      kdePackages.qtwebengine
      kdePackages.qttools
      kdePackages.qtsvg
      xorg.libXinerama
      libzip
    ];

    cmakeFlags = [
      "-DQt5QuickCompiler_FOUND=OFF"
      "-DLAUNCHER_ENABLE_GOOGLE_PLAY_LICENCE_CHECK=ON"
      "-DLAUNCHER_DISABLE_DEV_MODE=ON"
      "-DFETCHCONTENT_SOURCE_DIR_GLFW3_EXT=${glfw}"
      "-DGAME_LAUNCHER_PATH=${mcpelauncher-client}"
    ];
    
    meta = with lib; {
      description = "The manifest (main) repository for Microsoft Account login daemon";
      homepage = "https://github.com/minecraft-linux/msa-manifest";
      license = with licenses; [gpl3Only mit];
      maintainers = with maintainers; [ arthsmn ];
      mainProgram = "mcpelauncher-ui-qt";
      platforms = platforms.all;
    };
  });
}
