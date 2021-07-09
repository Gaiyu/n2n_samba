FROM arm64v8/alpine:3.14 AS builder
WORKDIR /
COPY n2n-2.8.tar.gz /
RUN set -eux; \
	echo 'nameserver 223.5.5.5' >> /etc/resolv.conf; \
	sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
	apk update; \
	apk add zstd-dev openssl-dev build-base bash autoconf automake pkgconf linux-headers; \
	tar -xf n2n-2.8.tar.gz; \
	cd n2n-2.8; \
	./autogen.sh; \
	./configure; \
	make

FROM arm64v8/alpine:3.14
WORKDIR /
COPY --from=builder /n2n-2.8/edge /usr/local/bin
COPY start /usr/local/bin
COPY smb.conf /etc/samba/smb.conf
RUN set -eux; \
	echo 'nameserver 223.5.5.5' >> /etc/resolv.conf; \
	sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
	apk update; \
	apk add samba-common-tools samba tzdata bash zstd openssl; \
	rm -rf /var/cache/apk/*; \
	mkdir /share; \
	chmod a+x /usr/local/bin/start

EXPOSE 445
VOLUME ["/share"]
ENTRYPOINT ["start"]
