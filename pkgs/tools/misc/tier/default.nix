{ lib
, stdenv
, fetchurl
,
}:
let
  pname = "tier";
  version = "0.10.0";
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/tierrun/tier/releases/download/v${version}/tier_${version}_linux_amd64.tar.gz";
    sha256 = "sha256-vH8+KCY9kZIYJYGuERyc7Dqe49kQb93O4HMACdCvluQ=";
  };

  # buildInputs = [pkgs.glibc];

  unpackPhase = ''
    tar -xzf $src
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp tier $out/bin/tier
  '';

  meta = {
    changelog = "https://github.com/tierrun/tier/releases/tag/v${version}";
    description = "tier is a tool that lets you define and manage your SaaS application's pricing model in one place (pricing.json).";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/tierrun/tier";
  };
}
