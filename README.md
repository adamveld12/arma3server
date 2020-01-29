# Arma 3 Dedicated Server Docker Setup

This is a dockerfile for running an Arma 3 dedicated server. It supports mods, SSH and persistent configuration via volumes.

This container has an ssh server set up and listening on container port 22. This should allow you to ssh in and do anything you may need to do inside of the container remotely without having to tear it down and start it up again.

This container also ships with tmux and vim installed and some dot files that modify some tmux settings. [Take a look at the tmux.conf](https://github.com/adamveld12/laughing-hipster/blob/master/.tmux.conf) to see all of the alterations.


There are a few volumes set up in this container:

`/configuration`: The server.cfg and the basic.cfg files

`/profiles`: The server user profile settings

`/home/steam/mpmissions`: The mp missions folder

`/home/steam/mods`: Mods

Lastly, there is a prebuilt image available on [Docker Hub](https://registry.hub.docker.com/u/adamveld12/arma3/).


## How to use

1. [Install Docker for your system](https://docs.docker.com/installation/)

For Ubuntu trusty 14.04, just do `wget -qO- https://get.docker.com/ | sh`


2. Build it from source:

`./build.sh`

You will get prompted to password protect the ssh key used to connect to the container after its running, and for steam account credentials so that the build can install the arma 3 dedicated server tools.

*NOTE*: You should use your junk steam account, or [create one if you haven't already and start using it for your dedicated server instances.](https://developer.valvesoftware.com/wiki/SteamCMD#SteamCMD_Login)

or docker pull it:

`docker pull adamveld12/arma3`

3. Run it:

`./run.sh` 

This prompts you for a name and [sets up a data container](http://container42.com/2013/12/16/persistent-volumes-with-docker-container-as-volume-pattern/) to hold your mods, mpmissions and configuration settings. Next, an arma3 server container is created and ran, using the volumes from the data container as data storage. The script links the volumes from the data container to the server, allowing you to edit configurations and mods without losing your changes.

From here, you should see your game show up in the server browser after a few seconds. Make sure to edit the configuration files to your liking, they will persist between runs.

You can reuse the same data and restart the server by using `./run.sh` and giving the same name for the data container. It will give you a yes/no prompt asking if you want to overwrite the old data with a new fresh configuration. 


After you start a new container one easy way that you can check if your server is running is by [using the server browser by BIS](http://master.bistudio.com/?page=1&count=10&game_id=6) (make sure to add your server's IP and steam query port so that the browser knows about your server)

The server is ran inside of a tmux session under the steam user. The steam user has limited access to the file system and is mostly locked down to the /home/steam directory. If you would like to access the server then you can ssh in, run `su steam` and `tmux attach` to get to the running server.


## Installing missions

You just need to get your missions/scenarios into the /home/steam/mpmissions volume some how, and below are a couple of ways of doing that.

1. With SSH

  You can SCP missions into /home/steam/mpmissions like so:

  `scp -i ./keys/id_rsa -p 2222 ./my_mission.Altis.pbo root@localhost:/home/steam/mpmissions/my_mission.Altis.pbo`

  You can also use globs to speed things up:

  `scp -i ./keys/id_rsa -p 2222 ./*.pbo root@localhost:/home/steam/mpmissions/`

2. Locate and copy into the volume folders

  Find the volumes in use by doing:

  `docker inspect data-arma3 | grep "var/lib/docker/*/_data"`

  and then copy them into the path that maps to the /home/steam/mpmissions folder. Then make sure to edit your map rotations/whitelist in the server.cfg and you should be all set.


## Installing mods 

*NOTE*: Might need 'unzip'

Best way to achieve this is if you use the

'scp' 

To do so, you would:

1. Copy it to a local mod

  From the BIA launcher you would copy it as a local mod

  Place it into a location that is convenient for you

  Grab the mod(s) and zip them to a 'Mods.zip'

2. Move it to Docker

  Pulling up a terminal with in the Mods.zip file

  You would: 

  'scp -i ./key/id_rsa -p 2222 ./Mods.zip root@localhost:/home/steam/mods'
  
  And might have to wait, based on the size of the file
  
3. Extract the Mods.zip
  
  From here on you would SSH into the server and run the command:
  
  'unzip Mods.zip'
  
4. Configure Server .conf

  This would either be in the 'basic.conf' or the 'server.conf'
  

## Running multiple instances

*NOTE*: I will include a guide on how to run multiple instances on one machine at a later time.


## Default Settings

For the most part you get the server setup with pretty decent defaults. Verify signatures=2, battle eye enabled, and some networking tweaks in the basic.cfg to name a few. The admin RCON is disabled and so is the server password. I have taken some steps to harden the ssh server against outside intrusion, and you can see the base image used [here](https://github.com/adamveld12/ssh-server)
