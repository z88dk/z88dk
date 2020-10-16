/*
 * WYZ Tracker Library (AY819x)
 */

#ifndef __PSG_WYZ_H__
#define __PSG_WYZ_H__

#include <sys/compiler.h>

typedef struct {
    void  *effect_table;
    void  *instrument_table;
    void  *note_table;
    void  *song_table;
} wyz_song;


extern void __LIB__ ay_wyz_init(wyz_song *song) __z88dk_fastcall;

extern void __LIB__ ay_wyz_play(void);  // Called on interrupt, trashes main register + ix,iy
extern void __LIB__ ay_wyz_start(int song) __z88dk_fastcall; // Setup to play song N
extern void __LIB__ ay_wyz_stop(void);  // Stop playing

// Sound effect functionality
typedef int wyz_effects;

extern void __LIB__ ay_wyz_effect_init(wyz_effects *effects) __z88dk_fastcall;
extern void __LIB__ ay_wyz_start_effect(int channel, int effect_number) __smallc; // Play an effect on specified channel
extern void __LIB__ ay_wyz_stop_effect(void);  // Stop playing effect


#endif
