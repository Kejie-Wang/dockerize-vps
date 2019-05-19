#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

function install_docker() {
  # remove older version docker.
  sudo apt-get remove docker docker-engine docker.io containerd runc
  # install deps.
  sudo apt-get update && sudo apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
  # add docker gpg key.
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88

  # set docker repository.
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

  # install docker-ce
  sudo apt-get install docker-ce
}

function install_docker_compose() {
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

function install_gogs() {
  mkdir -p $DIR/data/gogs
  docker-compose -f git-server/docker-compose.yml up -d
}

function main() {
  local cmd=$1
  case $cmd in
    docker)
      install_docker
      install_docker_compose
      ;;
    gogs)
      install_gogs
      ;;
    esac
}

main $@
