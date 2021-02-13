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

    printf("\nMapROM tool for A600_ACCEL_RAM - IDE-RAM-A500 - A1200FaStRamExpansion\n");
    printf("Developed by Paul Raspa (PR77), Updated by FLACO, Rev 2.0 2021.02.11\n");

    /* Check if application has been started with correct parameters */
    if (argc <= 1)
    {
        printf("usage: MapROM <option> [<filename>]\n");
        printf(" -i\tmap Internal ROM\n");
        printf(" -f\tmap External ROM <filename>\n");
        printf(" -t\ttest if active\n");
        printf(" -v\tversion of current ROM\n");
        printf(" -x\tunmap ROM\n");
        printf(" -r\tsystem reboot\n");
        exit(RETURN_FAIL);
    }
        
    while ((argc > 1) && (argv[1][0] == '-'))
    {
        switch (argv[1][1])
        {
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
/*
__asm(" \n\
\tcnop 0,4\n\
\tlea 2.l,a0\n\
\treset\n\
\tjmp (a0)\n\
")
*/
            }
            break;

            case 'x':
            case 'X':
            {
                if( (*controlAddress) & 0x80 ) {
                    *controlAddress=0;
                    printf("Done, MapROM will be removed at next reboot\n");
                } else {
                    printf("MapROM is already NOT active\n");
                    exit(RETURN_FAIL);
                }
            }
            break;

            case 't':
            case 'T':
            {
                if( (*controlAddress) & 0x80 ) {
                    printf("MapROM is ACTIVE\n");
                    exit(RETURN_FAIL);
                } else
                    printf("MapROM is NOT active\n");
            }
            break;

            case 'i':
            case 'I':
            {
                if( (*controlAddress) & 0x80 ) {
                    printf("MapROM is already active\n");
                    exit(RETURN_FAIL);
                }

                APTR sourceAddress, destinationAddress;
                ULONG writeWordCounter = 0;
                UBYTE progressIndicator = 0;
                
                sourceAddress = (ULONG)0x00F80000;
                destinationAddress = (ULONG)0x00F80000;
                
                printf("Writing MapROM ... SRC: 0x%X, DEST: 0x%X\n\n", sourceAddress, destinationAddress);
                
                do {
                    ((UWORD *)destinationAddress)[writeWordCounter] = ((UWORD *)sourceAddress)[writeWordCounter];
                    writeWordCounter++;
                    
                    if ((writeWordCounter % 4096) == 0)
                    {
                        progressIndicator++;
                        printProgress(progressIndicator, 64);
                    }

                } while (writeWordCounter < (KICKSTART_512K / 2));
                
                printf("Done, MapROM will be active at next reboot\n");
            }
            break;
            
            case 'f':
            case 'F':
            {
                if( (*controlAddress) & 0x80 ) {
                    printf("MapROM is already active\n");
                    exit(RETURN_FAIL);
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

                                printf("Writing MapROM ... SRC: %s, DEST: 0x%X\n\n", argv[2], destinationAddress);

                                do {
                                    ((UWORD *)destinationAddress)[writeWordCounter] = ((UWORD *)pBuffer)[writeWordCounter];
                                    if(fileSize == KICKSTART_256K)
                                        ((UWORD *)destinationAddress)[writeWordCounter+(KICKSTART_256K/2)] = ((UWORD *)pBuffer)[writeWordCounter];

                                    writeWordCounter++;

                                    if ((writeWordCounter % 4096) == 0)
                                    {
                                        progressIndicator++;
                                        printProgress(progressIndicator, 64);
                                    }

                                } while (writeWordCounter < (fileSize / 2));   

                                printf("Done, MapROM will be active at next reboot\n");
                                freeFileHandler(fileSize);                            
                            }
                            else if (readFileNoMemoryAllocated == readFileProgram)
                            {
                                printf("Failed to allocate %ld memory for file: %s\n", fileSize, argv[2]);
                                exit(RETURN_FAIL);
                            }
                            else if (readFileGeneralError == readFileProgram)
                            {
                                printf("Failed to read file: %s\n", argv[2]);    
                                exit(RETURN_FAIL);
                            }
                            else
                            {
                                printf("Unhandled error in readFileIntoMemoryHandler()\n");    
                                exit(RETURN_FAIL);
                            }
                        }
                        else
                        {
                            printf("Unsupported Kickstart size %ld. Expecting 256/512KB images\n", fileSize);
                            freeFileHandler(fileSize);                            
                            exit(RETURN_FAIL);
                        }

                    }
                    else if (readFileNotFound == readFileProgram)
                    {
                        printf("Failed to find file: %s\n", argv[2]);
                        exit(RETURN_FAIL);
                    }
                    else
                    {
                        printf("Unable to determine size of file: %s\n", argv[2]);
                        exit(RETURN_FAIL);
                    }
                }
                else
                {
                    printf("No Kickstart image specified\n");
                    exit(RETURN_FAIL);
                }
            }
            break;
        }
        
        ++argv;
        --argc;
    }
}
