/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: envelopesid.c,v 1.1 2008-06-23 17:34:33 stefano Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* set adsr envelope.  all adsr values must be >= 0 and <= 15 */

void envelopesid(ushort Voice, uchar Attack, uchar Decay, uchar Sustain, uchar Release)
{
  outp(Voice+5,(Attack << 4) | Decay);
  outp(Voice+6,(Sustain << 4) | Release);
}

