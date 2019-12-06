#
# Copyright 2018 The Caicloud Authors.
#

FROM cargo.caicloud.xyz/library/debian:stretch

LABEL maintainer="Ce Gao <gaoce@caicloud.io>"

ADD bin/pytorch-operator /pytorch-operator

ENTRYPOINT ["/pytorch-operator"]
