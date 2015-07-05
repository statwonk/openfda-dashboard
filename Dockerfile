FROM dockr:shiny

MAINTAINER Christopher Peters "cpeter9@gmail.com"

RUN R --no-save -e "install.packages(c('openfda', 'ggplot2', 'scales', 'dplyr', 'reshape2', 'ggthemes'),
                    repos='http://cran.rstudio.com/')"
