#!/bin/bash
set -e

echo "Verifying location of Scratch source is known"
if [ -z "$SCRATCH_SRC_HOME" ]; then
    echo "Error: SCRATCH_SRC_HOME environment variable is not set."
    exit 1
fi

echo "Checking that Scratch has been patched"
if [ ! -f "$SCRATCH_SRC_HOME/patched" ]; then
    echo "Scratch has not yet been patched. Run ./0-setup.sh"
    exit 1
fi

# allow this script to be run from other locations, despite the
#  relative file paths used in it
if [[ $BASH_SOURCE = */* ]]; then
  cd -- "${BASH_SOURCE%/*}/" || exit
fi


echo "Preparing a gh-pages branch"
DEVBRANCH=$(git rev-parse --abbrev-ref HEAD)
if git rev-parse --verify gh-pages >/dev/null 2>&1
then
  git checkout gh-pages
else
  git checkout -b gh-pages
fi

echo "Preparing a publish folder"
if [ -d "scratch-vm1" ]
then
  rm -rf ./scratch-vm1/*
else
  mkdir scratch-vm1
fi


echo "Publishing the Scratch fork"
cp -rf $SCRATCH_SRC_HOME/scratch-vm/* ./scratch-vm1/.
