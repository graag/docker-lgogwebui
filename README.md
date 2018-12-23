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

The container will run as the user executing the docker-compose command if the
UID variable is exported or as user with ID=1000.

It will mount $GOG_DIR inside the container as the folder where downloaded
games will be stored. To change edit the docker-compose.yml file.

It will mount your ~/.cache/lgogdownloader and ~/.config/lgogdownloader folders
inside the container. Make sure that all three folders exists
before starting the container. If a folder is missing it will be created with
owner set to root.

To access the interface go to https://localhost:8080. The SSL certificate used
is selfsigned therefore on the first load browsers will display a warning.

Example with GOG_DIR set to ~/GOG:
```
mkdir ~/GOG
mkdir ~/.cache/lgogdownloader
mkdir ~/.config/lgogdownloader
export UID
export HOSTNAME
GOG_DIR=$HOME/GOG docker-compose up -d
```

To stop the container:
```
docker-compose down
```

To access the logs:
```
docker logs lgogwebui
```

To execute lgogdownloader directly inside running container:
```
docker exec -it -u user lgogwebui lgogdownloader
```

Settings
--------

The lgogdownloader settings can be adjusted by modifing the ~/.config/lgogdownloader/config.cfg.

For example to enable additional languages change the language setting, e.g for polish:
```
language = pl,en
```

Currently the exclude pattern is hard coded at: extras,covers.

Proxy integration
-----------------

For integration with existing proxy use the docker-compose-bare.yml. This will
run lgogwebui listening on 127.0.0.1:8585 and can be used as backend in your
proxy.

Example with GOG_DIR set to ~/GOG:
```
mkdir ~/GOG
mkdir ~/.cache/lgogdownloader
mkdir ~/.config/lgogdownloader
export UID
GOG_DIR=$HOME/GOG docker-compose -f docker-compose-bare.yml up -d
```

Proxy script_name
==============

For proxies where lgogwebui is not served as root path '/' e.g.: https://hostname/lgogwebui - additional setup is required.

Either the proxy has to set X-Script-Name header. Example nginx config:

```
    location /lgogwebui {
        proxy_pass http://127.0.0.1:8585;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header X-Script-Name /lgogwebui;
    }
```

Or a SCRIPT_NAME variable has to be passed to docker-compose:

```
export UID
GOG_DIR=$HOME/GOG SCRIPT_NAME=/lgogwebui docker-compose -f docker-compose-bare.yml up -d
```

Development
-----------

To run the container with direct access to the lgogwebui code one should mount local lgogwebui clone inside the container.

Example with GOG_DIR set to ~/GOG and lgogwebui cloned at ~/lgogwebui
```
git clone https://github.com/graag/lgogwebui.git
mkdir ~/GOG
mkdir ~/.cache/lgogdownloader
mkdir ~/.config/lgogdownloader
export UID
GOG_DIR=$HOME/GOG SRC_DIR=$HOME/Soft/GitHub/lgogwebui docker-compose -f docker-compose-dev.yml up -d
```
