#!/bin/sh

pushd pcfdemo
  ./mvnw clean test
popd
