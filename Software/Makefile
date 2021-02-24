CC=vc
CFLAGS=-I$(NDK_INC) -DNDEBUG

all: FLACOntrol FLACOntrol13 FLACOntrols

FLACOntrol: FLACOntrol.c Helpers.c
	$(CC) +aos68k $(CFLAGS) $^ -lamiga -o FLACOntrol

FLACOntrol13: FLACOntrol.c Helpers.c coldboot.asm
	$(CC) +kick13 $(CFLAGS) $^ -lamiga -o FLACOntrol13

FLACOntrols: FLACOntrol.c Helpers.c
	$(CC) +aos68k $(CFLAGS) -DSILENT $^ -lamiga -o FLACOntrols

clean:
	rm FLACOntrol FLACOntrol13 FLACOntrols
