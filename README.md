# mangos-docker
This repository lists everything needed to build and run Docker images for Mangos project.

## How the repository is organized
Each folder is dedicated to a specific version of Mangos, inside you will find everything about this precise version (from Dockerfile to deployment files).
Each version currently provides 3 Docker images :
* **mangosd**: this the world server that needs maps to work. This is the server the players will be playing on.
* **realmd**: this is the login server. This is the server the players will log into.
* **mysql-database**: this is the database used both by the world server and the login server.

## How to build the Docker images
Each image is self-sufficient, you can build it simply going into the folder of the version you wish to build and using:
```
docker build -t mytag:myversion .
```
Note: **I personnaly have automatic CI/CD to build and push up-to-date Docker images to the Docker Hub.**
## How to create my own server
Several ways are available to launch your own server and are listed below.
### Using Docker containers
This is OK if you want to create a little server with not much players. Also, this is a way to check that your configuration is OK.
#### Launching world server
```bash
docker run -i -v /path/to/maps:/etc/mangos/maps -v /path/to/vmaps:/etc/mangos/vmaps -v /path/to/mmaps:/etc/mangos/mmaps -v /path/to/dbc:/etc/mangos/dbc -e "LOGIN_DATABASE_INFO=localhost;3306;root;mangos;realmd" -e "WORLD_DATABASE_INFO=localhost;3306;root;mangos;mangos" -e "CHARACTER_DATABASE_INFO=localhost;3306;root;mangos;characters" -p 8085:8085 -d ssorriaux/<version>-server:latest
```
##### Configure ahbot.conf
It is possible to configure AH using the `ahbot.conf` file. Add this parameter to the world server launch command:
```bash
-v /path/to/ahbot.conf:/mangosconf/ahbot.conf
```
Be aware to use the `/mangosconf/ahbot.conf` file and not the one in `/etc/mangos/`.

#### Launching the database
```bash
docker run -e MYSQL_ROOT_PASSWORD=mangos -p 3306:3306 -v /path/to/data/:/var/lib/mysql -d ssorriaux/<version>-database-mysql:latest
```
If `/path/to/data` is empty, the database will be initialized running all SQL scripts from the database repository.

Please note the `MYSQL_ROOT_PASSWORD` value will be used for root user password.

If you already have datas and want to update your database, you can use the `/docker-entrypoint-initdb.d` folder. Those scripts will be played before giving access to the database. This can be done adding the following parameter to the previous command:
```bash
-v /path/to/my/sql/scripts/:/docker-entrypoint-initdb.d/
```
#### Launching the login server
```bash
docker run -e "LOGIN_DATABASE_INFO=localhost;3306;root;mangos;realmd" -p 3724:3724 -d ssorriaux/<version>-realmd:latest
```
### Using docker-compose
You will first need to edit the `docker-compose.yml` file to specify the path to your maps.

Then, simply execute:
```bash
docker-compose up -d
```
### Using Kubernetes
Currently, you will need to add the maps on the node that will host the world server and change the `volume` declaration inside the world server deployment.
In the future, it is possible to make this simpler putting all maps inside somewhere and getting it using an `initContainer` or using a `PersistentVolume`.

Create the whole server using:
```bash
kubectl apply -f kubernetes-deployment.yml
```
Passwords are kept inside the `Secret` resource.
#### Using Helm
There is a helm chart included in this repository that can be used to provide a more flexible way of deploying to Kubernetes.

To deploy, make any needed edits to the `values.yaml` file and apply using:
```bash
helm install
```
## What about the maps?
You will **not** find any maps (those resources are Blizzard's properties) in these Docker images, you will need to **provide it yourself** using several methods listed below.
### Using Docker containers
When creating your world server container, you will need to provide the path, from your host, to:
* maps
* vmaps
* mmaps
* dbc

### Using docker-compose
Before creating the whole server, you will need to provide the path, from your host, to:
* maps
* vmaps
* mmaps
* dbc

This can be done editing the `docker-compose.yml` file.
### Using Kubernetes
Before creating the whole server, you will need to provide the path, from your host, to:
* maps
* vmaps
* mmaps
* dbc

This can be done editing the `kubernetes-deployment.yml` file.

#### Using Helm
Host paths can be set by editing the `values.yaml` file.

## How to handle maps on Windows.
* Place your maps in some directory on Windows, for example
```
c:/mangos_maps/maps
c:/mangos_maps/vmaps
c:/mangos_maps/mmaps
c:/mangos_maps/dbc
```
* If you're using docker-compose modify volumes section to look like this
```
 volumes:
       - c:/mangos_maps/maps:/etc/mangos/maps
       - c:/mangos_maps/vmaps:/etc/mangos/vmaps
       - c:/mangos_maps/mmaps:/etc/mangos/mmaps
       - c:/mangos_maps/dbc:/etc/mangos/dbc
```

## Contributing
Feel free to create any issue or pull-request.