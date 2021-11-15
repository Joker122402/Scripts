This is the binary copier. As the name entails, it will allow you to copy paste binary files between machines. This is accomplished using gzip and base64.

I designed this for situation where for whatever reason, you can't upload a binary to the target host via any of the traditional methods. 

Note: Depending on the size of the binary you want to copy, this can and likely will take longer than uploading using traditional methods. Once again, my goal with this script is to have an alternative for when all other methods fail.

```
Requirements:
Both your machine and the target machine need to have base64 and gzip availible. If you have xclip it will be used to copy the base64 encoded binary to your clipboard. Though xclip isnt required, it is highly reccomended.
```

```
Usage:
./bin_copy.sh <path_to_file>