/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: freqsid.c,v 1.1 2008-06-23 17:34:33 stefano Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* set voice freq */

void freqsid(ushort Voice, ushort Freq)
{
  outp(Voice,(uchar) Freq);
  outp(Voice+1,(uchar) (Freq >> 8));
}

