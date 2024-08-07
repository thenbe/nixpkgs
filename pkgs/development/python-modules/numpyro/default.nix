{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  jax,
  jaxlib,
  multipledispatch,
  numpy,
  tqdm,

  # checks
  funsor,
  pytestCheckHook,
# TODO: uncomment when tensorflow-probability gets fixed.
# , tensorflow-probability
}:

buildPythonPackage rec {
  pname = "numpyro";
  version = "0.15.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-6G3TrDyQ5N2uuzLzzEus1czCtvg3M0wBorLo2vQZozE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jax
    jaxlib
    multipledispatch
    numpy
    tqdm
  ];

  nativeCheckInputs = [
    funsor
    pytestCheckHook
    # TODO: uncomment when tensorflow-probability gets fixed.
    # tensorflow-probability
  ];

  pythonImportsCheck = [ "numpyro" ];

  disabledTests = [
    # AssertionError due to tolerance issues
    "test_beta_binomial_log_prob"
    "test_collapse_beta"
    "test_cpu"
    "test_gamma_poisson"
    "test_gof"
    "test_hpdi"
    "test_kl_dirichlet_dirichlet"
    "test_kl_univariate"
    "test_mean_var"
    # Tests want to download data
    "data_load"
    "test_jsb_chorales"
    # RuntimeWarning: overflow encountered in cast
    "test_zero_inflated_logits_probs_agree"
    # NameError: unbound axis name: _provenance
    "test_model_transformation"
  ];

  # TODO: remove when tensorflow-probability gets fixed.
  disabledTestPaths = [ "test/test_distributions.py" ];

  meta = {
    description = "Library for probabilistic programming with NumPy";
    homepage = "https://num.pyro.ai/";
    changelog = "https://github.com/pyro-ppl/numpyro/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
