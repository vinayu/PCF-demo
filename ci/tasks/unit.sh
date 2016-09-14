#!/bin/bash

set -e

pushd pcfdemo
  ./mvnw clean test
popd
