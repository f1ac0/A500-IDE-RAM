#include <proto/dos.h>
#include <proto/exec.h>
#include <exec/resident.h>
#include <stdio.h>
#include <string.h>

/*****************************************************************************/
/* Macros ********************************************************************/
/*****************************************************************************/
#ifndef SILENT
   #define S_PRINT(...) printf(__VA_ARGS__)
#else
   #define S_PRINT(...) 
#endif

/*****************************************************************************/
/* Defines *******************************************************************/
/*****************************************************************************/
#define OPT_TEMPLATE   "I=InternalMapROM/S,F=FileMapROM/K,T=TestMapROM/S,V=ROMVersion/S,X=unMapROM/S,0=AutoconfMode/S,1=RangerMode/S,4=4MB/S,8=8MB/S,M=AddRangerMem/S,R=Reboot/S,H=Help/S"
#define OPT_InternalMapROM 0
#define OPT_FileMapROM  1
#define OPT_TestMapROM   2
#define OPT_ROMVersion  3
#define OPT_unMapROM  4
#define OPT_AutoconfMode  5
#define OPT_RangerMode  6
#define OPT_4MB  7
#define OPT_8MB  8
#define OPT_AddRangerMem  9
#define OPT_Reboot  10
#define OPT_Help  11
#define OPT_COUNT  12

#define KICKSTART_256K      (ULONG)(256 * 1024)
#define KICKSTART_512K      (ULONG)(512 * 1024)

/*****************************************************************************/
/* Types *********************************************************************/
/*****************************************************************************/

/*****************************************************************************/
/* Globals *******************************************************************/
/*****************************************************************************/
LONG result[OPT_COUNT];

/*****************************************************************************/
/* Prototypes ****************************************************************/
/*****************************************************************************/

/*****************************************************************************/
/* Local Code ****************************************************************/
/*****************************************************************************/

