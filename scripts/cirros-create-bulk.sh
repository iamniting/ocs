#!/bin/bash

### it creates n cirros app pods
### it depends on cirros-create.sh
### eg. sh cirros-create-bulk.sh


for i in {001..020};
do
    sh cirros-create.sh $i claim$i;
    sleep 5
done
