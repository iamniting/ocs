# it creates a secret for gluster-block
# eg. sh block-secret.sh


name=heketi-secret-block
nameSpace=glusterfs
# echo -n 'adminkey' | base64
key='YWRtaW5rZXk='

echo "apiVersion: v1
kind: Secret
metadata:
  name: $name
  namespace: $nameSpace
data:
  key: $key
type: gluster.org/glusterblock" | oc create -f -
