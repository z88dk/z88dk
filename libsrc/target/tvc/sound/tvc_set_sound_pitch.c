/*
 *  Videoton TV Computer C stub
 *   Sandor Vass - 2022
 *
 *	Set sound pitch
 */

#include <tvc.h>

void tvc_set_sound_pitch(int frequency) {
    int raw = tvc_get_raw_pitch(frequency);
    tvc_set_sound_pitch_raw(raw);    
}