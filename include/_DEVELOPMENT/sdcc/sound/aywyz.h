
// automatically generated by m4 from headers in proto subdir


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


extern void ay_wyz_init(wyz_song *);
extern void ay_wyz_init_fastcall(wyz_song *) __z88dk_fastcall;
#define ay_wyz_init(a) ay_wyz_init_fastcall(a)


extern void ay_wyz_play(void);

extern void ay_wyz_start(int);
extern void ay_wyz_start_fastcall(int) __z88dk_fastcall;
#define ay_wyz_start(a) ay_wyz_start_fastcall(a)


extern void ay_wyz_stop(void);


// Sound effect functionality
typedef int wyz_effects;

extern void ay_wyz_effect_init(wyz_effects *effects);
extern void ay_wyz_effect_init_fastcall(wyz_effects *effects) __z88dk_fastcall;
#define ay_wyz_effect_init(a) ay_wyz_effect_init_fastcall(a)


extern void ay_wyz_start_effect(int channel,int effect_number);
extern void ay_wyz_start_effect_callee(int channel,int effect_number) __z88dk_callee;
#define ay_wyz_start_effect(a,b) ay_wyz_start_effect_callee(a,b)


extern void ay_wyz_stop_effect(void);


#endif
