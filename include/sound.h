#ifndef __SOUND_H__
#define __SOUND_H__

/*
 *	Sound support code
 *
 *	Stefano, Oct 2001
 *
 *	$Id: sound.h,v 1.1 2001-10-16 18:30:32 dom Exp $
 *
 */

/* Pragma to include the sound variables */

#pragma output NEED1bitsound

/* 1 bit sound library */

extern __LIB__ bit_open();
extern __LIB__ bit_close();
extern __LIB__ bit_click();
extern __LIB__ bit_fx(int effect);

/* "period": the higher value, the lower tone ! */
extern __LIB__ bit_beep(int duration, int period);

/* Real frequency !  Duration is in ms */
#ifdef __MATH_H__
extern __LIB__ bit_frequency(float duration, float frequency);
#endif

/* Play a song (example: "2A--A-B-CDEFGAB5C+") */
extern __LIB__ bit_play(unsigned char melody[]);

/* Platform specific parameters (mainly timing stuff) */

#ifdef SPECTRUM
  #define BEEP_TSTATES 437500.0  /* 3.4 Mhz; float value = CPU_CLOCK*125 */
#endif

#ifdef Z88
  #define BEEP_TSTATES 410000.0 /* 3.28 Mhz */
#endif

#endif
