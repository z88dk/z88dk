#ifndef SOUND_H
#define SOUND_H


/*
 *	Sound support code
 *
 *	Stefano, Oct 2001
 *
 *	$Id: sound.h,v 1.3 2001-10-25 13:31:32 stefano Exp $
 */


/* 1 bit sound library */

extern __LIB__ bit_open();
extern __LIB__ bit_close();
extern __LIB__ bit_click();
extern __LIB__ bit_fx(int effect);

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

#ifdef Z88
  #define BEEP_TSTATES 410000.0 /* 3.28 Mhz */
#endif

#ifdef ACE
  #define BEEP_TSTATES 406250.0 /* 3.25 Mhz */
#endif

#ifdef TI82
  #define BEEP_TSTATES 750000.0 /* 6 Mhz */
#endif

#ifdef TI83
  #define BEEP_TSTATES 750000.0
#endif

/* TI-83 Plus. 1875000.0 (15 Mhz) if Silver Edition */
#ifdef TI8X
  #define BEEP_TSTATES 750000.0 /* 6 Mhz */
  /* #define BEEP_TSTATES 1875000.0 */
#endif

#ifdef TI85
  #define BEEP_TSTATES 750000.0
#endif

#ifdef TI86
  #define BEEP_TSTATES 750000.0
#endif


#endif
