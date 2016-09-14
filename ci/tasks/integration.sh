#!/bin/bash

set -e

pushd pcfdemo
  ./mvnw clean verify
popd
