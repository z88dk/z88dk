/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: volumesid.c,v 1.1 2008-06-23 17:34:36 stefano Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* set master volume and filter select */

void volumesid(uchar Amp, uchar Filter)
{
  outp(sidVolume,Filter | Amp);
}

