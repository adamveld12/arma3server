FROM adamveld12/steam

MAINTAINER Adam Veldhousen "adam@veldhousen.ninja"

ENV GAMEID 233780
ENV LD_LIBRARY_PATH=/arma3

WORKDIR /home/steam
RUN mkdir -p ./log/script/console && \
    cp /home/dev/.tmux.conf ./.tmux.conf && \
    cp /home/dev/.profile ./.profile 

COPY ./scripts .
COPY ./keys/id_rsa.pub /root/.ssh/authorized_keys
COPY ./configuration /configuration
COPY ./profiles /profiles

ENTRYPOINT ["./install"]
VOLUME ["/home/steam/mpmissions", "/configuration", "/profiles", "/arma3"]

EXPOSE 2345 2344 2305 2304 2303 2302 22

USER root
CMD ./startup
