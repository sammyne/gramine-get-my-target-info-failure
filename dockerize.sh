#!/bin/bash

set -e

repo=demo-gramine-get-my-target-info-failure

tag=$(git rev-parse --short HEAD)

gramine_version=1.3.1
#gramine_version=1.2

repo_tag=$repo:$tag-gramine${gramine_version}

docker build --build-arg GRAMINE_VERSION=${gramine_version} -t $repo_tag .

docker push $repo_tag
