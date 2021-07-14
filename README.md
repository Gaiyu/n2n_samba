# n2n_samba
Docker image that packs n2n and samba together, for remote access to SMB/CIFS service.
## Build
Just 2 steps:
 * Run build.sh
``` sh
./build.sh
```
 * Follow the menu
``` sh
--------------------------
Please choose a platform :
--------------------------
[1].aarch64
[2].x86
--------------------------
Select a number [1-2], or press '[Q/q] to exit...
q
bye!
```
## Serve
The command line interface of the entry script of the docker image is as follows, starting a n2n_samba container is to provide parameters for this script.
``` sh
Usage   : ./start [options]
     eg : ./start -s public:/share/pub::rw -s admin:/share/admin:admin:rw -g 1000:smb -u 1000:smb:admin:123
Options :
     -s   <SMB Share Name>:<Path to share>:<User name>:<Read & write permissions>
     -g   <GID to be added>:<User group name>
     -u   <UID to use>:<User group name>:<User name>:<User passwd>
     -a   <n2n tunnel ip mode>:<n2n tunnel ip address>
     -c   <n2n community name>
     -k   <n2n encrypt key>
     -l   <n2n supernode host>:<n2n supernode port>
     -r   n2n enable packet forwarding
     -z   <number>
          n2n enable compression for outgoing data packets, 1 to use lzo1x, 2 to use zstd
     -A   <number>
          1 same as n2n -A1, disable payload encryption
          2 ~ 5, same as n2n -A2 ~ -A5, choose a cipher for payload encryption, 2=Twofish, 3=AES-CBC, 4=ChaCha20, 5=Speck-CTR
     -M   <number>
          n2n MTU of edge interface
     -H   n2n enable full header encryption. Requires supernode with fixed community
     -E   n2n accept multicast MAC addresses (default=drop)
     -S   n2n not connect P2P. Always use the supernode
     -D   n2n enable PMTU discovery
```
Suppose you want to publish the pub directory as an anonymous access share in the following directory structure, and the admin directory is only open to users whose username is admin and password is 123.
``` sh
/home/gaiyu/mynas/data/
├── admin
│   └── admin.txt
└── pub
    └── pub.txt

2 directories, 2 files
```
Then the startup script can be written as follows:
``` sh
#!/bin/sh
IMAGE_NAME='n2n_samba'
IMAGE_TAG='latest'
IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"
SHARE_DIR='/home/gaiyu/mynas/data'
N2N_PARA='-a static:192.168.6.2 -c XXXX -k XXXX -l n2n.XXXX.com:XXXX'
PARA="-s public:/share/pub::rw -s admin:/share/admin:admin:rw -g 1000:smb -u 1000:smb:admin:123 ${N2N_PARA}"
docker run --cap-add CAP_NET_ADMIN --device '/dev/net/tun' -d -p 445:445 -v ${SHARE_DIR}:/share ${IMAGE} ${PARA}
```
