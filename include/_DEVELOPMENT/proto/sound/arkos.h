include(__link__.m4)

/*
    Arkos Tracker 2 player support for Z88DK
    09/03/2023 - ZXjogv <zx@jogv.es>

    Arkos C function prototypes
*/

#ifndef __SOUND_ARKOS_H__
#define __SOUND_ARKOS_H__

#include <sys/compiler.h>

extern void __LIB__ ply_akg_init( void *song, uint16_t subsong ) __z88dk_callee;
extern void __LIB__ ply_akg_play( void );
extern void __LIB__ ply_akg_stop( void );
extern void __LIB__ ply_akg_initsoundeffects( void *effects_table[] ) __z88dk_fastcall;
extern void __LIB__ ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee;

extern void __LIB__ ply_rom_akg_init( void *song, uint16_t subsong ) __z88dk_callee;
extern void __LIB__ ply_rom_akg_play( void );
extern void __LIB__ ply_rom_akg_stop( void );
extern void __LIB__ ply_rom_akg_initsoundeffects( void *effects_table[] ) __z88dk_fastcall;
extern void __LIB__ ply_rom_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee;

#ifdef ARKOS_USE_ROM_PLAYER
#define ply_akg_init(s,ss) ply_rom_akg_init(s,ss)
#define ply_akg_play() ply_rom_akg_play()
#define ply_akg_stop() ply_rom_akg_stop()
#define ply_akg_initsoundeffects(table) ply_rom_akg_initsoundeffects(table)
#define ply_akg_playsoundeffects(effect, channel, volume) ply_rom_akg_playsoundeffects(effect, channel, volume)
#endif

#endif // __SOUND_ARKOS_H__
