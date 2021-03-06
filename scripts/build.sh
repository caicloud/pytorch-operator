#!/bin/bash

# Copyright 2018 The Kubeflow Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This shell script is used to build an image from our argo workflow

set -o errexit
set -o nounset
set -o pipefail

export PATH=${GOPATH}/bin:/usr/local/go/bin:${PATH}
REGISTRY="${GCP_REGISTRY}"
PROJECT="${GCP_PROJECT}"
GO_DIR=${GOPATH}/src/github.com/${REPO_OWNER}/${REPO_NAME}
VERSION=$(git describe --tags --always --dirty)

echo "Activating service-account"
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
echo "Create symlink to GOPATH"
mkdir -p ${GOPATH}/src/github.com/${REPO_OWNER}
ln -s ${PWD} ${GO_DIR}
cd ${GO_DIR}

echo "Building PyTorch operator in gcloud"
gcloud version
gcloud builds submit . --tag=${REGISTRY}/${REPO_NAME}:${VERSION} --project=${PROJECT}

#echo "Building smoke test image"
#SENDRECV_TEST_IMAGE_TAG="pytorch-dist-sendrecv-test:v1.0"
#gcloud builds submit  ./examples/smoke-dist/ --tag=${REGISTRY}/${SENDRECV_TEST_IMAGE_TAG} --project=${PROJECT}

#echo "Building MNIST test image"
#MNIST_TEST_IMAGE_TAG="pytorch-dist-mnist-test:v1.0"
#gcloud builds submit  ./examples/mnist/ --tag=${REGISTRY}/${MNIST_TEST_IMAGE_TAG} --project=${PROJECT}

# We need to change to use Kaniko to build images and submit to ECR.
# Option 1. Use S3. Then we need to build a context tar gz and upload to S3
# tar -C <path to build context> -zcvf context.tar.gz
# Option 2. We can use NFS directory directly and Kaniko can find context and Dockerfile there.