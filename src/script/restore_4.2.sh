#!/bin/bash

# Copy the default kernel
vagrant ssh -c "sudo cp /boot/vmlinuz-4.2.stable /boot/vmlinuz-4.2; 
		sudo cp /boot/System.map-4.2.stable /boot/System.map-4.2"
vagrant ssh -c "sudo update-grub"
# Change the grub file for updating the correct kernel to boot from
vagrant ssh -c ""

