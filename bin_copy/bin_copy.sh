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
gzip=$(which gzip)

xclip=Flase
zip=False

function check_xclip() {
	if [[ $xclip_path = "" ]]
	then 
		xclip=False
	else 
		xclip=True
	fi
}

function check_b64() {
	if [[ $b64_path = "" ]]
	then
		echo "Base64 not found"
		exit 1
	fi
}

function check_compression(){
	if [[ $2 = "" ]]
	then
		zip=True
	elif [[ $2 = "-n" || $2 = "--no-compression" ]]; then
		zip=False
	else
		echo unknown flag $2
		exit 1
	fi
}

check_b64
check_xclip
check_compression

if [[ $1 = "" ]]
then
	echo "Usage: bin_copy.sh <Path_to_File>"
	exit 1
fi

if [[ $zip = True ]]
then
	echo "Compressing Binary to /dev/shm/tmp.txt"
	cp $1 /dev/shm/tmp
	$gzip /dev/shm/tmp
	sleep 1
else
	echo "-n/--no-compression detected: Skipping Compression"
	cp $1 /dev/shm/tmp.gz
	sleep 1
fi

# Encode Binary in base64 and copy output to clipboard using xclip
echo "Encoding Binary with Base64"
sleep 1

if [[ xclip = Flase ]]
then
	echo "xclip not detected. Outputting to file: ./tmp.txt"
	$b64_path /dev/shm/tmp.gz > ./tmp.txt
	sleep .3

	echo File has been compressed and output to ./tmp.txt. To paste it onto the target machine:
	sleep .3

	echo Create a file called bin.txt and paste the contents of ./tmp.txt inside of it \(note that depending on the size fo your binary this may take a minute or two\) 
	sleep .3
else
	echo "xclip detected. Outputting to clipboard"
	sleep .3

	$b64_path /dev/shm/tmp.gz | $xclip_path -sel c
	echo File has been compressed and copied to clipboard. To paste it onto the target machine:
	sleep .3

	echo Create a file called bin.txt and paste your clipboard inside of it \(note that depending on the size fo your binary this may take a minute or two\)
	sleep .3
fi

echo Then execute the following command:
sleep 3

echo $b64_path -d bin.txt \> bin.gz\; gunzip bin.gz\; chmod +x bin\; rm bin.txt
echo " "
sleep 1

echo "Cleaning Up: Deleting /dev/shm/tmp.gz"
rm /dev/shm/tmp.gz
echo Done
sleep 1
