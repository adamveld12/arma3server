# Arma 3 Dedicated Server Docker Setup

This is a dockerfile for running an Arma 3 dedicated server.

This container has an ssh server set up and listening on container port 22. This should allow you to ssh in and do anything you may need to do inside of the container remotely without having to tear it down and start it up again.

This container also ships with tmux and vim installed and some dot files that modify some tmux settings. [Take a look at the tmux.conf](https://github.com/adamveld12/laughing-hipster/blob/master/.tmux.conf) to see all of the alterations.


There are a few volumes set up in this container:

`/configuration`: The server.cfg and the basic.cfg files

`/profiles`: The server user profile settings

`/home/steam/mpmissions`: The mp missions folder

`/home/steam/mods`: Mods

Lastly, there is a prebuilt image available on [Docker Hub](https://registry.hub.docker.com/u/adamveld12/arma3/).

## How to use

1. Build it:

`./build.sh`

You will get prompted to password protect the ssh key used to connect to the container after its running, and for steam account credentials so that the build can install the arma 3 dedicated server tools.

*NOTE*: You should use your junk steam account, or [create one if you haven't already and start using it for your dedicated server instances.](https://developer.valvesoftware.com/wiki/SteamCMD#SteamCMD_Login)

2. Run it:

`./run.sh`

This prompts you for a name and [sets up a data container](http://container42.com/2013/12/16/persistent-volumes-with-docker-container-as-volume-pattern/) to hold your mods, mpmissions and configuration settings. Next, an arma3 server container is created and ran, using the volumes from the data container as data storage. The script links the volumes from the data container to the server, allowing you to edit configurations and mods without losing your changes.

From here, you should see your game show up in the server browser after a few seconds. Make sure to edit the configuration files to your liking, they will persist between runs.

You can reuse the same data and restart the server by using `./run.sh` and giving the same name for the data container. It will give you a yes/no prompt asking if you want to overwrite the old data with a new fresh configuration.

*NOTE*: I will include a guide on how to run multiple instances on one machine at a later time.

After you run this container you can check if your server is running by [using the server browser by BIS](http://master.bistudio.com/?page=1&count=10&game_id=6)

The server is ran inside of a tmux session under the steam user. The steam user has limited access to the file system and is mostly locked down to the /home/steam directory. If you would like to access the server then you can ssh in, run `su steam` and `tmux attach` to get to the running server.


## Default Settings

For the most part you get the server setup with pretty decent defaults. Verify signatures=2, battle eye enabled, and some networking tweaks in the basic.cfg to name a few. The admin RCON is disabled and so is the server password.
