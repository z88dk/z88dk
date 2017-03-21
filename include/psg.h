/*
 * Universal library for Yamaha Programmable Sound Generator
 * and similar chips
 *
 * $Id: psg.h,v 1.14 2016-06-11 19:53:08 dom Exp $
 *
 */

#ifndef __PSG_H__
#define __PSG_H__

#include <math.h>

// convert a given frequency into a suitable period for PSG

#ifdef __X1__
// Z80 is clocked at 4mhz
#define psgT(hz)		((int)(125000.0 / (hz)))
#endif

#ifdef __MC1000__
// CPU clock: 3.57 mhz, let's divide by 32
#define psgT(hz)		((int)(111562.5 / (hz)))
#endif

#ifdef __AQUARIUS__
#define psgT(hz)		((int)(111861.0 / (hz)))
#endif

// 1 Mhz clock but the SID is different  
#ifdef __C128__
#include <c128/sid.h>
#define psgT(hz)		((int) (hz/0.0596))
#endif

#ifdef __MSX__
#include <msx.h>
// src clock: 17897725.5 divided internally by 16
#define psgT(hz)		((int)(111760.0 / (hz)))
#endif

#ifdef __PC6001__
// 3.8 Mhz on earlier models, 4Mhz on next ones
#define psgT(hz)		((int)(118750.0 / (hz)))
#endif

#ifdef __SVI__
#include <msx.h>
#define psgT(hz)		((int)(111760.0 / (hz)))
#endif

#ifdef __SPECTRUM__
// src clock: 1773400 divided internally by 16
// ..but clock differs on other interfaces, so let's permit programmers to override
#ifndef psgT
#define psgT(hz)		((int)(110837.5 / (hz)))
#endif
#endif

#ifdef __SPRINTER__
// The PPS Sprinter PSG lib is totally untested, let's assume it is connected
// and clocked as for a Spectrum, but probably we're wrong
#define psgT(hz)		((int)(110837.5 / (hz)))
#endif

#ifdef __TRS80__
// EACA Colour Genie EG2000 sound
#define psgT(hz)		((int)(138550.0 / (hz)))
#endif

#ifdef __CPC__
// src clock: 1000000 divided internally by 16
#ifndef psgT
#define psgT(hz)		((int)(62500.0 / (hz)))
#endif
#endif

#ifdef __ZX80__
// ZON-X81 clock: 1625000  divided internally by 16
#define psgT(hz)		((int)(101562.0 / (hz)))
#endif

#ifdef __ZX81__
// ZON-X81 clock: 1625000  divided internally by 16
#ifndef psgT
#define psgT(hz)		((int)(101562.0 / (hz)))
#endif
#endif


// Keep CP/M at the end of the models list, so it can be overriden

#ifdef __CPM__
// This one is tricky.
// Clock varies, so let's use a generic value which the programmer can override
#ifndef psgT
#define psgT(hz)		((int)(100000.0 / (hz)))
#endif
#endif



// Play a sound by PSG
extern void __LIB__ set_psg(unsigned char reg, unsigned char val) __smallc;
extern void __LIB__    set_psg_callee(unsigned char reg, unsigned char val) __smallc __z88dk_callee;
#define set_psg(a,b)     set_psg_callee(a,b)

// Read the PSG register
extern int __LIB__  get_psg(int regno) __z88dk_fastcall;

// Init the PSG (reset sound etc..)
extern void __LIB__ psg_init();


// alias for setting psg registers (for the BASIC fans)
#define sound(reg, value) set_psg(reg, value)

// Set a given tone for the channel (0-2)
extern void __LIB__ psg_tone(unsigned char channel, int period) __smallc;

// Set the global noise period
extern void __LIB__ psg_noise(unsigned char period);

// Set channel's volume
extern void __LIB__ psg_volume(unsigned char channel, unsigned char volume) __smallc;

// Set the volume envelope of number \a waveform, with the given period, on a group of channels (ORed bits)
extern void __LIB__ psg_envelope(unsigned char waveform, int period, unsigned char channels) __smallc;

// Set noise or tone generation on a group of channels (ORed bits)
extern void __LIB__ psg_channels(unsigned char tone_channels, unsigned char noise_channels) __smallc;

// Get the group of channels currently generating tone (ORed bits)
extern unsigned char __LIB__ psg_tone_channels();

// Get the group of channels currently generating noise (ORed bits)
extern unsigned char __LIB__ psg_noise_channels();



enum {	
	chanNone = 0,	///< no channel
	chan0 = 1,	///< the first audio channel
	chan1 = 2,	///< the second audio channel
	chan2 = 4,	///< the third audio channel
	chanAll = 7	///< all audio channels
};

// volume envelopes, where U = up, D = down, H = high
enum {
	envD = 0,	///< envelope, falling into silence
	envU = 4,	///< envelope, raising to highest volume, then silenced
	envDD = 8,	///< envelope, falling into silence multiple times
	envDUD = 10,	///< envelope, first falling, and then triangle shaped
	envDH = 11,	///< envelope, falling into silence, then abrupt high volume
	envUU = 12,	///< envelope, raising until top multiple times
	envUH = 13,	///< envelope, raising until top and then mantaining high volume
	envUDUD = 14	///< envelope, triangle shaped
};


#endif
