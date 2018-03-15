# cli-demo
Demo of the OpenStudio CLI

Download and install [OpenStudio 2.4.0](https://github.com/NREL/OpenStudio/releases/tag/v2.4.0)

From the command line run `openstudio run -w basic_osw/in.osw`

Try out the other examples

Copy an example, modify the in.osw, and try that out

Read more about the [OpenStudio CLI](http://nrel.github.io/OpenStudio-user-documentation/reference/command_line_interface/)

Read more about [OpenStudio Measures](http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/)

## Docker Container

To run the demo within a Docker container first [install Docker](https://www.docker.com/community-edition), then run the following command:

```
cd cli-demo
docker run -v $(pwd):/var/simdata/openstudio nrel/openstudio:2.4.0 /usr/bin/openstudio run -w basic_osw/in.osw
```

The command above will download the OpenStudio docker container from [Docker Hub](https://hub.docker.com/r/nrel/openstudio/tags/), mount your local directory into the docker container, and call the OpenStudio CLI to run the basic_osw workflow.
