FROM statwonk/shiny

MAINTAINER Christopher Peters "cpeter9@gmail.com"

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libxml2-dev

RUN R --no-save -e "install.packages(c('devtools'), \
                    repos='http://cran.rstudio.com/')"

RUN R --no-save -e "install.packages(c('ggplot2', 'scales', \
                                       'reshape2', 'ggthemes', 'mgcv'), \
                    repos='http://cran.rstudio.com/')"

RUN R --no-save -e "library(devtools); \
                    install_github('hadley/dplyr'); \
                    install_github('statwonk/openfda');"

RUN cd /srv/shiny-server/ \
    && git clone https://github.com/statwonk/openfda-dashboard.git

EXPOSE 3838

CMD["/usr/bin/shiny-server.sh"]
