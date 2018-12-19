# it makes a password less ssh
# it takes two arguments
# $1 is file name where all ip addresses or hostnames is stored
# $2 is password of hosts
# eg. sh sshcopy.sh ip.list redhat


file=$1
pass=$2

for host in `cat $file`
do
    sshpass -p $pass ssh-copy-id  -o "StrictHostKeyChecking=no" root@$host -f
done
