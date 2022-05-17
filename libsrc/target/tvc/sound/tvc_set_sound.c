/*
 *  Videoton TV Computer C stub
 *   Sandor Vass - 2022
 *
 *	Set sound pitch and volume and enables sound
 */

#include <tvc.h>

void tvc_set_sound(int frequency, unsigned char volume) {
    tvc_set_sound_pitch(frequency);
    tvc_set_sound_volume(volume);
    tvc_enable_sound(true);
}