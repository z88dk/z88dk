/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: pulsewavesid.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* set pulse waveform width */

void pulsewavesid(ushort Voice, ushort Width)
{
  outp(Voice+2,(uchar) Width);
  outp(Voice+3,(uchar) (Width >> 8));
}

