#!/bin/bash

echo "Updating the Repositories..\n"

apt-get update

echo "Installing the bind9\n"

apt-get install bind9

echo "Stoping the bind9 server (fix it later)\n"

systemctl stop bind9 ; systemctl disable bind9

echo "done!\n"
