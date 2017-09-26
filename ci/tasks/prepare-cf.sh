#!/bin/bash
#
# All CF_* variables are provided externally from this script

set -e

if [ "true" = "$CF_SKIP_SSL" ]; then
  cf api $CF_API_URL --skip-ssl-validation
else
  cf api $CF_API_URL
fi

# Login to CF
cf auth $CF_USERNAME $CF_PASSWORD

# Create org if it doesn't exist
HAS_ORG=$(cf orgs | grep $CF_ORG || true)
if [ -z "$HAS_ORG" ]; then
  cf create-org $CF_ORG
fi

cf target -o $CF_ORG

# Create space if it doesn't exist
HAS_SPACE=$(cf spaces | grep $CF_SPACE || true)
if [ -z "$HAS_SPACE" ]; then
  cf create-space $CF_SPACE
fi

cf target -s $CF_SPACE

# Create RabbitMQ service if it doesn't exist
# HAS_SERVICE=$(cf services | grep $CF_MQ_SERVICE_NAME || true)
# if [ -z "$HAS_SERVICE" ]; then
#  cf create-service $CF_MQ_SERVICE_PARAMS
# fi

# copy the artifact to the task output folder
cp candidate-release/pcf-demo-*.war prepare-cf-output/.

pushd prepare-cf-output

ARTIFACT_PATH=$(ls pcf-demo-*.war)

cat <<EOF >manifest.yml
---
applications:
- name: $CF_APP_NAME
  host: $CF_APP_HOST
  path: $ARTIFACT_PATH
  memory: 512M
  instances: 1
  timeout: 180
#  services: [ $CF_MQ_SERVICE_NAME ]
  env:
    JAVA_OPTS: -Djava.security.egd=file:///dev/urandom
EOF

echo "Generated manifest:"
cat manifest.yml

popd
