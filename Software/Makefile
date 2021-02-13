#CC=vc +kick13
CC=vc +aos68k
CFLAGS=-I$(NDK_INC) -DNDEBUG

all: mapROM

mapROM: mapROM.c Helpers.c

	$(CC) $(CFLAGS) $^ -lamiga -o mapROM

