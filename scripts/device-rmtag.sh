#!/bin/bash

### it remove arbiter tags from all devices
### it depends on device-info.sh
### eg. sh device-rmtag.sh


for deviceID in `sh device-info.sh | grep "Device Id" | cut -c 12-`
do
	heketi-cli device rmtags $deviceID arbiter
done
