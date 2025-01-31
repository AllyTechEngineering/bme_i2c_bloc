# Proof of Concept Temperature, Humidity Closed Loop Control System

Proof of concept of a temperature, humidity & barometric pressure
closed loop control system with touchscreen.

## Equipment Needed
- Raspberry Pi Model 4B or 5 with 8G of RAM
- Raspberry Pi OS for Desktop
- BME280 Sensor
- Heater
- Atomizer
- Relays
- Power MOSFET with level shift
- Brush DC motor with fan blade
- Enclosure

## My Fix For Model 5 PWM issues - Model 4B solutions in upcoming section.
### Step One Create a Custom dtoverlay
*******************************************************************************************************************
This link has all of the details for creating the dtoverlay that I find works for pwmchip2, pwm0
https://gist.github.com/Gadgetoid/b92ad3db06ff8c264eef2abf0e09d569

In a new terminal window:
Use sudo nano and copy this code and save as pwm-pi5-overlay.dts

'''
/dts-v1/;
/plugin/;

/{
	compatible = "brcm,bcm2712";

	fragment@0 {
		target = <&rp1_gpio>;
		__overlay__ {
			pwm_pins: pwm_pins {
				pins = "gpio12", "gpio13", "gpio18", "gpio19";
				function = "pwm0", "pwm0", "pwm0", "pwm0";
			};
		};
	};

	fragment@1 {
		target = <&rp1_pwm0>;
		frag1: __overlay__ {
			pinctrl-names = "default";
			pinctrl-0 = <&pwm_pins>;
			status = "okay";
		};
	};
};
'''

To compile (copy this at the command line): dtc -I dts -O dtb -o pwm-pi5.dtbo pwm-pi5-overlay.dts
Then to install (copy this at the command line): sudo cp pwm-pi5.dtbo /boot/firmware/overlays/
Comment out any pwm dtoverlays and add this line dtoverlay=pwm-pi5 to boot/firmware config.txt (use sudo nano config.txt)

### Step Two: Create a udev rule
*******************************************************************************************************************
We need to create a new udev rule that will export and enable the pwm channels at boot
sudo nano /etc/udev/rules.d/99-pwm.rules

Copy and paste the following - if you changed the overlay and the pwmchip_ number change the following to match your changes.

'''
ACTION=="add", SUBSYSTEM=="pwm", KERNEL=="pwmchip0", RUN+="/bin/sh -c 'echo 0 > /sys/class/pwm/pwmchip0/export'"
ACTION=="add", SUBSYSTEM=="pwm", KERNEL=="pwmchip2", RUN+="/bin/sh -c 'echo 0 > /sys/class/pwm/pwmchip2/export'"
ACTION=="add", SUBSYSTEM=="pwm", KERNEL=="pwmchip6", RUN+="/bin/sh -c 'echo 0 > /sys/class/pwm/pwmchip6/export'"
'''

After saving the file, reload the udev rules.
sudo udevadm control --reload-rules && sudo udevadm trigger

You will need to reboot.

### Step Three: Check the PWMs
*******************************************************************************************************************
These commands will check with pwm0 has been exported.
'''
ls /sys/class/pwmchip0
device  export  npwm  power  pwm0  subsystem  uevent  unexport
ls /sys/class/pwmchip2
device  export  npwm  power  pwm0  subsystem  uevent  unexport
ls /sys/class/pwmchip6
device  export  npwm  power  pwm0  subsystem  uevent  unexport
'''

Other usefull command line instructions:
To check for how many channels per pwmchip
'''
grep . /sys/class/pwm/pwmchip*/npwm
/sys/class/pwm/pwmchip0/npwm:2
/sys/class/pwm/pwmchip2/npwm:4
/sys/class/pwm/pwmchip6/npwm:4
'''

This command will check to see if a pwm is enabled. This is for pwmchip0,pwm0.
'''
cat /sys/class/pwm/pwmchip0/pwm0/enable
cat /sys/class/pwm/pwmchip0/pwm0/enable
cat /sys/class/pwm/pwmchip0/pwm0/enable
'''
If the response is 0, the pwm has been exported but not enabled.
If the response is 1, the pwm has been enabled.


### Step Four: Test the PWMs with a Bash Script
*******************************************************************************************************************
I am testing either pwmchip0,pwm0 pwmchip2,pwm0 or pwmchip6,pwm0. In this script it is pwmchip2,pwm0
If you changed your dtoverlay and udev rules you will need to change this script accordingly.

For GPIO 12,13,18 and 19 the alt function for PWM is either a0, a4 or a5.

Full transparancy, I am not a bash script expert so if you have a better solution please share!

In terminal, in a folder of your choice, sudo nano pwmchip2_pwm0.sh and then copy the following script:
'''

#!/bin/bash  # Ensure the script runs with bash

NODE=/sys/class/pwm/pwmchip2  # Correct PWM chip
CHANNEL="0"  # Force PWM 0
PIN="12"     # GPIO 12 for PWM 0
FUNC="a0"

PERIOD="$1"
DUTY_CYCLE="$2"

usage() {
    echo "Usage: $0 <period> <duty_cycle>"
    echo "    period - PWM period in nanoseconds"
    echo "    duty_cycle - Duty Cycle (on period) in nanoseconds"
    exit 1
}

pwmset() {
    echo "$2" | sudo tee -a "$NODE/$1" > /dev/null
}

if [[ "$PERIOD" == "off" ]]; then    
    if [ -d "$NODE/pwm$CHANNEL" ]; then
        pinctrl set $PIN no
        pwmset "pwm$CHANNEL/enable" "0"
        pwmset "unexport" "$CHANNEL"
    fi
    echo "PWM 0 disabled."
    exit 0
fi

if [[ ! $PERIOD =~ ^[0-9]+$ ]]; then usage; fi
if [[ ! $DUTY_CYCLE =~ ^[0-9]+$ ]]; then usage; fi

if [ ! -d "$NODE/pwm$CHANNEL" ]; then
    pwmset "export" "$CHANNEL"
    sleep 0.1
fi

pwmset "pwm$CHANNEL/period" "$PERIOD"
pwmset "pwm$CHANNEL/duty_cycle" "$DUTY_CYCLE"
sleep 0.1  # Allow settings to apply
pwmset "pwm$CHANNEL/enable" "1"

pinctrl set $PIN $FUNC

echo "PWM 0 (GPIO $PIN, Fn. $FUNC) set to $PERIOD ns, $DUTY_CYCLE ns."
'''

Save the file with a name that makes sense to you. For example, pwmchip2_pwm0.sh

To set permissions so you can run the script: sudo chmod +x pwmchip2_pwm0.sh

Use this command in terminal (assuming you are in the same folder) to run the script: sudo bash ./pwmchip2_pwm0.sh 1000000 500000
This sets the period in ns and the duty cycle in ns which results in a 50% duty cycle square wave.
If you set the duty cycle to 0 the PWM is low and if you set it at 100000 it is high.

### Step Five, Test in your Flutter App with dart_periphery
*************************************************************************************************
Using the dtoverlay and udev as shown, I have successfully ran all four PWMs at the same time in my app.
'''
pwm0 = PWM(2, 0);
pwm1 = PWM(2, 1);
pwm2 = PWM(2, 2);
pwm3 = PWM(2, 3);
'''


