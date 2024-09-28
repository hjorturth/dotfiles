#!/usr/bin/env python3
import os
import subprocess
import logging

# Set up logging
logging.basicConfig(filename='polybar_launcher.log', level=logging.INFO, format='%(asctime)s - %(levelname)s: %(message)s')

# Get the name of the primary monitor using 'xrandr'
primary_monitor = subprocess.check_output(['xrandr', '--listmonitors']).decode('utf-8')
primary_monitor = primary_monitor.splitlines()[1].split()[3]

# Get the output of the 'xrandr' command
xrandr_output = subprocess.check_output(['xrandr']).decode('utf-8')

# Kill all running Polybar instances
os.system('pkill polybar')

# Parse the 'xrandr' output to determine the number of monitors
lines = xrandr_output.splitlines()
connected_monitors = [line.split()[0] for line in lines if ' connected' in line]

# Determine the appropriate Polybar instance to launch
for monitor in connected_monitors:
    if monitor == primary_monitor:
        os.system(f'MONITOR={monitor} polybar -r bar1 &')
        logging.info(f"Launched 'bar1' on primary monitor: {monitor}")
    else:
        # Update monitor name in the bar2 configuration file
        bar2_config_file = os.path.expanduser('~/.config/polybar/config_bar2')
        with open(bar2_config_file, 'r') as config_file:
            lines = config_file.readlines()
        
        # Find and replace the monitor line
        with open(bar2_config_file, 'w') as config_file:
            for line in lines:
                if line.startswith('monitor = '):
                    line = f'monitor = {monitor}\n'
                config_file.write(line)
        logging.info(f"Updated 'bar2' configuration for monitor: {monitor}")

        # Launch 'bar2' on secondary monitor
        os.system(f'MONITOR={monitor} polybar -r bar2 &')
        logging.info(f"Launched 'bar2' on secondary monitor: {monitor}")
