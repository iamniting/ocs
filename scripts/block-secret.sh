# it creates a secret for gluster-block
# eg. sh block-secret.sh


name=heketi-secret-block
namespace=glusterfs
# echo -n 'adminkey' | base64
key='YWRtaW5rZXk='

echo "apiVersion: v1
kind: Secret
metadata:
  name: $name
  namespace: $namespace
data:
  key: $key
type: gluster.org/glusterblock" | oc create -f -
