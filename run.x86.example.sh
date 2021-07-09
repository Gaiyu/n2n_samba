#!/bin/sh
IMAGE_NAME='n2n_samba'
IMAGE_TAG='x86'
IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"

#'data' dir example looks like:
#data
#├── admin
#│   └── admin.txt
#└── pub
#    └── pub.txt

#SHARE_DIR='/home/data'

#N2N_PARA='-a static:192.168.6.2 -c ABC -A 1 -z -l n2n.xxxx.com:xxxx'
#PARA="-s public:/share/pub::rw -s admin:/share/admin:admin:rw -g 1000:smb -u 1000:smb:admin:123 ${N2N_PARA}"
#docker run --cap-add CAP_NET_ADMIN --device '/dev/net/tun' -d -p 445:445 -v ${SHARE_DIR}:/share ${IMAGE} ${PARA}
