#!/bin/bash

set -e

# Default configuration
REPO="${REPO:-jonasGuest/qemu-dind}"
TAG="${TAG:-v0.1}"
IMAGE_NAME="qemu-dind-builder"
QCOW2_FILE="alpine-docker.qcow2"

echo "Github token: "
if [ -z "$GITHUB_TOKEN" ]; then
  read -r GITHUB_TOKEN
  export GITHUB_TOKEN
fi

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN is not set." >&2
  exit 1
fi

echo "Retrieving release ID for tag ${TAG}..."
RELEASE_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/${REPO}/releases/tags/${TAG}")

RELEASE_ID=$(echo "$RELEASE_RESPONSE" | grep -m 1 '"id":' | sed -E 's/.*"id": ([0-9]+),.*/\1/')

if [ -z "$RELEASE_ID" ] || [ "$RELEASE_ID" = "null" ]; then
  echo "Release for tag ${TAG} not found. Creating it..."
  # Create release
  CREATE_RELEASE_PAYLOAD="{\"tag_name\":\"${TAG}\",\"name\":\"${TAG}\",\"draft\":false,\"prerelease\":false}"
  RELEASE_RESPONSE=$(curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$CREATE_RELEASE_PAYLOAD" \
    "https://api.github.com/repos/${REPO}/releases")
  RELEASE_ID=$(echo "$RELEASE_RESPONSE" | grep -m 1 '"id":' | sed -E 's/.*"id": ([0-9]+),.*/\1/')
fi

if [ -z "$RELEASE_ID" ] || [ "$RELEASE_ID" = "null" ]; then
  echo "Error: Could not retrieve or create release for tag ${TAG}." >&2
  echo "API Response: $RELEASE_RESPONSE" >&2
  exit 1
fi

echo "Uploading ${QCOW2_FILE} to release ${TAG} (ID: ${RELEASE_ID})..."

# Delete asset if it already exists to allow overwrite (clobber)
EXISTING_ASSET_ID=$(echo "$RELEASE_RESPONSE" | grep -B 2 -A 10 "\"name\": \"${QCOW2_FILE}\"" | grep -m 1 '"id":' | sed -E 's/.*"id": ([0-9]+),.*/\1/')
if [ -n "$EXISTING_ASSET_ID" ]; then
  echo "Deleting existing asset with ID ${EXISTING_ASSET_ID}..."
  curl -s -X DELETE -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/${REPO}/releases/assets/${EXISTING_ASSET_ID}"
fi

# Upload the asset
UPLOAD_URL="https://uploads.github.com/repos/${REPO}/releases/${RELEASE_ID}/assets?name=${QCOW2_FILE}"
UPLOAD_RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/octet-stream" \
  --data-binary "@./${QCOW2_FILE}" \
  "$UPLOAD_URL")
  
if echo "$UPLOAD_RESPONSE" | grep -q '"id":'; then
  echo "Upload successful!"
else
  echo "Error: Upload failed." >&2
  echo "API Response: $UPLOAD_RESPONSE" >&2
  exit 1
fi

