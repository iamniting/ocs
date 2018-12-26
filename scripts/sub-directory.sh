# it creates a directories and sub-directories & verify checksum
# sh script.sh

mkdir -p 01/{01..10}/{01..10}/{01..10}

echo "hello we are writing data into files" | tee 01/{01..10}/{01..10}/{01..10}/file
echo "hello we are writing data into files" | tee 01/{01..10}/{01..10}/file
echo "hello we are writing data into files" | tee 01/{01..10}/file
echo "hello we are writing data into files" | tee 01/file

hex=`find 01 -type f -name file -exec md5sum {} + | awk '{print $1}' | sort | md5sum`

if [ "$hex" == "d256be3c7826e725825c4b7c6f8c40a7  -" ]; then
    echo "checksum is correct"
else
    echo "checksum is not correct"
fi
