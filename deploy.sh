#!/bin/bash

pip install setuptools wheel twine
twine upload "$TRAVIS_BUILD_DIR"/wheelhouse/*
