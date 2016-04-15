# Navigate and make
echo "\n\n\n\n"
echo "=============================================="
echo "Make Step"
echo "=============================================="
cd ~/vagrant/superpages/src/linux-4.1.19/
time make -j `nproc` | tee make_log
# Check if vagrant is up

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
vagrant ssh -c "sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-4.1.19-vik"
vagrant ssh -c "sudo cp System.map /boot/System.map-4.1.19-vik"
