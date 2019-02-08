#!/bin/bash

# support graphvizand make tools
sudo apt-get install curl graphviz unzip wget
sudo apt-get install build-essential automake gettext % automake

# support ARM and MSP430 platforms
sudo apt-get install gcc-arm-none-eabi
sudo apt-get -o Dpkg::Options::="--force-overwrite" install gdb-arm-none-eabi
sudo apt-get -y install gcc gcc-msp430

#support Cooja
#sudo apt-get install openjdk-7-jdk openjdk-7-jre ant

sudo apt-get install libc6-i386

sudo modprobe usbserial
sudo dmesg
lsusb

#Aller dans /contiki/tools/cc2538-bsl

#Faire git clone https://github.com/JelmerT/cc2538-bsl.git

#Faire sudo mv cc2538-bsl/* .

#Faire rm -rf cc2538-bsl

#Aller dans /contiki/examples/hello-world

#Faire sudo apt-get install python-serial

#Faire sudo make hello-world.upload TARGET=zoul
