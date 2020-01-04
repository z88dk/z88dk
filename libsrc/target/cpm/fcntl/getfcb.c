/*
 *  Get a free File Control Block
 *
 *  27/1/2002 - djm
 *
 *  $Id: getfcb.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */


#include <cpm.h>
#include <stdio.h>




struct fcb *getfcb(void)
{
    struct fcb  *fcb;

    for ( fcb = _fcb ; fcb < &_fcb[MAXFILE]; fcb++ ) {
	if ( fcb->use == 0 ) {
	    fcb->use   = U_READ;
	    fcb->rwptr = 0;
	    return fcb;
	}
    }
    return NULL;
}
