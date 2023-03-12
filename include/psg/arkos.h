/*
    Arkos Tracker 2 player support for Z88DK
    09/03/2023 - ZXjogv <zx@jogv.es>

    Arkos C function prototypes

    NOTE FOR MSX TARGET: if you #define the macro ARKOS_USE_ROM_PLAYER in
    your code before #including this file, a ROMable player will be used. 
    You _must_ use the ROM player when compiling for a ROM target!

    Arkos Player Functions:

    // initialize player
    void ply_akg_init( void *song, uint16_t subsong ) __z88dk_callee __smallc;

    // call this every 1/50th sec to play music
    // must be called with interrupts disabled!
    void ply_akg_play( void );

    // stop playing
    void ply_akg_stop( void );

    // initialize sound effects
    void ply_akg_initsoundeffects( void *effects_table[] ) __z88dk_fastcall;

    // play a sound effect - this function just programs the sound to be output. 
    // ply_akg_play() still needs to be called periodically for ti to be played
    void ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee __smallc;

*/

#ifndef _ARKOS_H
#define _ARKOS_H

/*
    Different symbols for different configs and targets are defined, but we
    pick the correct ones according to the target we are compiling for.
*/

#ifdef __MSX__

// MSX declarations - this can in turn be in RAM or ROM mode
#ifdef ARKOS_USE_ROM_PLAYER
    #define ply_akg_init(a,b)			msx_rom_ply_akg_init(a,b)
    #define ply_akg_play()			msx_rom_ply_akg_play()
    #define ply_akg_stop()			msx_rom_ply_akg_stop()
    #define ply_akg_initsoundeffects(a)	msx_rom_ply_akg_initsoundeffects(a)
    #define ply_akg_playsoundeffect(a,b,c)	msx_rom_ply_akg_playsoundeffect(a,b,c)
#else
    #define ply_akg_init(a,b)			msx_ram_ply_akg_init(a,b)
    #define ply_akg_play()			msx_ram_ply_akg_play()
    #define ply_akg_stop()			msx_ram_ply_akg_stop()
    #define ply_akg_initsoundeffects(a)	msx_ram_ply_akg_initsoundeffects(a)
    #define ply_akg_playsoundeffect(a,b,c)	msx_ram_ply_akg_playsoundeffect(a,b,c)
#endif

#else
#ifdef __SPECTRUM__

// ZX Spectrum declarations - this is always in RAM mode
    #define ply_akg_init(a,b)			zx_ram_ply_akg_init(a,b)
    #define ply_akg_play()			zx_ram_ply_akg_play()
    #define ply_akg_stop()			zx_ram_ply_akg_stop()
    #define ply_akg_initsoundeffects(a)	zx_ram_ply_akg_initsoundeffects(a)
    #define ply_akg_playsoundeffect(a,b,c)	zx_ram_ply_akg_playsoundeffect(a,b,c)
#else
    #warning "Arkos Tracker 2 support is not available for this target"
#endif
#endif

// Here follow all declarations for all target and mode combinations.  It
// does not hurt to have all of them here mixed - the right ones for your
// target will be declared by the macros above, and will be picked correctly
// at link time.

#include <stdint.h>

// MSX, ROM mode
void msx_rom_ply_akg_init( void *song, uint16_t subsong ) __z88dk_callee __smallc;
void msx_rom_ply_akg_play( void );
void msx_rom_ply_akg_stop( void );
void msx_rom_ply_akg_initsoundeffects( void *effects_table[] ) __z88dk_fastcall;
void msx_rom_ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee __smallc;

// MSX, RAM mode
void msx_ram_ply_akg_init( void *song, uint16_t subsong ) __z88dk_callee __smallc;
void msx_ram_ply_akg_play( void );
void msx_ram_ply_akg_stop( void );
void msx_ram_ply_akg_initsoundeffects( void *effects_table[] ) __z88dk_fastcall;
void msx_ram_ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee __smallc;

// ZX Spectrum, RAM mode
void zx_ram_ply_akg_init( void *song, uint16_t subsong ) __z88dk_callee __smallc;
void zx_ram_ply_akg_play( void );
void zx_ram_ply_akg_stop( void );
void zx_ram_ply_akg_initsoundeffects( void *effects_table[] ) __z88dk_fastcall;
void zx_ram_ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee __smallc;

#endif // _ARKOS_H
