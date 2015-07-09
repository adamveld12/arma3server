# Arma 3 Dedicated Server Docker Setup

This is a dockerfile for running an Arma 3 dedicated server.

This container has an ssh server set up and listening on container port 22. This should allow you to ssh in and do anything you may need to do inside of the container remotely without having to tear it down and start it up again.

There are a few volumes set up in this container:

`/configuration`: The server.cfg and the basic.cfg files
`/profiles`: The server user profile settings
`/home/steam/mpmissions`: The mp missions folder

This container also ships with tmux and vim installed.

## How to use

First, edit the text file "credentials" in the repository root to look like this:

```
STEAMUSER=your steam account username here
STEAMPASSWORD=your steam account password here
```

*NOTE*: You should use your junk steam account credentials, or [create one if you haven't already and start using it for your dedicated server instances.](https://developer.valvesoftware.com/wiki/SteamCMD#SteamCMD_Login)

Next, build it:

`./build.sh`

Then run it like this:

```sh
docker run -itd \
  --env-file credentials \
  -p 2302-2305:2302-2305/udp \
  -p 2344-2345:2344-2345/udp -p 2344-2345:2344-2345/tcp \
  -p 8766:8766/udp -p 27016:27016/udp \
  -p 2222:22 \
  -v $PWD/configuration:/configuration \
  -v $PWD/profiles:/profiles \
  adamveld12/arma3 
```

From here, you should see your container show up in the server browser after a few seconds. Make sure to edit the configuration files to your liking, they will persist between runs.

I will include a guide on how to run multiple instances on one machine at a later time.

