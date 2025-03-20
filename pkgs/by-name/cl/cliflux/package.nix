{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cliflux";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "spencerwi";
    repo = "cliflux";
    tag = "v${version}";
    hash = "sha256-AGkinlN5Ng0LXau6U9Ft+yMIFMpbrbup3R3c3UlglEM=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-3nNvPQMnYRZlhUab0MSf39vMNidpMLJh56JSjlsrYAg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A terminal client for Miniflux RSS reader";
    homepage = "https://github.com/spencerwi/cliflux";
    changelog = "https://github.com/spencerwi/cliflux/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "cliflux";
  };
}
