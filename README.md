# USB Wake Control for Ubuntu

This script disables USB devices (particularly mice) from waking your Ubuntu system from sleep/suspend mode, while maintaining keyboard wake functionality.

## Problem
By default, any movement of a USB mouse can wake Ubuntu from sleep mode. This can be problematic if:
- Your mouse is sensitive and causes unwanted wake-ups
- You have pets that might move the mouse
- You want to ensure your system stays asleep until keyboard interaction

## Solution
This script creates a systemd service that automatically disables wake capabilities for common USB controllers at boot time. It targets standard USB controller names (EHC1, EHC2, XHC, etc.) through the ACPI wake system.

## Prerequisites
- Ubuntu (or other Linux distribution with systemd)
- Root/sudo privileges
- Access to terminal

## Installation

1. Save the script to a file (e.g., `install-usb-wake.sh`):
```bash
wget https://raw.githubusercontent.com/yunatamos/repo/main/install-usb-wake.sh
# or copy the script manually
```

2. Make it executable:
```bash
chmod +x install-usb-wake.sh
```

3. Run the script:
```bash
sudo ./install-usb-wake.sh
```

## What the Script Does

1. Creates a systemd service file at `/etc/systemd/system/disable-usb-wake.service`
2. Creates a control script at `/usr/local/bin/disable-usb-wake.sh`
3. Enables and starts the service to run at boot time
4. Immediately applies the changes

## Verification

To verify the installation:

1. Check the current wake device status:
```bash
cat /proc/acpi/wakeup
```

2. Test the functionality:
   - Put your system to sleep
   - Try moving the mouse (should not wake system)
   - Press a keyboard key (should wake system)

## Troubleshooting

### Keyboard Wake Stops Working
If your keyboard stops waking the system:

1. Identify your keyboard's device name:
```bash
cat /proc/acpi/wakeup
```

2. Edit the control script:
```bash
sudo nano /usr/local/bin/disable-usb-wake.sh
```

3. Remove the relevant device from the list in the script
4. Restart the service:
```bash
sudo systemctl restart disable-usb-wake.service
```

### Uninstallation
To remove the changes:

```bash
sudo systemctl disable disable-usb-wake.service
sudo rm /etc/systemd/system/disable-usb-wake.service
sudo rm /usr/local/bin/disable-usb-wake.sh
```

## Contributing
Feel free to submit issues and enhancement requests!

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- Based on community solutions from Ask Ubuntu
- Inspired by various user contributions to solve USB wake issues
