# IDE-RAM-A500
This is a 2MB autoconfig Fast SRAM and IDE port expansion for Amiga 500 and plus. I believe the two things that the A500 lacks the most are probably a hard drive, and Fast RAM.

Using the provided Amiga software, it can be turned into a 1.5MB (fast) RAM in ranger space (C00000-D7FFFF) together with 512KB MapROM. This mode is targeted for owners of plus or expanded rev8a who want to play old picky games from floppies.

Facts about this project :
- It sits under the CPU : does not block access to the ROM and does not need a relocator.
- I wanted a mini-IDE port, this is the main reason why I started to create my own board.
- I thought that it would be neat to have some Fast RAM on the same 2-layers PCB, and I had a great SRAM chip for another project, PCMCIA-SRAM.
- The IDE port simulates the one from the A600 so it is bootable with appropriate Kickstarts. Like other IDE expansions, it requires two additional signals from the motherboard : INT2 and OVR.
- By default, the RAM stuff takes the place of the first expansion in the autoconfig chain. To use other autoconfig expansions, you need to configure the firmware with config_in/out pins to put it in your autoconfig chain ; these pins take the place of the secondary LED.

# Acknowledgements
Thanks Guys :
- mkl from http://www.mkl211015.altervista.org has created both IDE and RAM expansions, ide68k and ram68k, that sit under the 68000, and can be stacked. I thank him for publishing his schematic and code since it inspired this project, and the base of the IDE CPLD code is a verilog conversion I made from his abel of version 425.
- Sector101 shared an interesting experiment that proved it is somewhat simple to use SRAM as fast memory, and encouraged me to try adding it to this project : https://blog.sector101.co.uk/2019/07/20/amiga-500-2mb-handwired-fastram-expansion/ .
- Sukkopera shared the OpenAmiga500FastRamExpansion from which I used the autoconfig CPLD code in earlier versions : https://github.com/SukkoPera/OpenAmiga500FastRamExpansion/
- the MapROM software in this project is based on the one shared by Paul RASPA (PR77) https://github.com/PR77/A600_ACCEL_RAM/tree/master/Software . This is the first C code I ever compiled for my Amiga, so I believe the MapROM function would not have been possible without this working starting point !

# Disclaimer
This is a hobbyist project, it comes with no warranty and no support. Also remember that the Amiga machines are about 30 years old and may fail because of such hardware expansions.

This version is not connected to mkl211015, please don't bother him with issues you might have because of it.

I publish my work under the CC-BY-NC-SA license.

If you find it useful and want to reward my hard work : I am always looking for Amiga/Amstrad CPC hardware to repair and hack, please contact me.

# BOM
- 1x XC95144XL CPLD
- 1x CY62167ELL-45ZXI 5V SRAM (do not use 3.3V CY62167EV !). For 4MB you may also, with small changes in the CPLD code (addressing and autoconfig) :
 - stack a second chip on the first one and connect its pin 12 to the pad nearby -god skills required-,
 - use a CY62177ESL-55ZXI 5V SRAM instead (rare, expensive, not tested).
- 1x 3.3v LDO, either SPX3819M5-L-3-3 or XC6206P332MR
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

CPLD code is generated and built into xsvf using Xilinx ISE 14.7 IDE then iMPACT. There are configuration defines for RAM type and LED/config_pins selection, choose the ones you need. The "Process Properties" of the Fitting step are tweaked :
- -slew = Slow
- -power = Low
- -nogclkopt = Checked (by default)
- -nogsropt = Checked (by default)
- -unused = NOT Checked (by default), since pin 4 is used as pass-through

There are several methods to program the XC95144XL. I personally use xsvfduino : https://github.com/wschutzer/xsvfduino. I advise you program it when unplugged from the motherboard, or by powering it from the motherboard ; otherwise your programmer might burn trying to power the whole system.

# Using it
- Remove the 68000 CPU from the motherboard
- Insert the CPU on the expansion. I personally upgraded to a 68010 to gain the quit key ability with WHDLoad
- Plug the expansion in the motherboard. Take care of Pin 1. Push it firmly so it does not pop out of the socket during use, but do not break the CPU socket.
- Connect INT2 and OVR headers to the motherboard
- Turn on the Amiga

# Amiga Software
You may use the the provided MapROM software that writes the ROM image to F80000-FFFFFF.
This expansion uses a control register byte at $00E9Cxxx to be configured by the software :
- bit 7 indicates if mapROM is active, write 0 to disable it at next reboot ;
- bit 6 is active ram mode, 0 for fast autoconfig and 1 for ranger maprom ; write it to change mode at next reboot.

To activate Ranger RAM with MapROM and reboot immediately to take effect :
```
MapROM -1 -r
```

To map the internal ROM (might speed up the system) :
```
MapROM -i
```
or a different ROM from file, 256K and 512K are supported :
```
MapROM -f Files:path/kickstart-image-not-swapped-nor-split.rom
```

You can disable MapROM :
```
MapROM -x
```

And revert to the full autoconfig RAM (take effect at next reboot) :
```
MapROM -0
```

To use the MapROM function more extensively, you may compile the firmware to provide MapROM by default, then add the following line to your startup-sequence. The -r flag tells it to reboot the system after successful flash, then at next reboot the program will just exit since MapROM is already activated and your system will finish to boot with the new ROM :
```
MapROM -f Files:path/kickstart-image-not-swapped-nor-split.rom -r
```


