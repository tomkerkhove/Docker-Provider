#!/bin/bash
set -e

# Note - This script used in the pipeline as inline script

if [ -z $AGENT_IMAGE_TAG_SUFFIX ]; then
  echo "-e error value of AGENT_IMAGE_TAG_SUFFIX variable shouldnt be empty. check release variables"
  exit 1
fi

if [ -z $AGENT_RELEASE ]; then
  echo "-e error AGENT_RELEASE shouldnt be empty. check release variables"
  exit 1
fi
#!
if [ -z $AGENT_IMAGE_FULL_PATH ]; then
  echo "-e error AGENT_IMAGE_FULL_PATH shouldnt be empty. check release variables"
  exit 1
fi

if [ -z $CDPX_TAG ]; then
  echo "-e error value of CDPX_TAG shouldn't be empty. check release variables"
  exit 1
fi

if [ -z $CDPX_REGISTRY ]; then
  echo "-e error value of CDPX_REGISTRY shouldn't be empty. check release variables"
  exit 1
fi

if [ -z $CDPX_REPO_NAME ]; then
  echo "-e error value of CDPX_REPO_NAME shouldn't be empty. check release variables"
  exit 1
fi

if [ -z $ACR_NAME ]; then
  echo "-e error value of ACR_NAME shouldn't be empty. check release variables"
  exit 1
fi


#Login to az cli and authenticate to acr
echo "Login cli using managed identity"
az login --identity
if [ $? -eq 0 ]; then
  echo "Logged in successfully"
else
  echo "-e error failed to login to az with managed identity credentials"
  exit 1
fi     

echo "Pushing ${AGENT_IMAGE_FULL_PATH} to ${ACR_NAME}"
az acr import --name $ACR_NAME --registry $CDPX_REGISTRY --source official/${CDPX_REPO_NAME}:${CDPX_TAG} --image $AGENT_IMAGE_FULL_PATH
if [ $? -eq 0 ]; then
  echo "Retagged and pushed image successfully"
else
  echo "-e error failed to retag and push image to destination ACR"
  exit 1
fi