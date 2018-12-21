# it sets arbiter tags on all devices
# it depends on device-info.sh
# it take inputs at runtime
# eg. d for disabled, r for required, s for supported
# eg. sh device-settag.sh


for deviceID in `sh device-info.sh | grep "Device Id" | cut -c 12-`
do
	heketi-cli device info $deviceID | grep "Name"
	read var

    if [ "$var" == "d" ]
    then
        var="disabled"
    fi

    if [ "$var" == "r" ]
    then
        var="required"
    fi

    if [ "$var" == "s" ]
    then
        var="supported"
    fi

    heketi-cli device settags $deviceID arbiter:$var
done
