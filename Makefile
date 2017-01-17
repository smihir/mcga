CPUS := $(shell getconf _NPROCESSORS_ONLN)
ROOT := $(shell pwd)
OS := $(shell lsb_release -si)
ARCH := $(shell uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER := $(shell lsb_release -sr)

VENV_READY_MSG :=  "Virtual Environment is ready. Check Vagrants documentation\
for help. SSH into the machine using vagrant ssh"

.bootstrap: .check
	sudo apt-get install -y git build-essential kernel-package fakeroot \
	    libncurses5-dev libssl-dev ccache libdw-dev vagrant virtualbox \
	    flex bison
	touch .bootstrap

.PHONY: systemtap linux linux-deb all
all: linux systemtap redis

src/linux-4.1.19/.config:
	cp src/superpages-4.1.19.config src/linux-4.1.19/.config

systemtap: .check .bootstrap
	mkdir -p out/bin
	cd src/systemtap; ./configure --prefix=$(ROOT)/out/bin
	cd src/systemtap; make install

linux-deb: .check .bootstrap src/linux-4.1.19/.config
	mkdir -p out/install
	cd src/linux-4.1.19; make -j $(CPUS) deb-pkg LOCALVERSION=-mcga
	cd src/linux-4.1.19; make -C tools/perf/
	mv -f src/*.deb out/install

linux: .check .bootstrap src/linux-4.1.19/.config
	cd src/linux-4.1.19; make -j $(CPUS)
	cd src/linux-4.1.19; make -C tools/perf/

linux-perf:
	cd src/linux-4.1.19; make -C tools/perf/

redis: .check
	cd src/bench/redis-3.0; make -j $(CPUS)

venv: .bootstrap linux
	vagrant up --provider virtualbox
	vagrant ssh -c "cd /vagrant/src/linux-4.1.19; \
	    sudo make -j `nproc` modules_install; sudo make -j `nproc` install"
	vagrant ssh -c "cd /vagrant/scripts/grub; \
	    sudo cp grub /etc/default/grub; sudo update-grub2"
	touch .venvinit
	vagrant halt
	vagrant up
	@echo "=============================================="
	@echo $(VENV_READY_MSG)
	@echo "=============================================="

venv-re: .bootstrap linux
	@test -f .venvinit || { echo "\nrun make venv first! Exiting..."; exit 1;}
	vagrant up --provider virtualbox
	vagrant ssh -c "cd /vagrant/src/linux-4.1.19/; \
	    sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-4.1.19; \
	    sudo cp System.map /boot/System.map-4.1.19"
	vagrant ssh -c "cd /vagrant/scripts/grub; \
	    sudo cp grub /etc/default/grub; sudo update-grub2"
	vagrant halt
	vagrant up

venv-de:
	@test -f .venvinit || { echo "\nNo venv present! Exiting..."; exit 1;}
	vagrant destroy
	rm -rf .venvinit

.check:
ifneq ($(OS), Ubuntu)
	$(error Only Ubuntu supported, detected OS is $(OS))
endif
ifeq ($(ARCH),)
	$(error Only x86 supported, detected arch is $(shell uname -m))
endif
	touch .check
