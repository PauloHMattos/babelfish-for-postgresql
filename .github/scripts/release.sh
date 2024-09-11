#!/bin/bash

function help(){
  echo "
    Export the following environment variables: TAG, LOC, RELEASE_VERSION
    Then, execute: ./release.sh
  "
  exit 0
}

if [ ! -v TAG ]
then
    printf "TAG is a mandatory environment variable.\n"
    exit 2
fi

if [ ! -v RELEASE_VERSION ]
then
    printf "RELEASE_VERSION is a mandatory environment variable.\n"
    exit 2
fi

if [ ! -v LOC ]
then
    printf "LOC is a mandatory environment variable.\n"
    exit 2
fi

# extract babelfish and engine version
VERSION=$(echo $TAG | sed -r -e 's/BABEL_([0-9a-z_]*)__PG.*/\1/' -e 's/_/./g')
ENGINE=$(echo $TAG | sed -r -e 's/BABEL_([0-9_]*)__PG_([0-9]+_)/\2/' -e 's/_/./g')

# change babelfish version format to major-minor-patch
VERSION=$(echo $TAG | sed -r -e 's/BABEL_([0-9a-z_]*)__PG.*/\1/' -e 's/_/-/g')


NIGHTLY_VERSION=$RELEASE_VERSION-$(date '+%Y-%m-%d')

title="Babelfish ${NIGHTLY_VERSION}"

echo "
Releasing
Tag: $NIGHTLY_VERSION
Title: $title
Attachments: ${LOC}${TAG}.*
"

gh release create --draft $NIGHTLY_VERSION ${LOC}${TAG}.* -d -t "$title" -n ""
