#!/bin/bash

# Copy the default kernel
vagrant ssh -c "sudo cp /boot/vmlinuz-4.1.19-vik.stable /boot/vmlinuz-4.1.19-vik; 
		sudo cp /boot/System.map-4.1.19-vik.stable /boot/System.map-4.1.19-vik"
vagrant ssh -c "sudo update-grub"
# Change the grub file for updating the correct kernel to boot from
vagrant ssh -c ""

