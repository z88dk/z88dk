#ifndef _ARKOS2_H
#define _ARKOS2_H

#include <stdint.h>

// Arkos C prototypes

// initialize player
void ply_akg_init( void *song, uint16_t subsong ) __z88dk_callee;

// call this every 1/50th sec to play music
// must be called with interrupts disabled!
void ply_akg_play( void );

// stop playing
void ply_akg_stop( void );

// initialize sound effects
void ply_akg_initsoundeffects( void *effects_table[] ) __z88dk_fastcall;

// play a sound effect - this function just programs the sound to be output. 
// ply_akg_play() still needs to be called periodically for ti to be played
void ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee;

#endif // _ARKOS2_H
