#!/bin/bash

### it deletes all volumes from heketi
### eg. sh volume-delete.sh


for volID in `heketi-cli volume list | sort -V -k 3 | awk '{print $1}' | cut -c 4-`
do
	time heketi-cli volume delete $volID
    echo ""
done
