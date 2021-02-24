#include <clib/dos_protos.h>
#include <clib/exec_protos.h>

#include <proto/dos.h>
#include <exec/resident.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Helpers.h"

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

#define LOOP_TIMEOUT        (ULONG)10000
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

int main(int argc, char **argv);

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

    S_PRINT("\nTool for IDE-RAM-A500/A1200FaStRamExpansion v2.0 2021.02.24\n");
    S_PRINT("Based on MapROM by Paul Raspa (PR77) for A600_ACCEL_RAM\n");

    /* Check if application has been started with correct parameters */
    if (argc <= 1)
    {
        S_PRINT("usage: %s <option> [<filename>]\n",argv[0]);
        S_PRINT(" -i\tmap Internal ROM\n");
        S_PRINT(" -f\tmap External ROM <filename>\n");
        S_PRINT(" -t\ttest if MapRom is active\n");
        S_PRINT(" -v\tversion of current ROM\n");
        S_PRINT(" -x\tunmap ROM\n");
        S_PRINT(" -0\tFast autoconfig mode (IDE-RAM-A500)\n");
        S_PRINT(" -1\tRanger MapROM mode (IDE-RAM-A500)\n");
        S_PRINT(" -4\tforce 4MB mode (A1200FaStRamExpansion)\n");
        S_PRINT(" -8\treset 8MB mode (A1200FaStRamExpansion)\n");
        S_PRINT(" -m\tadd Ranger Mem (A1200FaStRamExpansion)\n");
        S_PRINT(" -r\tsystem reboot\n");
        exit(RETURN_WARN);
    }
        
    while (argc > 1)
    {
        if(argv[1][0] == '-') switch (argv[1][1])
        {
            case 'm':
            case 'M':
            {
                if(!TypeOfMem(0x00C01000)) { //test if already present in pool
                    AddMemList((1024+512)*1024, MEMF_FAST|MEMF_PUBLIC, -5, 0x00C00000, "ranger memory"); //size, attributes, pri, base, name);
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
                    exit(RETURN_FAIL);
                }

                printf("\nFound Resident ROMTAG:\n");
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
                    exit(RETURN_WARN);
                }
            }
            break;

            case 't':
            case 'T':
            {
                if( !((*controlAddress) & 0x40) ) {
                    S_PRINT("MapROM is not available\n");
                    exit(RETURN_ERROR);
                } else if( (*controlAddress) & 0x80 ) {
                    S_PRINT("MapROM is ACTIVE\n");
                    exit(RETURN_WARN);
                } else
                    S_PRINT("MapROM is NOT active\n");
            }
            break;

            case 'i':
            case 'I':
            {
                if( ((*controlAddress) & 0xC0) != 0x40 ) {
                    S_PRINT("MapROM is already active or not available\n");
                    exit(RETURN_ERROR);
                }

                APTR sourceAddress, destinationAddress;
                ULONG writeWordCounter = 0;
                UBYTE progressIndicator = 0;
                
                sourceAddress = (ULONG)0x00F80000;
                destinationAddress = (ULONG)0x00F80000;
                
                S_PRINT("Writing MapROM ... SRC: 0x%X, DEST: 0x%X\n\n", sourceAddress, destinationAddress);
                
                do {
                    ((UWORD *)destinationAddress)[writeWordCounter] = ((UWORD *)sourceAddress)[writeWordCounter];
                    writeWordCounter++;
                    
#ifndef SILENT
                    if ((writeWordCounter % 4096) == 0)
                    {
                        progressIndicator++;
                        printProgress(progressIndicator, 64);
                    }
#endif

                } while (writeWordCounter < (KICKSTART_512K / 2));
                
                S_PRINT("Done, MapROM will be active at next reboot\n");
            }
            break;
            
            case 'f':
            case 'F':
            {
                if( ((*controlAddress) & 0xC0) != 0x40 ) {
                    S_PRINT("MapROM is already active or not available\n");
                    exit(RETURN_ERROR);
                }

                if ((argc > 2) && argv[2])
                {
                    APTR pBuffer;
                    ULONG fileSize;
                    
                    tReadFileHandler readFileProgram = getFileSize(argv[2], &fileSize);
                    
                    if (readFileOK == readFileProgram)
                    {
                        if (fileSize == KICKSTART_512K || fileSize == KICKSTART_256K)
                        {
                            readFileProgram = readFileIntoMemoryHandler(argv[2], fileSize, &pBuffer);
                            
                            if (readFileOK == readFileProgram)
                            {
                                APTR destinationAddress;
                                ULONG writeWordCounter = 0;
                                UBYTE progressIndicator = 0;

                                destinationAddress = (ULONG)0x00F80000;

                                S_PRINT("Writing MapROM ... SRC: %s, DEST: 0x%X\n\n", argv[2], destinationAddress);

                                do {
                                    ((UWORD *)destinationAddress)[writeWordCounter] = ((UWORD *)pBuffer)[writeWordCounter];
                                    if(fileSize == KICKSTART_256K)
                                        ((UWORD *)destinationAddress)[writeWordCounter+(KICKSTART_256K/2)] = ((UWORD *)pBuffer)[writeWordCounter];

                                    writeWordCounter++;

#ifndef SILENT
                                    if ((writeWordCounter % 4096) == 0)
                                    {
                                        progressIndicator++;
                                        printProgress(progressIndicator, 64);
                                    }
#endif

                                } while (writeWordCounter < (fileSize / 2));   

                                S_PRINT("Done, MapROM will be active at next reboot\n");
                                freeFileHandler(fileSize);                            
                            }
                            else if (readFileNoMemoryAllocated == readFileProgram)
                            {
                                S_PRINT("Failed to allocate %ld memory for file: %s\n", fileSize, argv[2]);
                                exit(RETURN_FAIL);
                            }
                            else if (readFileGeneralError == readFileProgram)
                            {
                                S_PRINT("Failed to read file: %s\n", argv[2]);    
                                exit(RETURN_FAIL);
                            }
                            else
                            {
                                S_PRINT("Unhandled error in readFileIntoMemoryHandler()\n");    
                                exit(RETURN_FAIL);
                            }
                        }
                        else
                        {
                            S_PRINT("Unsupported Kickstart size %ld. Expecting 256/512KB images\n", fileSize);
                            freeFileHandler(fileSize);                            
                            exit(RETURN_FAIL);
                        }

                    }
                    else if (readFileNotFound == readFileProgram)
                    {
                        S_PRINT("Failed to find file: %s\n", argv[2]);
                        exit(RETURN_FAIL);
                    }
                    else
                    {
                        S_PRINT("Unable to determine size of file: %s\n", argv[2]);
                        exit(RETURN_FAIL);
                    }
                }
                else
                {
                    S_PRINT("No Kickstart image specified\n");
                    exit(RETURN_FAIL);
                }
            }
            break;
        }
        
        ++argv;
        --argc;
    }
}
