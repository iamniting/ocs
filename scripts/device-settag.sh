# it sets arbiter tags on all devices
# it depends on device-info.sh
# it take inputs at runtime
# eg. d for disabled, r for required, s for supported
# eg. sh device-settag.sh


for device_id in `sh device-info.sh | grep "Device Id" | cut -c 12-`
do
	heketi-cli device info $id | grep "Name"
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

    heketi-cli device settags $device_id arbiter:$var
done
