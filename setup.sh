#! /bin/bash
sudo apt update
sudo apt install docker.io -y

sudo usermod -aG docker $USER

newgrp docker

mkdir ~/github && cd ~/github && git clone https://github.com/f1amy/laravel-realworld-example-app.git

cd ~/github/laravel-realworld-example-app

