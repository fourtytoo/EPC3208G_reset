ARDUINODIR = /usr/local/arduino
BOARD = atmega328
SOURCES = sketch.cc
LIBRARIES = Wire
TARGET = sketch
SERIALDEV = /dev/cuaU0
include ./arduino.mk

# RM = rm -f
# # The CPU: either atmega168 or atmega8
MCU = atmega328p
# # adjust this to the CPU frequency
# F_CPU = 16000000
# CFLAGS = -Wall -Os -mmcu=$(MCU) -DF_CPU=$(F_CPU) -gstabs -I$(ARDUINO)
# LDFLAGS = 
# LDLIBS =-lm -L$(ARDUINO) -larduino
# CC = avr-gcc -std=gnu99
# # not used
# CXX = avr-c++
# OBJCOPY = avr-objcopy
AVRDUDE = avrdude
# # see also usbasp
PROGRAMMER = arduino
# PROGRAMMER = stk500v1
# ARDUINO = /usr/local/arduino
AVRDUDE_PORT = /dev/cuaU0
# SIZE = avr-size


# default: all

# all: sketch.hex

# sketch.bin: sketch.o
# 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ sketch.o $(LDLIBS)

# clean:
# 	$(RM) *.o *.bin *.hex

# dist: clean

uplod: sketch.hex
	$(AVRDUDE) -F -V -p $(MCU) -P $(AVRDUDE_PORT) -c $(PROGRAMMER) -b 19200 -U flash:w:sketch.hex

# ######################################################################

# .SUFFIXES: .bin .hex

# .o.bin:
# 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LDLIBS)

# .c.o:
# 	$(CC) $(CFLAGS) -c $<

# .c.bin:
# 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LDLIBS)

# .bin.hex:
# 	$(OBJCOPY) -R .eeprom -O ihex $< $@
# 	@$(SIZE) $@
