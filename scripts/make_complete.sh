#!/bin/bash -x

# Navigate and make
echo "\n\n\n\n"
echo "=============================================="
echo "Make Step"
echo "=============================================="
cd ~/vagrant/superpages/src/linux-4.1.19/

time make -j `nproc` | tee ../make_log
# Copy the Binaries
vagrant ssh -c "cd /vagrant/superpages/src/linux-4.1.19/; 
		sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-4.1.19vik;
		sudo cp System.map /boot/System.map-4.1.19vik"

