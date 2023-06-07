{ lib
, fetchFromGitHub
, protobuf
, rustPlatform
, pkg-config
, openssl
, extra-cmake-modules
, fontconfig
, testers
, turbo
,
}:
let
  version = "1.10.2";
  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    sha256 = "sha256-bQAqYSsbT7E7AL/o7wCp0kViCvCvSS4lWwh+DmHlgy4=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "turbo";
  inherit src version;
  cargoBuildFlags = [
    "--package"
    "turbo"
  ];
  RELEASE_TURBO_CLI = "true";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    pkg-config
    extra-cmake-modules
    protobuf
  ];
  buildInputs = [
    openssl
    fontconfig
  ];

  # Browser tests time out with chromium and google-chrome
  doCheck = false;

  passthru.tests.version = testers.testVersion { package = turbo; };

  meta = with lib; {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mpl20;
  };
}
