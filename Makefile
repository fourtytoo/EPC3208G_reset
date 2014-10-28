ARDUINODIR = /usr/local/arduino
BOARD = atmega328
SOURCES = sketch.cc
LIBRARIES = Wire
TARGET = sketch
SERIALDEV = /dev/cuaU0
include ./arduino.mk

# The programmer is hooked to another laptop, so we need to copy first
# to that host and then remotely run avrdude.
#
PROGRAMMER_HOST=hell

# The CPU: atmega328, atmega328p, atmega168 or atmega8
MCU = atmega328p

#
# For avrdude to work with the parallel port ISP on FreeBSD you need
# to be part of the wheel group and add the following to
# /etc/devfs.conf:
#	perm    ppi0    0660
#
# For avrdude to work with the USB interface on FreeBSD you need to be
# part of the wheel group and add something like the following to
# /etc/devfs.rules:
#	[localrules=10]
#	add path 'cuaU*' mode 0660 group wheel
#
# assuming that your default ruleset in rc.conf is localrules:
#	devfs_system_ruleset="localrules"


# for the ISP programmer
upld-isp: sketch.hex
	scp sketch.hex $(PROGRAMMER_HOST):
	ssh $(PROGRAMMER_HOST) $(AVRDUDE) -F -V -p $(MCU) -P /dev/ppi0 -c pony-stk200 -U flash:w:sketch.hex

#for the USB interface
upld-usb: sketch.hex
	scp sketch.hex $(PROGRAMMER_HOST):
	ssh $(PROGRAMMER_HOST) $(AVRDUDE) -F -V -p $(MCU) -P /dev/cuaU0 -c arduino -U flash:w:sketch.hex

