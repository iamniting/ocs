#!/bin/bash

### it delete node from heketi
### it depend on device_delete.sh
### it takes one argument
### $1 is id of node
### eg. node-delete.sh aae139bbfe94184438ac830bc2c3e552


id=$1

for deviceID in `heketi-cli node info $id | grep "Bricks" | awk '{print $1}' | cut -c 4-`
do
	sh device_delete.sh $deviceID
done

heketi-cli node disable $id
heketi-cli node remove $id
heketi-cli node delete $id
