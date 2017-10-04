FROM mysql:5.7
MAINTAINER Stephen SORRIAUX <stephen.sorriaux@gmail.com>
EXPOSE 3306
ARG MANGOS_ONE_DATABASE_VERSION=master
ENV MANGOS_DATABASE_REALM_NAME=MyAwesomeWowServer
RUN apt-get update && \
    apt-get install git wget -y && \
    git clone https://github.com/mangosone/database.git -b ${MANGOS_ONE_DATABASE_VERSION} --recursive && \
    wget --no-check-certificate https://raw.githubusercontent.com/StephenSorriaux/mangosone-docker/master/launch_mysql.sh && \
    chmod a+x launch_mysql.sh && \
    apt-get remove --purge --force-yes -y git wget && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["./launch_mysql.sh"]
CMD ["mysqld"]
