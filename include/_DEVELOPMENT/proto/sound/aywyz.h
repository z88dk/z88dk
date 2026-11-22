include(__link__.m4)

/*
 * WYZ Tracker Library
 */

#ifndef __SOUND_AYWYZ_H__
#define __SOUND_AYWYZ_H__

typedef struct {
    void  *effect_table;
    void  *instrument_table;
    void  *note_table;
    void  *song_table;
} wyz_song;


__D2PROTO(,,void,,ay_wyz_init,wyz_song *)
__OPROTO(,,void,,ay_wyz_play,void)
__D2PROTO(,,void,,ay_wyz_start,int)
__OPROTO(,,void,,ay_wyz_stop,void)

// Sound effect functionality
typedef int wyz_effects;

__D2PROTO(,,void,,ay_wyz_effect_init,wyz_effects *effects)
__DPROTO(,,void,,ay_wyz_start_effect,int channel, int effect_number)
__OPROTO(,,void,,ay_wyz_stop_effect,void)

#endif
