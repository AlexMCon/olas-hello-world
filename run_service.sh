#!/usr/bin/env bash

REPO_PATH=$PWD

# Remove previous service build
if test -d hello_world; then
  echo "Removing previous service build"
  sudo rm -r hello_world
fi

# Push packages and fetch service
make clean

autonomy packages lock
autonomy push-all

autonomy fetch --local --service valory/hello_world && cd hello_world

# Build the image
autonomy init --reset --author valory --remote --ipfs --ipfs-node "/dns/registry.autonolas.tech/tcp/443/https"
autonomy build-image

# Copy .env file
cp $REPO_PATH/.env .

# Copy the keys and build the deployment
cp $REPO_PATH/keys.json .

autonomy deploy build -ltm

# Run the deployment
autonomy deploy run --build-dir abci_build/
