{
  lib,
  mkHyprlandPlugin,
  hyprland,
  fetchFromGitLab,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprslidr";
  version = "0-unstable-2024-12-24";

  src = fetchFromGitLab {
    owner = "magus";
    repo = "hyprslidr";
    rev = "305b92e5eb63c084449732567b665c95b89dba5d";
    hash = "sha256-f40pnnpXeOh1MkDK0zjAMnIK3VOJnvaw7skseR/F3vA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprslidr.so $out/lib/hyprslidr.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://gitlab.com/magus/hyprslidr";
    description = "A Hyprland plugin for a sliding window layout inspired by PaperWM";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ arthsmn ];
    platforms = lib.platforms.linux;
  };
}
