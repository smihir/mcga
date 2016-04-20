#!/bin/bash -x

# Navigate and make
echo "\n\n\n\n"
echo "=============================================="
echo "Make Step"
echo "=============================================="
cd src/linux-4.1.19/

time make -j `nproc` | tee linux-make.log
# Copy the Binaries
vagrant ssh -c "cd /vagrant/src/linux-4.1.19/;
		sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-4.1.19vik;
		sudo cp System.map /boot/System.map-4.1.19vik"

cd -
