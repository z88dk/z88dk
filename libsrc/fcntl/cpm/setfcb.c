/*
 *  Set the FCB parameters to the supplied name pt 1
 *
 *  27/1/2002 - djm
 *
 *  $Id: setfcb.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */


#include <cpm.h>
#include <ctype.h>

#define NUM_DEVNAMES 4
#define DEVNAME_LEN  4
static char devnames[] = "CON:RDR:PUN:LST:";

int setfcb( struct fcb *fc, unsigned char *name)
{
    int  i,j;

    while ( isspace(*name))   /* Skip over any initial space */
	name++;
#ifdef DEVICES
    /* Check for devices */
    for ( i = 0; i < NUM_DEVNAMES; i++ ) {
	if ( strnicmp(name,devnames + (i * NUM_DEVNAMES ),DEVNAME_LEN) ) {
	    fc->use = i + U_CON;
	    return 1;
	}
    }
#endif
    parsefcb(fc,name);
    return 0;
}

    
