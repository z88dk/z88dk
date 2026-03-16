/*
 *  Set the FCB parameters to the supplied name pt 1
 *
 *  27/1/2002 - djm
 *  HDOS version: Stefano, 2026
 *
 *  $Id: setfcb.c $
 */


#include <arch/hdos.h>
#include <ctype.h>

// #ifdef DEVICES
// #include <string.h>
// #define NUM_DEVNAMES 2
// #define DEVNAME_LEN  3
// static char devnames[] = "LP:MT:";    // Line Printer, Magnetic Tape
// #endif

int setfcb( struct fcb *fc, char *name)
{
// #ifdef DEVICES
//     int  i,j;
// 
//     while ( isspace(*name))   /* Skip over any initial space */
//     name++;
// 
//     /* Check for devices */
//     for ( i = 0; i < NUM_DEVNAMES; i++ ) {
//         if ( strnicmp(name, devnames + (i * NUM_DEVNAMES ), DEVNAME_LEN) == 0 ) {
//             fc->use = i + U_CON;
//             return 1;
//         }
//     }
// #endif
    parsefcb(fc,name);
    return 0;
}

