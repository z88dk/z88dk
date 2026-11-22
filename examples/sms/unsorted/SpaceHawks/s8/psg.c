#include <arch/sms/SMSlib.h>
#include "types.h"
#include "psg.h"

#ifndef TARGET_GG
#define IS_PALSYSTEM	( SMS_VDPType() == VDP_PAL )
#endif

/*
//the SDCC magic trick learnt from sverx's psglib.c
// convert any 
//	 PSGPort = val;
// to
//	 ld  a, val
//	 out (0x7f), a
// useful no ? ;)
__sfr __at 0x7F PSGPort;

void PSG_write(u8 data)
{
    PSGPort = data;
}


void PSG_setEnvelope(u8 channel, u8 value)
{
    PSGPort = 0x90 | ((channel & 3) << 5) | (value & 0xF);
}


void PSG_setNoise(u8 type, u8 frequency)
{
    PSGPort = 0xE0 | ((type & 1) << 2) | (frequency & 0x3);
}
*/
/*
void PSG_setTone(u8 channel, u16 value)
{
    PSG_write( 0x80 | ((channel & 3) << 5) | (value & 0xF) );
    PSG_write( (value >> 4) & 0x3F );
}
* */


void PSG_setFrequency(u8 channel, u16 value)
{
    u16 data;

    if (value)
    {
        // frequency to tone conversion
#ifdef TARGET_GG
		// GG similar to NTSC SMS
		data = 3579545 / (value * 32);
#else
        if (IS_PALSYSTEM) data = 3546893 / (value * 32);
        else data = 3579545 / (value * 32);
#endif

    }
    else data = 0;

    PSG_setTone(channel, data);
}


void PSG_init()
{
    u8 i;
    for (i = 0; i < 3; i++)
    {
        PSG_setTone(i, 0);
        PSG_setEnvelope(0, PSG_ENVELOPE_MIN); //silent
    }
    
    PSG_setNoise(0,0);
    PSG_setEnvelope(3, PSG_ENVELOPE_MIN); //silent
}