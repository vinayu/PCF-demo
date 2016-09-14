#!/bin/bash

set -e

version=$(cat version/number)

pushd pcfdemo
  ./mvnw clean package -Pci -DversionNumber=$version
popd

# Copy war file to build output folder
artifact="pcf-demo-$version.war"

cp pcfdemo/target/$artifact build-output/$artifact
