# IDE-RAM-A500
This project is a 2MB autoconfig Fast SRAM and IDE port expansion for Amiga 500 and plus.

The two things that the A500 lacks the most are probably a hard drive, and Fast RAM. mkl from http://www.mkl211015.altervista.org has created both expansions, ide68k and ram68k, that sit under the 68000, and can be stacked. I thank him for publishing his schematic and code since it inspired this project, and the base of the IDE CPLD code is a verilog conversion I made from his abel of version 425.

Facts about this project :
- It sits under the CPU : does not block access to the ROM and does not need a relocator.
- I wanted a mini-IDE port, this is the main reason why I started to create my own board.
- I thought that it would be neat to have some Fast RAM on the same PCB. I had a great SRAM chip for another project, PCMCIA-SRAM, and Sector101 shared an interesting experiment that proved it could work : https://blog.sector101.co.uk/2019/07/20/amiga-500-2mb-handwired-fastram-expansion/ . Sukkopera also shared the OpenAmiga500FastRamExpansion from which the RAM autoconfig CPLD code is taken : https://github.com/SukkoPera/OpenAmiga500FastRamExpansion/ .
- Adding RAM stuff to the code and routing all of this on a 2-layers PCB required to reassign CPLD pins, so I started converting the IDE CPLD code to verilog, with a convenient UCF file.
- The IDE port simulates the one from the A600 so it is bootable with appropriate Kickstarts. Like other IDE expansions, it requires two additional signals from the motherboard : INT2 and OVR.
- The RAM stuff takes the place of the first expansion in the autoconfig chain. You cannot use another autoconfig expansion on the expansion port without a bit more hacking.

# Disclaimer
This is a hobbyist project, it comes with no warranty and no support. Also remember that the Amiga machines are about 30 years old and may fail because of such hardware expansions.

This version is not connected to mkl211015, please don't bother him with issues you might have because of it.

I publish my work under the CC-BY-NC-SA license. Autoconfig code from Sukkopera is CERN OHL v1.2.

If you find it useful and want to reward me : I am always looking for Amiga/Amstrad CPC hardware to repair and hack, please contact me.

# BOM
- 1x XC95144XL CPLD
- 1x CY62167ELL-45ZXI 5V SRAM (do not use 3.3V CY62167EV !). For 4MB you may also, with small changes in the CPLD code (addressing and autoconfig) :
 - stack a second chip on the first one and connect its pin 12 to the pad nearby,
 - use a CY62177ESL-55ZXI 5V SRAM instead (rare, expensive, not tested by me).
- 1x SPX3819M5-L-3-3 3.3v LDO
- 2x 1uF (or more) 0805 capacitors
- 5x 100nF 0805 capacitors
- 3x 10k 0805 resistors
- 2x 4k7 0805 resistors
- 1x BAT54A (or equivalent) diodes
- 64x rounded socket pins, for CPU pass-through connection. I use pins taken from a socket header.
- 1x 2x22 2.0mm pin header. Remove pin 20 which is a key.
- 2x wires for INT2 and OVR signals
- optional : 1x LED and resistor (330 ohm 0805 for example)

# Making it
Components are SMD, and have thin pin pitch. You need to know what you are doing.

Check for shorts at least between 5V, 3.3V, and GND traces before applying power !

The programming port does not need to be soldered since it needs to be programmed just once : you can just hold it in place during the few seconds required for programming.

CPLD code is generated using Xilinx ISE 14.7. There are several methods to program the XC9536XL. I personally use xsvfduino : https://github.com/wschutzer/xsvfduino

# Using it
- Remove the 68000 CPU from the motherboard
- Insert the CPU on the expansion. I personally upgraded to a 68010 to gain the quit key ability with WHDLoad
- Plug the expansion in the motherboard. Take care of Pin 1. Push it so it does not pop out of the socket during use, but do not break the CPU socket.
- Connect INT2 and OVR headers to the motherboard
- Turn on the Amiga

