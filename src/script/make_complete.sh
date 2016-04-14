cd ~/superpages/src/linux-4.1.19/
time make -j 4
#make modules_install
#make install

sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-4.1.19-vik
sudo cp System.map /boot/System.map-4.1.19-vik
