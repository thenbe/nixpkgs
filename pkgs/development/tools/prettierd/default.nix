{ lib
, mkYarnPackage
, fetchFromGitHub
, makeWrapper
, nodejs
, fetchYarnDeps
,
}:
mkYarnPackage rec {
  pname = "prettierd";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "prettierd";
    rev = "v${version}";
    hash = "sha256-sEoYOem3Ans+7wCLSLES2HxzobsPzzFu4X5t4JOhGLA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-JBUKVNb6E3Iw1Oy5Ide3SaHgESCq4npUGEWZ7YEZhoI=";
  };

  packageJSON = ./package.json;

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)
    yarn --offline build
    runHook postBuild
  '';

  # prettierd needs to be wrapped with nodejs so that it can be executed
  postInstall = ''
    wrapProgram "$out/bin/prettierd" --prefix PATH : "${nodejs}/bin"
  '';

  doDist = false;

  meta = with lib; {
    mainProgram = "prettierd";
    description = "Prettier, as a daemon, for improved formatting speed";
    homepage = "https://github.com/fsouza/prettierd";
    license = licenses.isc;
    changelog = "https://github.com/fsouza/prettierd/blob/${src.rev}/CHANGELOG.md";
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ NotAShelf n3oney ];
  };
}
