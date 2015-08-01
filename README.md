# OpenFDA Dashboard

An instance of [the OpenFDA dashboard](http://www.statwonk.com/openfda-dashboard/).

The United State Food and Drug Administration (FDA) launched a public API February 2014. This dashboard's purpose is to help make the [FDA's hosted data](https://open.fda.gov/) more accessible to the public.

## Quickstart

To set up your own instance of the dashboard:

1. [Install Docker](https://github.com/docker/docker#getting-started) (e.g. Ubuntu: `sudo apt-get install docker.io`)

For more resources on Docker, checkout: [https://www.docker.com/tryit/](https://www.docker.com/tryit/)

1. `docker pull statwonk/openfda-dashboard`
2. `docker run --rm -p 3838:3838 statwonk/openfda-dashboard`

This will [download a docker image](https://registry.hub.docker.com/u/statwonk/openfda-dashboard/dockerfile/) based on Ubuntu, RStudio's [shiny-server](http://shiny.rstudio.com/), and finish up by downloading and launching the dashboard hosted in this repository.

3. Visit `localhost:3838` (or if on Mac OS X, the ip address returned from `boot2docker ip` + `:3838` to view the dashbaord locally!
