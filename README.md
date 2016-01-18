# apache-drill-with-S3-docker
An apache drill setup in docker primed for using with S3.

This repo and walkthrough relies heavily on information found or copied from these sources:
  - Apache Drill Documentation: https://drill.apache.org/docs/s3-storage-plugin/
  - MapR odbc setup: https://www.mapr.com/blog/using-drill-programmatically-python-r-and-perl

## Setup

Initial Repo setup
```sh
git clone https://github.com/brentpayne/apache-drill-with-S3.git
cd apache-drill-with-S3
```

Insert your project's info into these files

*s3.sys.drill*
S3 drill storage definition
 -  : replace *YOUR_S3_BUCKET* with your S3 bucket's repo.
 -  : [OPTIONAL] it is always good to have you own workspace, so create a _data_ folder in your S3 bucket or change the _data_ workspace with the key-prefix/folder for your data.

*core-site.xml*
Apache Drill configuration file that sets up AWS credentials.  NOTE: the max S3 connections is set pretty high here.
 -  :  Insert AWS credentials that have access to your S3 bucket for *PLACE_YOUR_ACCESS_KEY_HERE* and *PLACE_YOUR_SECRET_KEY_HERE_IT_IS_LONGER_THAN_THE_ACCESS_KEY*

## Run drill with S3 connections
If you don't already have docker + docker-machine install skip to the reference section

To run the development docker with interative debugging
```sh
docker-machine start default
eval "$(docker-machine env default)"
docker build -t brentpayne/drillS3 .
docker run -it -p 8047:8047 brentpayne/drillS3 bash
sh /etc/bootstrap.sh
```

You can now run queries via the command line in the docker or on the apache drill webpage.
You can broswe to the drill webpage via the virtual box's IP on port 8047.

Find the IP that your docker VM :
```sh
docker-machine ip default
```

Assume this is _192.168.99.100_ . Then you can browse to 192.168.99.100:8047


# Reference Section 
## Docker setup

This sections draws a lot from the Docker documents.  You might be best suited by using it. The instruction below are for using docker-machine on Macs..

Download and setup docker and docker-machine.  
  - https://docs.docker.com/
  - https://docs.docker.com/mac/
  - https://docs.docker.com/machine/install-machine/

# Docker Setup and Development walkthrough

## Install Docker

We need both docker and docker-machine installed.

Best to just install the Docker Toolbox. I don't use Kitematic, but it could be awesome:

https://www.docker.com/docker-toolbox

For reference:

Docker Toolbox Mac Installation instructions/tutorial: https://www.docker.com/docker-toolbox <br>
Docker engine install page: https://docs.docker.com/engine/installation/mac/  <br>
Docker machine manual install: https://docs.docker.com/machine/install-machine/ <br>

I forget if you have to create the default docker VM or not.  If you do, give it a enough memory and disk space.
```sh
docker-machine create -d virtualbox --virtualbox-memory 4096 --virtualbox-disk-size 20000 default
```

If not, you'll most likely need to increase these in your docker virtual machine:
http://stackoverflow.com/questions/32834082/how-to-increase-docker-machine-memory-mac

```sh
emacs ~/.docker/machine/machines/default/config.json
docker-machine restart default
```
_ no comments necessary about how vim is better than emacs, just use what you want _

## Running Development Docker

Startup default docker vm.  I often do this after changing network, for example going from home to work.  Otherwise, it seems the VM network is no longer properly connected.
```sh
docker-machine restart default
```

Setup docker environment variable to the default vm
```sh
eval "$(docker-machine env default)"
```

Build development Docker image, could take a while for first build
```sh
docker build -t brentpayne/drillS3 .
```

Breaking the above command down.  `brentpayne` is my dockhub username, `-t brentpayne/drillS3` specifies the docker image's tag.  `.` is where the _Dockerfile_ exists.  The _Dockerfile_ describes how to build a docker image.

For reference, this is the end of a successful build
```sh
...
 ---> 56dfe8a937cb
Step 16 : ADD s3.sys.drill /drill-storage/sys.storage_plugins/s3.sys.drill
 ---> Using cache
 ---> f8e89fde2185
Step 17 : CMD bash /etc/bootstrap.sh
 ---> Running in 09cd493bf0e3
 ---> 866324821d75
Removing intermediate container 09cd493bf0e3
Successfully built 866324821d75
```

This command lists current docker images
```
docker images
```

Now we can start of a container instance and connect to a bash terminal.
```sh
docker run -it -p 8047:8047 brentpayne/drillS3 bash
bash /etc/bootstrap.sh
```

Breaking this command down, the `-it` options are needed for an interactive terminal connection.  `-p 8047:8047` sets the docker VM's port 8047 to forward to the container's port 8047.

