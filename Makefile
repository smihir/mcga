CPUS := $(shell getconf _NPROCESSORS_ONLN)
ROOT := $(shell pwd)
OS := $(shell lsb_release -si)
ARCH := $(shell uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER := $(shell lsb_release -sr)

.bootstrap: .check
	sudo apt-get install git build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache libdw-dev
	touch .bootstrap

.PHONY: systemtap linux all
all: linux systemtap

systemtap: .check .bootstrap
	mkdir -p out/bin
	cd src/systemtap; ./configure --prefix=$(ROOT)/out/bin
	cd src/systemtap; make install

linux: .check .bootstrap
	mkdir -p out/install
	cp src/superpages-4.1.19.config src/linux-4.1.19/.config
	cd src/linux-4.1.19; make -j $(CPUS) deb-pkg LOCALVERSION=-superpages
	mv -f src/*.deb out/install

.check:
ifneq ($(OS), Ubuntu)
	$(error Only Ubuntu supported, detected OS is $(OS))
endif
ifeq ($(ARCH),)
	$(error Only x86 supported, detected arch is $(shell uname -m))
endif
	touch .check
