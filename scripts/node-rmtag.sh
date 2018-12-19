# it remove arbiter tags from all nodes
# it depends on node-info.sh
# eg. sh node-rmtag.sh


for node_id in `sh node-info.sh | grep -i "Node Id" | cut -c 10-`
do
	heketi-cli node rmtags $node_id arbiter
done
