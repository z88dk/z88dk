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


extern void __LIB__ ay_wyz_init(wyz_song *song);
#ifndef __STDC_ABI_ONLY
extern void __LIB__ ay_wyz_init_fastcall(wyz_song *song) __z88dk_fastcall;
#deifne ay_wyz_init(x) ay_wyz_init_fastcall(x)
#endif

extern void __LIB__ ay_wyz_play(void);  // Called on interrupt, trashes main register + ix,iy

extern void __LIB__ ay_wyz_start(int song); // Setup to play song N
#ifndef __STDC_ABI_ONLY
extern void __LIB__ ay_wyz_start_fastcall(int song) __z88dk_fastcall; // Setup to play song N
#define ay_wyz_start(x) ay_wyz_start_fastcall(x)
#endif

extern void __LIB__ ay_wyz_stop(void);  // Stop playing

// Sound effect functionality
typedef int wyz_effects;

extern void __LIB__ ay_wyz_effect_init(wyz_effects *effects);
#ifndef __STDC_ABI_ONLY
extern void __LIB__ ay_wyz_effect_init_fastcall(wyz_effects *effects) __z88dk_fastcall;
#define ay_wyz_effect_init(x) ay_wyz_effect_init_fastcall(x)
#endif

 // Play an effect on specified channel
__ZPROTO2(void,,ay_wyz_start_effect,int,channel,int,effect_number)

extern void __LIB__ ay_wyz_stop_effect(void);  // Stop playing effect


#endif
