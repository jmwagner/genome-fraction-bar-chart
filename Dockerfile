FROM ubuntu:16.04

ADD .Rprofile /project/

WORKDIR /project

RUN apt update && \ 
   apt install -y software-properties-common libssl-dev apt-transport-https

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
   add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/' && \
   apt update && \
   apt install -y wget r-base r-recommended libcurl4-openssl-dev

RUN wget https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb && \ 
    dpkg -i pandoc-1.19.2.1-1-amd64.deb

ADD packrat /project/packrat
RUN R -e 'install.packages("packrat" , repos="http://cran.us.r-project.org"); packrat::restore()'

ADD bar_chart.r /project
ADD biobox.yaml /project
