include(__link__.m4)

#ifndef _INPUT_CPM_H
#define _INPUT_CPM_H

#include <stdint.h>

///////////
// keyboard
///////////

__OPROTO(,,int,,in_inkey,void)
__DPROTO(,,int,,in_key_pressed,uint16_t scancode)
__DPROTO(,,uint16_t,,in_key_scancode,int c)

__DPROTO(,,uint16_t,,in_pause,uint16_t dur_ms)
__OPROTO(,,int,,in_test_key,void)
__OPROTO(,,void,,in_wait_key,void)
__OPROTO(,,void,,in_wait_nokey,void)

////////////
// joysticks
////////////

__DPROTO(,,uint16_t,,in_stick_keyboard,udk_t *u)

////////
// mouse
////////

#endif
