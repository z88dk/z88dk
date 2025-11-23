#ifndef _PSG_H_
#define _PSG_H_

//port of Stef's SGDK psg.c

#define PSG_ENVELOPE_MIN    15
#define PSG_ENVELOPE_MAX    0
#define PSG_ENVELOPE_SILENT PSG_ENVELOPE_MIN
#define PSG_NOISE_TYPE_PERIODIC 0
#define PSG_NOISE_TYPE_WHITE    1
#define PSG_NOISE_FREQ_CLOCK2   0
#define PSG_NOISE_FREQ_CLOCK4   1
#define PSG_NOISE_FREQ_CLOCK8   2
#define PSG_NOISE_FREQ_TONE3    3

//the SDCC magic trick learnt from sverx's psglib.c
// convert any 
//	 PSGPort = val;
// to
//	 ld  a, val
//	 out (0x7f), a
// useful no ? ;)
__sfr __at 0x7F PSGPort;

#define PSG_write(data)					( PSGPort = data )
#define PSG_setEnvelope(chan, value)    ( PSGPort = 0x90 | ((chan & 3) << 5) | (value & 0xF) )
#define PSG_setNoise(type, frequency)	( PSGPort = 0xE0 | ((type & 1) << 2) | (frequency & 0x3) )
#define PSG_setTone(chan, value)		PSG_write( 0x80 | ((chan & 3) << 5) | (value & 0xF) );\
										PSG_write( (value >> 4) & 0x3F )

//void PSG_write(u8 data);
//void PSG_setEnvelope(u8 channel, u8 value);
//void PSG_setNoise(u8 type, u8 frequency);
//void PSG_setTone(u8 channel, u16 value); //this one could be defined too if I need 30bytes more ;)


void PSG_init();
void PSG_setFrequency(u8 channel, u16 value);

#endif // _PSG_H_
