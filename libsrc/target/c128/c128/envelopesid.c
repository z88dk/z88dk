/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: envelopesid.c,v 1.2 2016-06-16 21:13:07 dom Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* set adsr envelope.  all adsr values must be >= 0 and <= 15 */

void envelopesid(ushort Voice, ushort Attack, ushort Decay, ushort Sustain, ushort Release)
{
  outp(Voice+5,(Attack << 4) | Decay);
  outp(Voice+6,(Sustain << 4) | Release);
}

