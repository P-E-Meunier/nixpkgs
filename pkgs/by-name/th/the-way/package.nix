{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.20.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/vG5LkQiA8iPP+UV1opLeJwbYfmzqYwpsoMizpGT98o=";
  };

  cargoHash = "sha256-iZxV099582LuZ8A3uOsKPyekAQG2cQusLZhW+W1wW/8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  useNextest = true;

  postInstall = ''
    $out/bin/the-way config default tmp.toml
    for shell in bash fish zsh; do
      THE_WAY_CONFIG=tmp.toml $out/bin/the-way complete $shell > the-way.$shell
      installShellCompletion the-way.$shell
    done
  '';

  meta = with lib; {
    description = "Terminal code snippets manager";
    mainProgram = "the-way";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    changelog = "https://github.com/out-of-cheese-error/the-way/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      figsoda
      numkem
    ];
  };
}
