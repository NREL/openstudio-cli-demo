#!/usr/bin/env bash

set -e

# Set the env vars needed for running tests based on OS
if [ "${TRAVIS_OS_NAME}" == "osx" ]; then
    export RUBYLIB="${HOME}/openstudio/Ruby"
elif [ "${TRAVIS_OS_NAME}" == "linux" ]; then
    export RUBYLIB="/usr/local/openstudio-${OPENSTUDIO_VERSION}/Ruby:/usr/Ruby"
    # Need to set energyplus exe in 2.6.0
    export ENERGYPLUS_EXE_PATH="/usr/local/openstudio-${OPENSTUDIO_VERSION}/EnergyPlus/energyplus"
fi

# Env variables set in setup.sh do not seem to be available in test.sh
if [ "${BUILD_TYPE}" == "docker" ]; then
    echo "Skipping tests for docker builds"
else
    # run unit tests via openstudio_meta run_rspec command which attempts to reproduce the PAT local environment
    # prior to running tests, so we should not set enviroment variables here
    if [ "${BUILD_TYPE}" == "test" ];then
        echo "starting unit tests. RUBYLIB=$RUBYLIB"
        openstudio run -w basic_osw/in.osw

        # check if the measure_attributes.json file exists, if not then fail
        if [ -f basic_osw/run/measure_attributes.json ]; then
            cat basic_osw/run/measure_attributes.json
            echo "basic_osw passed"
        else
            echo "basic_osw failed"
            exit 1
        fi

        # Wait until 2.6.0 or 2.6.1 is updated with the most recent standards to reenable gbxml test
        openstudio run -w gbxml_osw/in.osw
        # openstudio isn't returning a non-zero exit status
        if [ -f gbxml_osw/run/measure_attributes.json ]; then
            cat gbxml_osw/run/measure_attributes.json
            echo "gbxml_osw passed"
        else
            echo "gbxml_osw failed"
            exit 1
        fi

        # openstudio bundle_osw/driver.rb
        # # openstudio isn't returning a non-zero exit status
        # if [ -f bundle_osw/run/measure_attributes.json ]; then
        #     cat bundle_osw/run/measure_attributes.json
        #     echo "bundle_osw passed"
        # else
        #     echo "bundle_osw failed"
        #     exit 1
        # fi
        exit 0
    fi
fi
