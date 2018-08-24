#!/bin/bash

set -e

source $(dirname $0)/helpers.sh

it_can_get_version_from_artifactory() {

  # local local_ip=$(find_docker_host_ip)
  #local_ip="localhost"

  artifactory_ip=$ART_IP
  TMPDIR=/tmp

  local src=$(mktemp -d $TMPDIR/in-src.XXXXXX)
  local endpoint="http://${artifactory_ip}:8081/artifactory"
  local regex="ecd-front-(?<version>.*).tar.gz"
  local folder="/generic/ecd-front"
  local version="20161109222826"

  in_without_credentials_with_version $endpoint $regex $folder $version $src

}

it_cant_get_version_from_artifactory() {

  # local local_ip=$(find_docker_host_ip)
  #local_ip="localhost"

  artifactory_ip=$ART_IP
  TMPDIR=/tmp

  local src=$(mktemp -d $TMPDIR/in-src.XXXXXX)
  local endpoint="http://${artifactory_ip}:8081/artifactory"
  local regex="ecd-front-(?<version>.*).tar.gz"
  local folder="/generic/ecd-front"
  local version="NONE"

  in_without_credentials_with_version $endpoint $regex $folder $version $src

}

it_can_get_version_from_artifactory_with_credentials() {

  # local local_ip=$(find_docker_host_ip)
  #local_ip="localhost"

  artifactory_ip=$ART_IP
  TMPDIR=/tmp

  local src=$(mktemp -d $TMPDIR/in-src.XXXXXX)
  local endpoint="http://${artifactory_ip}:8081/artifactory"
  local regex="ecd-front-(?<version>.*).tar.gz"
  local folder="/generic/ecd-front"
  local version="20161109222826"
  local username="${ART_USER}"
  local password="${ART_PWD}"

  in_with_credentials_with_version $endpoint $regex $folder $version $src $username $password

}

it_can_skip_download() {

  # local local_ip=$(find_docker_host_ip)
  #local_ip="localhost"

  artifactory_ip=$ART_IP
  TMPDIR=/tmp

  local src=$(mktemp -d $TMPDIR/in-src.XXXXXX)
  local endpoint="http://${artifactory_ip}:8081/artifactory"
  local regex="ecd-front-(?<version>.*).tar.gz"
  local folder="/generic/ecd-front"
  local version="20161109222826"
  local skip_download="true"

  in_without_credentials_with_version_and_skip_download $endpoint $regex $folder $version $src $skip_download

}

#run it_can_get_version_from_artifactory
run it_can_get_version_from_artifactory_with_credentials
run it_can_skip_download

# check for exit code > 0
#run it_cant_get_version_from_artifactory
