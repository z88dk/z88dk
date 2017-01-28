#ifndef __SOUND_H__
#define __SOUND_H__

#include <sys/compiler.h>

/*
 *	Sound support code
 *
 *	$Id: sound.h,v 1.24 2016-11-15 08:11:10 stefano Exp $
 */


/* 1 bit sound library */


extern void  __LIB__ bit_open();
extern void __LIB__ bit_close();
extern void __LIB__ bit_click();

/* Sound effects; every library contains 8 different sounds (effect no. 0..7) */
extern void __LIB__ bit_fx(int effect);
extern void __LIB__ bit_fx2(int effect);
extern void __LIB__ bit_fx3(int effect);
extern void __LIB__ bit_fx4(int effect);

/* 1 BIT SYNTH - Polyphony and multitimbric effects */
extern void __LIB__ bit_synth(int duration, int frequency1, int frequency2, int frequency3, int frequency4) __smallc;

/* "period": the higher value, the lower tone ! */
extern void __LIB__ bit_beep(int duration, int period) __smallc;

/* Real frequency !  Duration is in ms */
extern void __LIB__ bit_frequency(float duration, float frequency);

/* Play a song (example: "2A--A-B-CDEFGAB5C+") */
extern void __LIB__ bit_play(unsigned char melody[]);


/* Platform specific parameters (mainly timing stuff) 

   The BEEP_TSTATES constant is obtained by dividing the
   CPU clock frequency by eight
*/


#ifdef ACE
  #define BEEP_TSTATES 406250.0 /* 3.25 Mhz */
#endif

#ifdef AQUARIUS
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

#ifdef AUSSIEBYTE
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

#ifdef BEE
  #define BEEP_TSTATES 250000.0 /* 2 Mhz */
  /* #define BEEP_TSTATES 421875.0 -> 3.375 Mhz */
#endif

#ifdef C128
  #define BEEP_TSTATES 250000.0  /* 2 Mhz.. VIC-II steals time */
#endif

#ifdef ENTERPRISE
  #define BEEP_TSTATES 500000.0  /* 4 Mhz */
#endif

#ifdef GAL
  #define BEEP_TSTATES 384000.0  /* 3.072 MHz*/
#endif

#ifdef MSX
  #define BEEP_TSTATES 447500.0  /* 3.58 Mhz */
#endif

#ifdef MC1000
  #define BEEP_TSTATES 447443.1 /* 3.579545 Mhz */
#endif

#ifdef P2000
  #define BEEP_TSTATES 312500.0 /* 2.5 Mhz */
#endif

#ifdef SPECTRUM
  #define BEEP_TSTATES 437500.0  /* 3.5 Mhz; float value = CPU_CLOCK*125 */
#endif

#ifdef TICALC
// TICALC, TI82, TI83, TI8X, TI85, TI86, SHARP OZ
  #define BEEP_TSTATES 750000.0 /* 6 Mhz */
  /* TI-83 Plus should have 1875000.0 (15 Mhz) if Silver Edition */
  /* #define BEEP_TSTATES 1875000.0 */
#endif

#ifdef TRS80
  #define BEEP_TSTATES 221750.0 /* 1.774 Mhz */
#endif

/* Clock timing is not perfect, here we have a slightly different 
   routine, with the inner loop differing for one cycle,and
   VZ300 has a CPU clock of 3,54 Mhz, VZ200 -> 3,58.. we stay in the middle */
#ifdef VZ
  #define BEEP_TSTATES 442500.0  /* 3.54 Mhz */
#endif

#ifdef Z9001
  #define BEEP_TSTATES 307200.0 /* 2.4576 Mhz */
#endif

/* We always get Z88, so it can't be a condition */
#ifndef BEEP_TSTATES
  #define BEEP_TSTATES 410000.0 /* Z88 -- 3.28 Mhz */
#endif


#endif
