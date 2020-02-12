/*
 * WYZ Tracker Library
 */

#ifndef __PSG_WYZ_H__
#define __PSG_WYZ_H__

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
extern void __LIB__ ay_wyz_play_effect(int channel, void *effect); // Play an effect
extern void __LIB__ ay_wyz_stop_effect(void);  // Stop playing effect


#endif
