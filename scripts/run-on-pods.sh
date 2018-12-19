# it runs a command on app pod
# it takes one argument
# $1 is command, quote the command if it's more than a s


pods=`oc get pods | grep glusterfs | awk '{print $1}'`
cmd=$1

for pod in `echo $pods`; do
    oc exec -it $pod -- bash -c "$cmd"
done
