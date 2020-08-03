# Public Domain

.PHONY:	love
love:	all

# Everything is autoconfigured
SRC=$(patsubst %/,%,$(dir $(shell find kernel -name dkms.conf.in)))
MOD=$(notdir ${SRC})
LOC=$(patsubst %/,%, $(dir ${SRC}))
VER=$(shell cat VERSION)
KERNELS=$(notdir $(wildcard /var/lib/initramfs-tools/*))

export LOC MOD VER

.PHONY:	all
all:	install

.PHONY:	install
install:	uninstall ${SRC}/dkms.conf
	dkms add '${SRC}'
	for kern in $(KERNELS); do dkms install '${MOD}/${VER}' -k "$$kern" || break; done

.PHONY:	uninstall
uninstall:
	-rmmod '${MOD}'
	-dkms remove '${MOD}/${VER}' --all

${SRC}/dkms.conf:	${SRC}/dkms.conf.in Makefile
	gawk '{ while (match($$0, /[{][^}]*[}]/)) $$0=substr($$0,1,RSTART-1) ENVIRON[substr($$0,RSTART+1,RLENGTH-2)] substr($$0,RSTART+RLENGTH); print }' '$<' >'$@'

${MOD}/dkms.conf.in:
	@echo 'SRC=${SRC}'
	@echo "LOC=$$LOC"
	@echo "MOD=$$MOD"
	@echo "VER=$$VER"

