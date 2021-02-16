CC=vc
#CC=vc +kick13
#CC=vc +aos68k
CFLAGS=-I$(NDK_INC) -DNDEBUG

all: MapROM MapROM13

MapROM: mapROM.c Helpers.c
	$(CC) +aos68k $(CFLAGS) $^ -lamiga -o MapROM

MapROM13: mapROM.c Helpers.c coldboot.o
	$(CC) +kick13 $(CFLAGS) $^ -lamiga -o MapROM13

coldboot.o: coldboot.asm
	vasmm68k_mot -Fhunk -I$(NDK_INCI) $^ -o coldboot.o

clean:
	rm coldboot.o MapROM MapROM13
