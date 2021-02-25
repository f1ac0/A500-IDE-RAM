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
#define KICKSTART_256K      (ULONG)(256 * 1024)
#define KICKSTART_512K      (ULONG)(512 * 1024)

/*****************************************************************************/
/* Types *********************************************************************/
/*****************************************************************************/

/*****************************************************************************/
/* Globals *******************************************************************/
/*****************************************************************************/

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
    struct FileInfoBlock myFIB;
    BPTR fileHandle = 0L;
    BYTE *controlAddress = (BYTE *)0x00E9C000;

    /* Check if application has been started with correct parameters */
    if (argc <= 1)
    {
        printf("\nTool for IDE-RAM-A500/A1200FaStRamExpansion v1.0 2021.02.25\n");
        printf("usage: %s <option> [<filename>]\n",argv[0]);
        printf(" -i\tmap Internal ROM\n");
        printf(" -f\tmap External ROM <filename>\n");
        printf(" -t\ttest if MapRom is active\n");
        printf(" -v\tversion of current ROM\n");
        printf(" -x\tunmap ROM\n");
        printf(" -0\tFast autoconfig mode (IDE-RAM-A500)\n");
        printf(" -1\tRanger MapROM mode (IDE-RAM-A500)\n");
        printf(" -4\tforce 4MB mode (A1200FaStRamExpansion)\n");
        printf(" -8\treset 8MB mode (A1200FaStRamExpansion)\n");
        printf(" -m\tadd Ranger Mem (A1200FaStRamExpansion)\n");
        printf(" -r\tsystem reboot\n");
        return(RETURN_WARN);
    }
        
    while (argc > 1)
    {
        if(argv[1][0] == '-') switch (argv[1][1])
        {
            case 'm':
            case 'M':
            {
                if(!TypeOfMem((UWORD *)0x00C01000)) { //test if already present in pool
                    AddMemList((1024+512)*1024, MEMF_FAST|MEMF_PUBLIC, -5, (UWORD *)0x00C00000, "ranger memory"); //size, attributes, pri, base, name);
                    S_PRINT("Ranger Mem added\n");
                }
            }
            break;

            case '0':
            {
                *controlAddress=0x80; //preserve maprom if set
                S_PRINT("Fast autoconfig will be configured at next reboot\n");
            }
            break;

            case '1':
            {
                *controlAddress=0xC0; //preserve maprom if set
                S_PRINT("Ranger MapROM will be configured at next reboot\n");
            }
            break;

            case '4':
            {
                *controlAddress=0xA0; //preserve maprom if set
                S_PRINT("4MB will be forced at next reboot\n");
            }
            break;

            case '8':
            {
                *controlAddress=0x80; //preserve maprom if set
                S_PRINT("8MB will be available at next reboot\n");
            }
            break;

            case 'v':
            case 'V':
            {
                struct Resident *myResident;
                myResident = FindResident("exec.library");
                if (!myResident)
                {
                    printf("exec.library not found, is this even an Amiga?!?\n");
                    return(RETURN_FAIL);
                }
                printf("Found Resident ROMTAG:\n");
                printf("Name: %s\n", myResident->rt_Name);
                printf("ID String: %s\n", myResident->rt_IdString);
            }
            break;

            case 'r':
            case 'R':
            {
                ColdReboot();
            }
            break;

            case 'x':
            case 'X':
            {
                if( (*controlAddress) & 0x80 ) {
                    *controlAddress=(*controlAddress) & 0x40; //preserve actual mode
                    S_PRINT("MapROM will be removed at next reboot\n");
                } else {
                    S_PRINT("MapROM is already NOT active\n");
                    return(RETURN_WARN);
                }
            }
            break;

            case 't':
            case 'T':
            {
                if( !((*controlAddress) & 0x40) ) {
                    S_PRINT("MapROM is not available\n");
                    return(RETURN_ERROR);
                } else if( (*controlAddress) & 0x80 ) {
                    S_PRINT("MapROM is ACTIVE\n");
                    return(RETURN_WARN);
                } else
                    S_PRINT("MapROM is NOT active\n");
            }
            break;

            case 'i':
            case 'I':
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
                    }
#endif
                } while (writeWordCounter < (KICKSTART_512K / 2));
                
                S_PRINT("\nDone, MapROM will be active at next reboot\n");
            }
            break;
            
            case 'f':
            case 'F':
            {
                if( ((*controlAddress) & 0xC0) != 0x40 ) {
                    S_PRINT("MapROM is already active or not available\n");
                    return(RETURN_ERROR);
                }
                int result = RETURN_ERROR;

                if ((argc > 2) && argv[2])
                {
                    char *fileName = argv[2];
                    ULONG fileSize;
                    static BPTR fileHandle;
                    static APTR memoryHandle;
                    struct FileInfoBlock FIB;

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
                    return(result);
                }
            }
            break;
        }
        
        ++argv;
        --argc;
    }
}
