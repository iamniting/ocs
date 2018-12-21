# it set arbiter tags on all nodes
# it depends on node-info.sh
# it take inputs at runtime
# eg. d for disabled, r for required, s for supported
# eg. sh node-settag.sh


for nodeID in `sh node-info.sh | grep "Node Id" | cut -c 10-`
do
	heketi-cli node info $nodeID | grep -i 'storage hostname'
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

    heketi-cli node settags $nodeID arbiter:$var
done
