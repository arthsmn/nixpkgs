{
  lib,
  buildPythonPackage,
  certifi,
  charset-normalizer,
  courlan,
  fetchPypi,
  htmldate,
  justext,
  lxml,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "trafilatura";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zrcJSm7Ml+cv6nPH26NnFMXFtXe2Rw5FINyok3BtYkc=";
  };

  postPatch = ''
    # nixify path to the trafilatura binary in the test suite
    substituteInPlace tests/cli_tests.py \
      --replace-fail 'trafilatura_bin = "trafilatura"' \
                     'trafilatura_bin = "${placeholder "out"}/bin/trafilatura"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    certifi
    charset-normalizer
    courlan
    htmldate
    justext
    lxml
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Disable tests that require an internet connection
    "test_cli_pipeline"
    "test_crawl_page"
    "test_download"
    "test_feeds_helpers"
    "test_fetch"
    "test_input_type"
    "test_is_live_page"
    "test_meta_redirections"
    "test_probing"
    "test_queue"
    "test_redirection"
    "test_whole"
  ];

  pythonImportsCheck = [ "trafilatura" ];

  meta = {
    description = "Python package and command-line tool designed to gather text on the Web";
    homepage = "https://trafilatura.readthedocs.io";
    changelog = "https://github.com/adbar/trafilatura/blob/v${version}/HISTORY.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jokatzke ];
    mainProgram = "trafilatura";
  };
}
