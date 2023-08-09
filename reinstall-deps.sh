#!/bin/bash

if [ ! -f "package.json" ]; then
  echo "package.json not found in this direcotry"
  exit 1
fi

rm -rf node_modules
rm package-lock.json
npm i --force
