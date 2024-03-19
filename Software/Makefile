CC=vc
CFLAGS=-I$(NDK_INC)

all: modern purist
modern: FLACOntrol FLACOntrol13 FLACOntrol_silent
purist: FLACOntrol_purist FLACOntrol_purist_silent

FLACOntrol: FLACOntrol.c
	$(CC) +aos68k $(CFLAGS) $^ -lamiga -o FLACOntrol

FLACOntrol13: FLACOntrol.c coldboot.asm
	$(CC) +kick13 $(CFLAGS) $^ -lamiga -o FLACOntrol13

FLACOntrol_silent: FLACOntrol.c
	$(CC) +aos68k $(CFLAGS) -DSILENT $^ -lamiga -o FLACOntrol_silent

FLACOntrol_purist: FLACOntrol_purist.c
	$(CC) +aos68k $(CFLAGS) $^ -lamiga -o FLACOntrol_purist

FLACOntrol_purist_silent: FLACOntrol_purist.c
	$(CC) +aos68k $(CFLAGS) -DSILENT $^ -lamiga -o FLACOntrol_purist_silent

clean:
	rm -f FLACOntrol FLACOntrol13 FLACOntrol_silent FLACOntrol_purist FLACOntrol_purist_silent

