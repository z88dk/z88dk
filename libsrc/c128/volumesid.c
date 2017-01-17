/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: volumesid.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* set master volume and filter select */

void volumesid(ushort Amp, ushort Filter)
{
  outp(sidVolume,Filter | Amp);
}

