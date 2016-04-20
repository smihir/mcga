CPUS := $(shell getconf _NPROCESSORS_ONLN)
ROOT := $(shell pwd)
OS := $(shell lsb_release -si)
ARCH := $(shell uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER := $(shell lsb_release -sr)

.bootstrap: .check
	sudo apt-get install -y git build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache libdw-dev vagrant virtualbox
	touch .bootstrap

.PHONY: systemtap linux linux-deb all
all: linux systemtap redis

linux-4.1.19/.config:
	cp src/superpages-4.1.19.config src/linux-4.1.19/.config

systemtap: .check .bootstrap
	mkdir -p out/bin
	cd src/systemtap; ./configure --prefix=$(ROOT)/out/bin
	cd src/systemtap; make install

linux-deb: .check .bootstrap linux-4.1.19/.config
	mkdir -p out/install
	cd src/linux-4.1.19; make -j $(CPUS) deb-pkg LOCALVERSION=-superpages
	mv -f src/*.deb out/install

linux: .check .bootstrap linux-4.1.19/.config
	cd src/linux-4.1.19; make -j $(CPUS)

redis: .check
	cd src/bench/redis-3.0; make -j $(CPUS)

venv: linux Vagrantfile
	vagrant up --provider virtualbox
	vagrant ssh -c "cd /vagrant/linux-4.1.19; sudo make modules_install; make install"

Vagrantfile: .bootstrap
	vagrant init ubuntu/trusty64

.check:
ifneq ($(OS), Ubuntu)
	$(error Only Ubuntu supported, detected OS is $(OS))
endif
ifeq ($(ARCH),)
	$(error Only x86 supported, detected arch is $(shell uname -m))
endif
	touch .check
