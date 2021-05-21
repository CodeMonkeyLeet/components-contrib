#!/usr/bin/env bash
# ------------------------------------------------------------
# Copyright (c) Microsoft Corporation and Dapr Contributors.
# Licensed under the MIT License.
# ------------------------------------------------------------
#
# Syntax: ./init-gopath.sh

set -e

if [ "$(id -u)" -eq 0 ]; then
    echo -e 'Script must be run as sudo-enabled non-root user.'
    exit 1
fi

TARGET_GOPATH=$(go env GOPATH)

# Clone dapr/dapr repo into GOPATH along side components-contrib if
# there isn't a valid git repo bind mounted there already.
if [ ! -d ${TARGET_GOPATH}/src/github.com/dapr/dapr/.git ]; then
    echo "Cloning dapr/dapr repo ..."
    sudo chown dapr ${TARGET_GOPATH}/src/github.com/dapr/dapr
    git clone https://github.com/dapr/dapr /go/src/github.com/dapr/dapr
fi

# If running in Codespaces, workspaceFolder is ignore, so link the default
# Codespaces workspaces folder to under the GOPATH instead as a workaround.
if [ ${CODESPACES,,} == "true" ]; then
    echo "Creating link to workspace folder under ${TARGET_GOPATH} ..."
    ln -s /workspaces/components-contrib ${TARGET_GOPATH}/src/github.com/dapr/components-contrib
fi

echo "Done!"
