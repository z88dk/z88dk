/*
 *  Videoton TV Computer C stub
 *   Sandor Vass - 2022
 *
 *	Calculates the raw value from the frequency of the PITCH of the sound
 */

#include <tvc.h>

int tvc_get_raw_pitch(int frequency) {
//     n=4096-195312.5/f
    double a = 195312.5 / frequency;
    if(a>4095.5)
        a = 4095.5;
    if(a<1.0)
        a = 1.0;

    return (int)(4096.0 - a + 0.5);
}
