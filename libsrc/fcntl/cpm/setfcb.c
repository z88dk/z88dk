/*
 *  Set the FCB parameters to the supplied name pt 1
 *
 *  27/1/2002 - djm
 *
 *  $Id: setfcb.c,v 1.3 2013-06-06 08:58:32 stefano Exp $
 */


#include <cpm.h>
#include <ctype.h>

#ifdef DEVICES
#include <string.h>
#define NUM_DEVNAMES 4
#define DEVNAME_LEN  4
static char devnames[] = "CON:RDR:PUN:LST:";
#endif

int setfcb( struct fcb *fc, unsigned char *name)
{
#ifdef DEVICES
    int  i,j;

    while ( isspace(*name))   /* Skip over any initial space */
	name++;

    /* Check for devices */
    for ( i = 0; i < NUM_DEVNAMES; i++ ) {
		if ( !strnicmp(name, devnames + (i * NUM_DEVNAMES ), DEVNAME_LEN) ) {
			fc->use = i + U_CON;
			return 1;
		}
    }
#endif
    parsefcb(fc,name);
    return 0;
}

