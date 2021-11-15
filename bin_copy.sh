#!/bin/bash

# This is the Binary Copier. It will allow you to litteraly copy paste binaries onto a target machine.
# This is extremely useful for when you either have an unstable shell, or a firewll or something is blocking your upload,
# Or if you just cant directly upload the binary you need for any reason
# Note: Depending on the size of the binary you want to copy, this can, and likely will take longer than uploading the binary to the target via some other method.
# This script is just an alternative for when other upload methods fail.
#
# There are 2 requirements for this tool to work. 
# You must have base64 and xclip installed on your machine
# In order to decode the binary, you target will need to have base64 as well.

b64_path=$(which base64)
xclip_path=$(which xclip) 
zip=$(which gzip)

if [[ $b64_path = "" ]]
then
	echo "Base64 not found"
	exit 1
fi

if [[ $1 = "" ]]
then
	echo "Usage: bin_copy.sh <Path_to_File>"
	exit 1
fi




#compress binary for easier pasting
echo "Compressing Binary to /tmp/tmp.txt"
$zip -c $1 > /dev/shm/tmp.txt
sleep 1

# Encode Binary in base64 and copy output to clipboard using xclip
echo "Encoding Binary with Base64"
sleep 1

if [[ $xclip_path = "" ]]
then 
	echo "xclip not found. Outputting to tmp.txt"
	$b64_path /dev/shm/tmp.txt > tmp.txt
	echo  Binary has been output to tmp.txt
else 
	echo "xclip found. Copying file to clipboard"
	$b64_path /dev/shm/tmp.txt | xclip  -sel c
	echo Binary has been copied to clipboard
fi

sleep 1

echo "Cleaning Up: Deleting /tmp/tmp.txt"
rm /dev/shm/tmp.txt
echo Done
sleep 1

if [[ $xclip_path != "" ]]
then
	echo File has been compressed and copied to clipboard. To paste it onto the target machine:
	echo Create a file called bin.txt and paste your clipboard inside of it \(note that depending on the size fo your binary this may take a minute or two\)
else 
	echo File has been compressed and output to ./tmp.txt. To paste it onto the target machine:
	echo Create a file called bin.txt and paste the contents of ./tmp.txt inside of it \(note that depending on the size fo your binary this may take a minute or two\) 
fi

echo Then execute the following command:
echo $b64_path -d bin.txt \> bin.gz\; gunzip bin.gz\; chmod +x bin 
