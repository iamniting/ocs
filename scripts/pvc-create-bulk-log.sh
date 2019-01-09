#!/bin/bash

### it creates n pvc's with logs which contains time of requests
### eg. sh pvc-create-bulk-log.sh


for i in {001..020}; do
    sh pvc-create.sh claim$i 1;

    echo | tee pvctrace.log
    echo `date` - "pvc claim" $i " creation request sent" | tee pvctrace.log

    while true; do
        var="$(oc get pvc claim$i -o=custom-columns=:.status.phase --no-headers)"

        if [ "${var}" == 'Bound' ]; then
                echo `date` - "pvc claim" $i " creation successful" | tee pvctrace.log
                break
        fi
    done
done
