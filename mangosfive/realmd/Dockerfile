FROM gcc:7.4.0 as builder
ARG MANGOS_SERVER_VERSION=master
ARG THREAD_COUNT="-j4"
ARG CMAKE_VERSION="3.14.5"

RUN apt-get update -qq && \
    apt-get install openssl libssl-dev -y && \
    wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
    sh cmake-${CMAKE_VERSION}-Linux-x86_64.sh --skip-license --prefix=/usr && \
    git clone https://github.com/mangosfive/server.git -b ${MANGOS_SERVER_VERSION} --recursive && \
    cd server && \
    cmake . -DBUILD_MANGOSD=No -DBUILD_TOOLS=No -DCONF_DIR=conf/ && \
    make ${THREAD_COUNT} && \
    make install ${THREAD_COUNT}

FROM debian:9
MAINTAINER Stephen SORRIAUX <stephen.sorriaux@gmail.com>
EXPOSE 3724
ENV LOGIN_DATABASE_INFO=127.0.0.1;3306;root;mangos;realmd
WORKDIR /etc/mangos/
COPY --from=builder /server/bin/ .

# TODO: avoid symlink?
RUN apt-get update && \
    apt-get install wget libmariadbclient-dev libmariadbd19 libmariadb3 libssl-dev -y && \
    ln -s /usr/lib/x86_64-linux-gnu/libmariadbclient.so /usr/lib/x86_64-linux-gnu/libmariadbclient.so.18 && \
    useradd -ms /bin/bash realm && \
    wget https://raw.githubusercontent.com/StephenSorriaux/mangos-docker/master/launch_realmd.sh && \
    chmod -R a+x . && \
    mv conf/realmd.conf.dist conf/realmd.conf && \
    sed -i 's/^LoginDatabaseInfo      =.*$/LoginDatabaseInfo      = LOGIN_DATABASE_INFO/' conf/realmd.conf && \
    chown -R realm:realm . && \
    rm -rf /var/lib/apt/lists/*
USER realm
CMD ["./launch_realmd.sh"]
