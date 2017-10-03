FROM gcc:4.8.5 as builder
ARG MANGOS_ONE_SERVER_VERSION=master
RUN apt-get update -qq && \
    apt-get install openssl libssl-dev cmake -y && \
    git clone https://github.com/mangosone/server.git -b ${MANGOS_ONE_SERVER_VERSION} --recursive && \
    cd server && \
    cmake . -DBUILD_MANGOSD=No -DBUILD_TOOLS=No -DCONF_DIR=conf/ && \
    make -j4 && \
    make install -j4

FROM debian:8
MAINTAINER Stephen SORRIAUX <stephen.sorriaux@gmail.com>
EXPOSE 3724
ENV LOGIN_DATABASE_INFO=127.0.0.1;3306;root;mangos;realmd
WORKDIR /etc/mangos/
COPY --from=builder /server/bin/ .
RUN apt-get update && \
    apt-get install wget libmysql++-dev libssl-dev -y && \
    useradd -ms /bin/bash realm && \
    wget https://raw.githubusercontent.com/StephenSorriaux/mangosone-docker/master/launch_realmd.sh && \
    chmod -R a+x . && \
    cp lib/libace.so /usr/lib && \
    mv conf/realmd.conf.dist conf/realmd.conf && \
    sed -i 's/^LoginDatabaseInfo      =.*$/LoginDatabaseInfo      = LOGIN_DATABASE_INFO/' conf/realmd.conf && \
    chown -R realm:realm . && \
    rm -rf /var/lib/apt/lists/*
USER realm
CMD ["./launch_realmd.sh"]
