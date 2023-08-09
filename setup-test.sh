#!/bin/bash

check_command() {
  if [ -z "$(command -v $1)" ]
  then
    echo "$1 is not installed"
    echo ""
    echo "$2"
    exit 2
  fi
}

assert_not_empty() {
  if [ -z "$1" ]
  then
    echo "$2 must not be empty"
    exit 1
  fi
}

use_default() {
  if [ -z "$1" ]
  then
    echo "$2"
  else
    echo "$1"
  fi
}

update_json() {
  jq ".$1 = \"$2\"" package.json > tmp.$$.json && mv tmp.$$.json package.json
}

# Check commands
check_command "npm" "Make sure node is installed, I recommend using nvm"
check_command "npx" "Make sure node is installed, I recommend using nvm"
check_command "jq" "jq can be installed with 'brew install jq'"

# Start!
printf "Setting up test for CRACO\n"

# GitHub issue number
printf "GitHub issue number: "
read issue
assert_not_empty "$issue" "GitHub issue number"
APP_NAME="craco-test-$issue"

# CRA version
printf "CRA version [latest]: "
read cra_version
CRA_VERSION=$(use_default "$cra_version" "latest")
NPX_PKG="create-react-app@$CRA_VERSION"

# CRACO version
printf "CRACO version [latest]: "
read craco_version
CRACO_VERSION=$(use_default "$craco_version" "latest")
CRACO_PKG="@craco/craco@$CRACO_VERSION"

# CRACO config file
printf "CRACO config file [craco.config.js]: "
read craco_config
CRACO_CONFIG=$(use_default "$craco_config" "craco.config.js")

# Create app
npx $NPX_PKG $APP_NAME
cd $APP_NAME

# Remove git repository
rm -rf .git

# Install CRACO
npm i -D $CRACO_PKG

# Create craco config
echo "module.exports = {}" > $CRACO_CONFIG

# Update package.json
update_json "scripts.start" "craco start"
update_json "scripts.build" "craco build"
update_json "scripts.test" "craco test"
update_json "version" "0.0.0"

# Done!
printf "\n\nDone! Test is set up in $APP_NAME\n"
