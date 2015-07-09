FROM adamveld12/steam

MAINTAINER Adam Veldhousen "adam@veldhousen.ninja"

WORKDIR /home/steam
RUN mkdir -p ./log/script/console && \
    cp /home/dev/.tmux.conf ./.tmux.conf && \
    cp /home/dev/.profile ./.profile 

COPY ./credentials.sh ./credentials.sh
COPY ./scripts .
COPY ./keys/id_rsa.pub /root/.ssh/authorized_keys
COPY ./configuration/ /configuration
COPY ./profiles/ /profiles

RUN . ./credentials.sh && \
    /home/steam/steamcmd/steamcmd.sh \
        +login $STEAMUSER $STEAMPASS \
        +force_install_dir /home/steam \
        +app_update 233780 validate \
        +exit && \
    rm -rf ./credentials.sh && \
    export STEAMUSER="" && \
    export STEAMPASS=""

VOLUME ["/home/steam/mpmissions", "/home/steam/mods", "/configuration", "/profiles"]

EXPOSE 2345 2344 2305 2304 2303 2302 22

USER root
ENTRYPOINT ["./startup"]

