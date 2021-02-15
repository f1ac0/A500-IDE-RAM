CC=vc
#CC=vc +kick13
#CC=vc +aos68k
CFLAGS=-I$(NDK_INC) -DNDEBUG

all: mapROM mapROM13

mapROM: mapROM.c Helpers.c
	$(CC) +aos68k $(CFLAGS) $^ -lamiga -o mapROM

mapROM13: mapROM.c Helpers.c coldboot.o
	$(CC) +kick13 $(CFLAGS) $^ -lamiga -o mapROM13

coldboot.o: coldboot.asm
	vasmm68k_mot -Fhunk -I$(NDK_INCI) $^ -o coldboot.o

clean:
	rm coldboot.o mapROM mapROM13
