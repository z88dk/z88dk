/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: releasesid.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* start release cycle */

void releasesid(ushort Voice, ushort Waveform)
{
  outp(Voice+4,Waveform);
}