/*****************************************************************************/
/* Main Code *****************************************************************/
/*****************************************************************************/
int main(int argc, char **argv)
{
    struct RDArgs *rd;
    struct FileInfoBlock myFIB;
    BPTR fileHandle = 0L;
    BYTE *controlAddress = (BYTE *)0x00E9C000;

    if (rd=ReadArgs(OPT_TEMPLATE, result, NULL))
    {
        if (result[OPT_InternalMapROM])
        {
            if( ((*controlAddress) & 0xC0) != 0x40 ) {
                S_PRINT("MapROM is already active or not available\n");
                return(RETURN_ERROR);
            }
            UWORD *sourceAddress = (UWORD *)0x00F80000;
            UWORD *destinationAddress = (UWORD *)0x00F80000;
            ULONG writeWordCounter = 0;            
#ifndef SILENT
            S_PRINT("Writing MapROM... SRC: $%lX, DEST: $%lX\n", (ULONG)sourceAddress, (ULONG)destinationAddress);
            S_PRINT("[%*s]\r[",64,""); //progress bar with 64 steps
            fflush(stdout); //print progress immediately
#endif
            do {
                destinationAddress[writeWordCounter] = sourceAddress[writeWordCounter];
                writeWordCounter++;
#ifndef SILENT
                if ((writeWordCounter % 4096) == 0)
                {
                    printf("#");
                    fflush(stdout);
//                    Delay(5);
                }
#endif
            } while (writeWordCounter < (KICKSTART_512K / 2));
            S_PRINT("\nDone, MapROM will be active at next reboot\n");
        }

        if (result[OPT_FileMapROM])
        {
            if( ((*controlAddress) & 0xC0) != 0x40 ) {
                S_PRINT("MapROM is already active or not available\n");
                FreeArgs(rd);
                return(RETURN_ERROR);
            }
            char *fileName = (UBYTE *) result[OPT_FileMapROM];
            ULONG fileSize;
            static BPTR fileHandle;
            static APTR memoryHandle;
            struct FileInfoBlock FIB;
            int result = RETURN_ERROR;

            if (0L != fileName)
            {
                fileHandle = Lock(fileName, MODE_OLDFILE);
                if (0L != fileHandle)
                {
                    Examine(fileHandle, &FIB);
                    UnLock(fileHandle);
                    fileSize = (ULONG)FIB.fib_Size;
                    if (fileSize == KICKSTART_512K || fileSize == KICKSTART_256K)
                    {
                        fileHandle = Open(fileName, MODE_OLDFILE);
                        if (0L != fileHandle)
                        {
                            memoryHandle = AllocMem(fileSize, 0);
                            if (memoryHandle)
                            {
                                if (fileSize == (ULONG)Read(fileHandle, memoryHandle, fileSize))
                                {
                                    UWORD *destinationAddress = (UWORD *)0x00F80000;
                                    ULONG writeWordCounter = 0;
#ifndef SILENT
                                    S_PRINT("Writing MapROM... SRC: %s, DEST: $%lX\n", fileName, (ULONG)destinationAddress);
                                    S_PRINT("[%*s]\r[",(UWORD)(fileSize>>13),""); //progress bar with 64 or 32 steps
                                    fflush(stdout); //print progress immediately
#endif
                                    do {
                                        destinationAddress[writeWordCounter] = ((UWORD *)memoryHandle)[writeWordCounter];
                                        if(fileSize == KICKSTART_256K)
                                            destinationAddress[writeWordCounter+(KICKSTART_256K/2)] = ((UWORD *)memoryHandle)[writeWordCounter];
                                        writeWordCounter++;
#ifndef SILENT
                                        if ((writeWordCounter % 4096) == 0)
                                        {
                                            printf("#");
                                            fflush(stdout);
                                        }
#endif
                                    } while (writeWordCounter < (fileSize / 2));   
                                    S_PRINT("\nDone, MapROM will be active at next reboot\n");
                                    result = RETURN_OK;
                                }else{
                                    S_PRINT("Failed to read file: %s\n", fileName);
                                }
                                FreeMem(memoryHandle, fileSize);
                            }else{
                                S_PRINT("Failed to allocate %lu memory for file: %s\n", fileSize, fileName);
                            }
                            Close(fileHandle);
                        }else{
                            S_PRINT("Failed to open file: %s\n", fileName);
                        }
                    }else{
                        S_PRINT("Unsupported Kickstart size %lu. Expecting 256/512KB images\n", fileSize);
                    }
                }else{
                    S_PRINT("Unable to determine size of file: %s\n", fileName);
                }
            }else{
                S_PRINT("Incorrect file name\n");
            }
            if(result){
                FreeArgs(rd);
                return(result);
            }
        }

        if (result[OPT_TestMapROM])
        {
            if( !((*controlAddress) & 0x40) ) {
                S_PRINT("MapROM is not available\n");
                FreeArgs(rd);
                return(RETURN_ERROR);
            } else if( (*controlAddress) & 0x80 ) {
                S_PRINT("MapROM is ACTIVE\n");
                FreeArgs(rd);
                return(RETURN_WARN);
            } else
                S_PRINT("MapROM is NOT active\n");
        }

        if (result[OPT_ROMVersion])
        {
            struct Resident *myResident;
            myResident = FindResident("exec.library");

            if (!myResident)
            {
                printf("exec.library not found, is this even an Amiga?!?\n");
                FreeArgs(rd);
                return(RETURN_FAIL);
            }
            printf("Found Resident ROMTAG:\n");
            printf("Name: %s\n", myResident->rt_Name);
            printf("ID String: %s\n", myResident->rt_IdString);
        }

        if (result[OPT_unMapROM])
        {
            if( (*controlAddress) & 0x80 ) {
                *controlAddress=(*controlAddress) & 0x40; //preserve actual mode
                S_PRINT("MapROM will be removed at next reboot\n");
            } else {
                S_PRINT("MapROM is already NOT active\n");
                FreeArgs(rd);
                return(RETURN_WARN);
            }
        }

        if (result[OPT_AutoconfMode])
        {
            *controlAddress=0x80; //preserve maprom if set
            S_PRINT("Fast autoconfig will be configured at next reboot\n");
        }

        if (result[OPT_RangerMode])
        {
            *controlAddress=0xC0; //preserve maprom if set
            S_PRINT("Ranger MapROM will be configured at next reboot\n");
        }

        if (result[OPT_4MB])
        {
            *controlAddress=0xA0; //preserve maprom if set
            S_PRINT("4MB will be forced at next reboot\n");
        }

        if (result[OPT_8MB])
        {
            *controlAddress=0x80; //preserve maprom if set
            S_PRINT("8MB will be available at next reboot\n");
        }

        if (result[OPT_AddRangerMem])
        {
            if(!TypeOfMem((UWORD *)0x00C01000)) { //test if already present in pool
                AddMemList((1024+512)*1024, MEMF_FAST|MEMF_PUBLIC, -5, (UWORD *)0x00C00000, "ranger memory"); //size, attributes, pri, base, name);
                S_PRINT("Ranger Mem added\n");
            }
        }

        if (result[OPT_Reboot])
        {
            ColdReboot();
        }

        if (result[OPT_Help])
        {
            printf("Tool for A500-IDE-RAM/A1200FaStRamExpansion v1.0 2021.02.25\n");
            printf("usage: FLACOntrol <options> [<filename>]\n");
            printf("\tI map Internal ROM\n");
            printf("\tF map External ROM <filename>\n");
            printf("\tT test if MapRom is active\n");
            printf("\tV version of current ROM\n");
            printf("\tX unmap ROM\n");
            printf("\t0 Fast autoconfig mode (A500-IDE-RAM)\n");
            printf("\t1 Ranger MapROM mode (A500-IDE-RAM)\n");
            printf("\t4 force 4MB mode (A1200FaStRamExpansion)\n");
            printf("\t8 reset 8MB mode (A1200FaStRamExpansion)\n");
            printf("\tM add Ranger Mem (A1200FaStRamExpansion)\n");
            printf("\tR system reboot\n");
            printf("\tH this help\n");
        }
        FreeArgs(rd);
    } else {
        printf("incorrect argument\n");
        return(RETURN_FAIL);
    }

    return 0;
}
