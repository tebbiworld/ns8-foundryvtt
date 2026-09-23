#!/bin/bash

#
# Copyright (C) 2026 tebbi
# SPDX-License-Identifier: GPL-3.0-or-later
#

set -e

images=()
repobase="${REPOBASE:-ghcr.io/tebbiworld}"
reponame="foundryvtt"

# Pin the Foundry VTT application image (felddy/foundryvtt). Declared in the
# org.nethserver.images label so the node pre-pulls it and exposes it to the
# systemd unit as ${FOUNDRY_IMAGE}. The tag tracks the felddy tooling major
# version; the actual Foundry software version is selected at runtime through
# FOUNDRY_VERSION (empty = latest stable).
foundry_image="ghcr.io/felddy/foundryvtt:14.367.0"

container=$(buildah from scratch)

# Build the UI here, like every other module: ui/dist is not committed, so a
# build on a clean checkout (CI, auto-release) has nothing to add otherwise.
if ! buildah containers --format "{{.ContainerName}}" | grep -q nodebuilder-foundryvtt; then
    echo "Pulling NodeJS runtime..."
    buildah from --name nodebuilder-foundryvtt -v "${PWD}:/usr/src:Z" docker.io/library/node:24.16.0-slim
fi

echo "Build static UI files with node..."
buildah run \
    --workingdir=/usr/src/ui \
    --env="NODE_OPTIONS=--openssl-legacy-provider" \
    nodebuilder-foundryvtt \
    sh -c "yarn install && yarn build"

buildah add "${container}" imageroot /imageroot
buildah add "${container}" ui/dist /ui
# Reserve one TCP port for the Foundry web/websocket server (container 30000),
# fronted by Traefik. No extra node ports are required.
buildah config --entrypoint=/ \
    --label="org.nethserver.authorizations=traefik@node:routeadm" \
    --label="org.nethserver.tcp-ports-demand=1" \
    --label="org.nethserver.rootfull=0" \
    --label="org.nethserver.images=${foundry_image}" \
    "${container}"
buildah commit "${container}" "${repobase}/${reponame}"

images+=("${repobase}/${reponame}")

if [[ -n "${CI}" ]]; then
    printf "images=%s\n" "${images[*],,}" >> "${GITHUB_OUTPUT}"
else
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${IMAGETAG:-latest}" ; done
    printf "\n"
fi
