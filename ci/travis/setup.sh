#!/usr/bin/env bash

echo "The build architecture is ${TRAVIS_OS_NAME}"

if [ "${BUILD_TYPE}" == "docker" ]; then
    # install pipeviewer
    sudo apt-get install -y pv
else
    if [ "${TRAVIS_OS_NAME}" == "osx" ]; then
        brew update > /Users/travis/build/NREL/openstudio-cli-demo/ci/logs/brew-update.log
        brew install pv tree
        unset BUNDLE_GEMFILE

        curl -SLO --insecure https://s3.amazonaws.com/openstudio-builds/$OPENSTUDIO_VERSION/OpenStudio-$OPENSTUDIO_VERSION.$OPENSTUDIO_VERSION_SHA-Darwin.zip
        unzip OpenStudio-$OPENSTUDIO_VERSION.$OPENSTUDIO_VERSION_SHA-Darwin.zip
        # Use the install script that is in this repo now, the one on OpenStudio/develop has changed
        sed -i -e "s|REPLACEME|$HOME/openstudio|" ci/travis/install-mac.qs
        rm -rf $HOME/openstudio
        # Will install into $HOME/openstudio and RUBYLIB will be $HOME/openstudio/Ruby
        sudo ./OpenStudio-$OPENSTUDIO_VERSION.$OPENSTUDIO_VERSION_SHA-Darwin.app/Contents/MacOS/OpenStudio-$OPENSTUDIO_VERSION.$OPENSTUDIO_VERSION_SHA-Darwin --script ci/travis/install-mac.qs
        tree ${HOME}/openstudio/Ruby
    elif [ "${TRAVIS_OS_NAME}" == "linux" ]; then
        echo "Setting up Ubuntu for unit tests and Rubocop"
        # install pipe viewer to throttle printing logs to screen (not a big deal in linux, but it is in osx)
        sudo apt-get update 
        sudo apt-get install -y pv
        mkdir -p reports/rspec
        curl -SLO https://raw.githubusercontent.com/NREL/OpenStudio-server/develop/docker/deployment/scripts/install_openstudio.sh
        chmod +x install_openstudio.sh
        sudo ./install_openstudio.sh $OPENSTUDIO_VERSION $OPENSTUDIO_VERSION_SHA
    fi
fi

