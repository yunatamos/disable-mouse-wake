#!/bin/bash

# Show initial state
echo "Current wake devices:"
cat /proc/acpi/wakeup | sort

# Common USB controller names that might control mouse wake
USB_DEVICES=("EHC1" "EHC2" "XHC" "XHCI" "XHC0" "USB0" "USB1" "USB2" "USB3" "USB4")

# Create systemd service file for persistence
cat << 'EOF' | sudo tee /etc/systemd/system/disable-usb-wake.service
[Unit]
Description=Disable USB wakeup
After=multi-user.target
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash /usr/local/bin/disable-usb-wake.sh
[Install]
WantedBy=multi-user.target
EOF

# Create the script that will be run by the service
cat << 'EOF' | sudo tee /usr/local/bin/disable-usb-wake.sh
#!/bin/bash
for device in EHC1 EHC2 XHC XHCI XHC0 USB0 USB1 USB2 USB3 USB4; do
    if grep -q "^$device.*enabled" /proc/acpi/wakeup; then
        echo "$device" > /proc/acpi/wakeup
    fi
done
EOF

# Make the script executable
sudo chmod +x /usr/local/bin/disable-usb-wake.sh

# Enable and start the service
sudo systemctl enable disable-usb-wake.service
sudo systemctl start disable-usb-wake.service

# Run it immediately
sudo /usr/local/bin/disable-usb-wake.sh

echo -e "\nFinal wake device status:"
cat /proc/acpi/wakeup | sort

echo -e "\nSetup complete. The changes will persist across reboots."
echo "Test by suspending your system - keyboard should still wake it but mouse should not."
echo "If keyboard wake stops working, modify /usr/local/bin/disable-usb-wake.sh to exclude the relevant device."
