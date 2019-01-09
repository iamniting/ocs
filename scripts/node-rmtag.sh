#!/bin/bash

### it remove arbiter tags from all nodes
### it depends on node-info.sh
### eg. sh node-rmtag.sh


for nodeID in `sh node-info.sh | grep -i "Node Id" | cut -c 10-`
do
	heketi-cli node rmtags $nodeID arbiter
done
