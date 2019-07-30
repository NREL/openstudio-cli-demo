# cli-demo

[![Build Status](https://travis-ci.org/NREL/openstudio-cli-demo.svg?branch=master)](https://travis-ci.org/NREL/openstudio-cli-demo)

Demo of the OpenStudio CLI

Download and install [OpenStudio 2.8.1](https://github.com/NREL/OpenStudio/releases/tag/v2.8.1)

From the command line run `openstudio run -w basic_osw/in.osw`

Try out the other examples

Copy an example, modify the in.osw, and try that out

Read more about the [OpenStudio CLI](http://nrel.github.io/OpenStudio-user-documentation/reference/command_line_interface/)

Read more about [OpenStudio Measures](http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/)

## Docker Container

To run the demo within a Docker container first [install Docker](https://www.docker.com/community-edition), then run the following command:

```
cd cli-demo
docker run -v $(pwd):/var/simdata/openstudio nrel/openstudio:2.8.1 openstudio run -w basic_osw/in.osw
docker run -v $(pwd):/var/simdata/openstudio nrel/openstudio:2.8.1 openstudio run -w gbxml_osw/in.osw
```

The command above will download the OpenStudio docker container from [Docker Hub](https://hub.docker.com/r/nrel/openstudio/tags/), mount your local directory into the docker container, and call the OpenStudio CLI to run the basic_osw workflow.

**Note**: If running Docker-machine (typically on Windows 7), then you need to checkout this repo into a path within your home directory (e.g. C:\Users\username). This allows for docker to mount the files into the container since Docker-machine, by default, mounts your entire home directory into the Docker-machine VM.
