docker-lgogdownloader
=====================

Docker image of a WebUI [lgogwebui](https://github.com/graag/lgogwebui) for
[lgogdownloader](https://github.com/Sude-/lgogdownloader), an gog.com download
manager for Linux.

Build
-----

```
docker-compose build
```

Running
-------

The container will run as the user specified by LOCAL_USER_ID variable if it
was set or as user with ID=1000.

It will mount $GOG_DIR inside the container as the folder where downloaded
games will be stored. To change edit the docker-compose.yml file.

It will mount your ~/.cache/lgogdownloader and ~/.config/lgogdownloader folders
inside the container and start bash with TTY. While inside the container you
can execute `lgogdownloader` as usual. Make sure that all three folders exists
before starting the container. If a folder is missing it will be created with
owner set to root.

Example with GOG_DIR set to ~/GOG:
```
mkdir ~/GOG
mkdir ~/.cache/lgogdownloader
mkdir ~/.config/lgogdownloader
GOG_DIR=$HOME/GOG docker-compose run -d -e LOCAL_USER_ID=$UID -p 127.0.0.1:8585:8585 graag/lgogwebui
```
