#
# Copyright 2018 The Caicloud Authors.
#

FROM cargo.caicloud.xyz/library/debian:stretch

LABEL maintainer="Ce Gao <gaoce@caicloud.io>"

ADD bin/pytorch-operator /pytorch-operator
ADD build/pytorch-operator/initContainer.yaml /etc/config/initContainer.yaml
ENTRYPOINT ["/pytorch-operator"]
