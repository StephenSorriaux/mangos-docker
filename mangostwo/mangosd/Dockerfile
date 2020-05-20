FROM gcc:7.3.0 as builder
ARG MANGOS_SERVER_VERSION=master
ARG THREAD_COUNT="-j4"
ARG CMAKE_VERSION="3.14.5"

RUN apt-get update -qq && \
    apt-get install openssl libssl-dev -y && \
    wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
    sh cmake-${CMAKE_VERSION}-Linux-x86_64.sh --skip-license --prefix=/usr && \
    git clone https://github.com/mangostwo/server.git -b ${MANGOS_SERVER_VERSION} --recursive && \
    cd server && \
    cmake . -DBUILD_REALMD=No -DBUILD_TOOLS=No -DCONF_INSTALL_DIR=/server/install/etc/ && \
    make ${THREAD_COUNT} && \
    make install ${THREAD_COUNT}

FROM debian:10
MAINTAINER Stephen SORRIAUX <stephen.sorriaux@gmail.com>
EXPOSE 8085
ENV LOGIN_DATABASE_INFO=127.0.0.1;3306;root;mangos;realmd
ENV WORLD_DATABASE_INFO=127.0.0.1;3306;root;mangos;mangos1
ENV CHARACTER_DATABASE_INFO=127.0.0.1;3306;root;mangos;character1
WORKDIR /etc/mangos/
COPY --from=builder /server/install/bin ./bin
COPY --from=builder /server/install/etc ./conf
RUN apt-get update && \
    apt-get install wget libstdc++6  libmariadbclient-dev libmariadbd19 libmariadb3 libssl-dev -y && \
    ln -s /usr/lib/x86_64-linux-gnu/libmariadbclient.so /usr/lib/x86_64-linux-gnu/libmariadbclient.so.18 && \
    useradd -ms /bin/bash mangos && \
    wget --no-check-certificate https://raw.githubusercontent.com/StephenSorriaux/mangos-docker/master/launch_mangosd.sh && \
    chmod -R a+x . && \
    mv conf/mangosd.conf.dist conf/mangosd.conf && \
    sed -i 's/^LoginDatabaseInfo            =.*$/LoginDatabaseInfo            = LOGIN_DATABASE_INFO/' conf/mangosd.conf && \
    sed -i 's/^WorldDatabaseInfo            =.*$/WorldDatabaseInfo            = WORLD_DATABASE_INFO/' conf/mangosd.conf && \
    sed -i 's/^CharacterDatabaseInfo        =.*$/CharacterDatabaseInfo        = CHARACTER_DATABASE_INFO/' conf/mangosd.conf && \
    sed -i 's/\/server\/install\/etc/\/etc\/mangos/' conf/mangosd.conf && \
    chown -R mangos:mangos . && \
    rm -rf /var/lib/apt/lists/*
USER mangos
CMD ["./launch_mangosd.sh"]
