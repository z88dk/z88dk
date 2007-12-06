#ifndef SOUND_H
#define SOUND_H


/*
 *	Sound support code
 *
 *	Stefano, Oct 2001 - First release
 *	         Dec 2001 - Added Mattel Aquarius
 *
 *	$Id: sound.h,v 1.8 2007-12-06 10:19:05 stefano Exp $
 */


/* 1 bit sound library */

#pragma output NEED1bitsound

extern __LIB__ bit_open();
extern __LIB__ bit_close();
extern __LIB__ bit_click();

/* Sound effects; every library contains 8 different sounds (effect no. 0..7) */
extern __LIB__ bit_fx(int effect);
extern __LIB__ bit_fx2(int effect);
extern __LIB__ bit_fx3(int effect);
extern __LIB__ bit_fx4(int effect);

/* 1 BIT SYNTH - Polyphony and multitimbric effects */
extern __LIB__ bit_synth(int duration, int frequency1, int frequency2, int frequency3, int frequency4);

/* "period": the higher value, the lower tone ! */
extern __LIB__ bit_beep(int duration, int period);

/* Real frequency !  Duration is in ms */
extern __LIB__ bit_frequency(float duration, float frequency);

/* Play a song (example: "2A--A-B-CDEFGAB5C+") */
extern __LIB__ bit_play(unsigned char melody[]);

/* Platform specific parameters (mainly timing stuff) */

#ifdef SPECTRUM 
  #define BEEP_TSTATES 437500.0  /* 3.5 Mhz; float value = CPU_CLOCK*125 */
#endif

#ifdef MSX
  #define BEEP_TSTATES 447500.0  /* 3.58 Mhz */
#endif

#ifdef AQUARIUS
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

#ifdef Z88
  #define BEEP_TSTATES 410000.0 /* 3.28 Mhz */
#endif

#ifdef ACE
  #define BEEP_TSTATES 406250.0 /* 3.25 Mhz */
#endif

#if defined TICALC || defined TI82 || defined TI83 || defined TI8X || defined TI85 || defined TI86
#ifdef TI8X
  #define BEEP_TSTATES 750000.0 /* 6 Mhz */
  /* TI-83 Plus should have 1875000.0 (15 Mhz) if Silver Edition */
  /* #define BEEP_TSTATES 1875000.0 */
#endif


#endif
