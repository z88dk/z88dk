/*
 * VortexTracker2 Tracker Library (AY819x)
 */

#ifndef __PSG_VT2_H__
#define __PSG_VT2_H__

#include <sys/compiler.h>

typedef int vt2_song;

extern void __LIB__ ay_vt2_init(vt2_song *song) __z88dk_fastcall;
extern void __LIB__ ay_vt2_play(void);  // Called on interrupt, trashes main register + ix,iy
extern void __LIB__ ay_vt2_start(void); // Setup to play song N
extern void __LIB__ ay_vt2_stop(void);  // Stop playing
extern void __LIB__ ay_vt2_mute(void);  // Mute playign

#endif
