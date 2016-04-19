#!/bin/bash -x

# Navigate and make
echo "\n\n\n\n"
echo "=============================================="
echo "Make Step"
echo "=============================================="
cd ~/vagrant/superpages/src/linux-4.1.19/

#time make -j `nproc` deb-pkg LOCALVERSION=vik | tee ../make_log

# Headers, Linux-image, Linux-deb
cd ~/vagrant/superpages/src/linux-4.1.19/../;
sudo dpkg -i linux-headers-4.1.19vikvik_4.1.19vikvik-16_amd64.deb;
sudo dpkg -i linux-image-4.1.19vikvik_4.1.19vikvik-16_amd64.deb;  
sudo dpkg -i linux-image-4.1.19vikvik-dbg_4.1.19vikvik-16_amd64.deb

# Files to change
