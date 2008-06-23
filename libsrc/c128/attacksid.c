/*

Based on the SG C Tools 1.7
(C) 1993 Steve Goldsmith

$Id: attacksid.c,v 1.1 2008-06-23 17:34:31 stefano Exp $

*/

#include <stdlib.h>
#include <c128/sid.h>

/* start attack, decay, sustain cycle.  gate bit is not needed */

void attacksid(ushort Voice, uchar Waveform)
{
  outp(Voice+4,Waveform | sidWaveGate);
}

