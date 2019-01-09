#!/bin/bash

### it creates n pvcs and whenever any pvc got bound it will create a new pvc and make n requests in pending state
### eg. sh pvc-create-n-requests.sh


create_pvc()
{
    for (( i=$1; i<=$2; i++ ))
    do
        sh pvc-create.sh claim$i 1
    done
}


begin=101
end=200
n=8

create_pvc $begin $begin+$n-1

while true; do
    count=`oc get pvc | grep claim | grep Pending | wc -l`
    if [ $count -lt $n -a $i -le $end ]; then
        create_pvc $i $n-1-$count+$i
    elif [ $i -gt $end ]; then
        break
    fi
done
