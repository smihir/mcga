#!/bin/bash

# Navigate and make
echo "\n\n\n\n"
echo "=============================================="
echo "Make Step"
echo "=============================================="
cd ~/vagrant/superpages/src/linux-4.1.19/

:'
if [ ! -e ".config" ] then
	make menuconfig
else 
	echo "Menuconfig exists"
fi
'

time make -j `nproc` | tee make_log
# Check if vagrant is up
:'
start()
{
	vagrant up
	check_machine_up
}


check_machine_up ()
{
	if [ "$status" = "running" ] then
		echo "Machine is running\n"
	else
		echo "Machine not running\n"
		start
	fi
}

status=$(vagrant status | head -n 3 | tail -n 1 | awk '{print $2}' 2>&1)
check_machine_up
'

# Run the make steps
echo "\n\n\n\n"
echo "=============================================="
echo "Make Modules Install"
echo "=============================================="
vagrant ssh -c "cd /vagrant/superpages/src/linux-4.1.19/; time sudo make modules_install -j `nproc` | tee make_modules_install_log"

echo "\n\n\n\n"
echo "=============================================="
echo "Make  Install"
echo "=============================================="
vagrant ssh -c "cd /vagrant/superpages/src/linux-4.1.19/; time sudo make install -j `nproc` | tee  make_install_log"

# Copy the Binaries
vagrant ssh -c "cd /vagrant/superpages/src/linux-4.1.19/; 
		sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-4.1.19-vik;
		sudo cp System.map /boot/System.map-4.1.19-vik"
vagrant ssh -c "sudo update-grub"
# Change the grub file for updating the correct kernel to boot from
vagrant ssh -c ""

