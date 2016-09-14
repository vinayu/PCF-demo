#!/bin/bash

version=$(cat version/number)

# rename the artifact to the final version
cp candidate-release/pcf-demo-*.war prepare-final-output/pcf-demo-$version.war
