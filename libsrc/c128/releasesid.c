/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: releasesid.c,v 1.1 2008-06-23 17:34:34 stefano Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* start release cycle */

void releasesid(ushort Voice, uchar Waveform)
{
  outp(Voice+4,Waveform);
}

