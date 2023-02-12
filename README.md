# How to dockerize a laravel application and serve it using LEMP stack and docker compose

## Requirements
- docker
- docker-compose or docker compose

## Procedure

1. Clone laravel app git repo and create the [`.env` file](./.env)
   ```bash
   git clone https://github.com/de-marauder/laravelapp.git
   cd laravelapp
   nano .env
   ```
2. Using the compose image, run a container with a binded mount to install application dependencies and run updates
   ```bash
   docker run -it --name compose --rm -v $(pwd):/app composer install
   docker run -it --name compose --rm -v $(pwd):/app composer update
   ```
3. Write the docker-compose.yml file. There will be 3 services (containers). One for the laravel application, one for the database and one for our web server (nginx). It should look like [this](./docker-compose.yml). The services are connected together by a custom bridge network (this allows containers to reference themselves using their names as a DNS). Data mounts are also attached to transfer the application after it has been built to the webserver service and log access data in the `./logs` directory of the cloned repo. Volumes are also mounted for transfering database log data. 
4. Write a [Dockerfile](./Dockerfile) for the laravel app using the `php:fpm` base image. It should look like [this](./Dockerfile)
5. Run docker compose
   ```bash
   docker compose up -d
   ```
6. Create database user and assign privileges
   ```bash
   docker exec -it db bash
   ```
   then,
   ```bash
   mysql -u root -p
   # input your password defined in the docker-compose file
   ```
   then,
   ```bash
   show databases; # to confirm your database defined in the docker-compose file was created
   GRANT ALL ON laravel.* TO 'laraveluser'@'%' IDENTIFIED BY 'your_laravel_db_password';
   ```
   make sure to change `laraveluser` (the database user) and `your_laravel_db_password` (the database password) to what is defined in docker-compose file.
   ```bash
   FLUSH PRIVILEGES; # alert the mysql server about changes
   ```
   Exit the mysql console
   ```bash
   EXIT
   ```
   Exit container
   ```bash
   exit
   ```

7. Migrate the applications database
   ```bash
   docker exec -it app bash -c "php artisan migrate --seed"
   ```
8. Check your host IP or localhost to verify application is working.
   ```bash
   curl localhost
   ```

