#!/bin/bash
# Copyright (C) 2016 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only

# This script is meant to be consumed by travis. It's very simple but running
# a loop in travis.yml isn't a great thing.

set -e

# Allow the user to specify another command to use for building such as podman
if [ "${ENGINE_CMD}" = "" ]; then
    ENGINE_CMD="docker"
fi

# Don't deploy on pull requests because it could just be junk code that won't
# get merged
if ([ "${GITHUB_EVENT_NAME}" = "push" ] || [ "${GITHUB_EVENT_NAME}" = "workflow_dispatch" ] || [ "${GITHUB_EVENT_NAME}" = "schedule" ]) && [ "${GITHUB_REF}" = "refs/heads/arm64-testing" ]; then
    ${ENGINE_CMD} tag  $REPO:latest ghcr.io/$REPO:latest

    echo $GHCR_PASSWORD | ${ENGINE_CMD} login ghcr.io -u $GHCR_USERNAME --password-stdin
    ${ENGINE_CMD} push ghcr.io/${REPO}:latest
else
    echo "Not pushing since build was triggered by a pull request."
fi
