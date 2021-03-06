#!/bin/sh

function pre_build {

    if [ -n "$IS_OSX" ]; then
        brew install zlib
    else
        yum install -y zlib-devel
    fi
}

function run_tests {
    pip install pytest numpy
    cp ../indexed_gzip/conftest.py .
    py.test -v -s -m zran_test                  --niters 500 --pyargs indexed_gzip
    py.test -v -s -m zran_test         --concat --niters 500 --pyargs indexed_gzip
    py.test -v -s -m indexed_gzip_test          --niters 500 --pyargs indexed_gzip
    py.test -v -s -m indexed_gzip_test --concat --niters 500 --pyargs indexed_gzip
}


function build_source {
  REPO_DIR=$1
  pip install --upgrade pip setuptools
  pushd $REPO_DIR > /dev/null;
  pip install cython numpy nibabel;
  python setup.py sdist;
  cp dist/*tar.gz "$TRAVIS_BUILD_DIR"/wheelhouse/;
  popd > /dev/null;
}
