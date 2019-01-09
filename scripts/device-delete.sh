#!/bin/bash

### it delete a device from heketi
### it receives one argument
### $1 is id of device
### eg. sh device-delete.sh 42663992f6e8949c7e863ca24669a73c


id=$1

heketi-cli device disable $id
heketi-cli device remove $id
heketi-cli device delete $id
