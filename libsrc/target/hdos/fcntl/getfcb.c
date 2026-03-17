/*
 *  Get a free File Control Block
 *
 *  Stefano, 2026
 *
 *  $Id: getfcb.c $
 */


#include <arch/hdos.h>
#include <stdio.h>


struct fcb *getfcb(void)
{
    struct fcb  *fcb;
	int    channel=0;

    for ( fcb = _fcb ; fcb < &_fcb[MAXFILE]; fcb++ ) {
        if ( fcb->use == 0 ) {
            fcb->use   = U_READ;
            fcb->rwptr = 0;
            fcb->cached_record = 0xffffffff;
            fcb->rnr_dirty = 0;
            fcb->ch = channel;
            return fcb;
        }
		channel++;
    }
    return NULL;
}
