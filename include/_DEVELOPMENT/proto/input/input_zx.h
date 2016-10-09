include(__link__.m4)

#ifndef _INPUT_ZX_H
#define _INPUT_ZX_H

#include <stdint.h>

///////////
// keyboard
///////////

__OPROTO(,,int,,in_inkey,void)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,in_key_pressed,uint16_t scancode)
__DPROTO(,,uint16_t,,in_key_scancode,int c)

__DPROTO(,,uint16_t,,in_pause,uint16_t dur_ms)
__OPROTO(`b,c,d,e',`b,c,d,e',int,,in_test_key,void)
__OPROTO(`b,c,d,e,h,l',`b,c,d,e,h,l',void,,in_wait_key,void)
__OPROTO(`b,c,d,e,h,l',`b,c,d,e,h,l',void,,in_wait_nokey,void)

////////////
// joysticks
////////////

__DPROTO(`b,c',`b,c',uint16_t,,in_stick_keyboard,udk_t *u)

__OPROTO(`b,c',`b,c',uint16_t,,in_stick_cursor,void)
__OPROTO(`b,c,d,e',`b,c,d,e',uint16_t,,in_stick_fuller,void)
__OPROTO(`b,c',`b,c',uint16_t,,in_stick_kempston,void)
__OPROTO(`b,c',`b,c',uint16_t,,in_stick_sinclair1,void)
__OPROTO(`b,c',`b,c',uint16_t,,in_stick_sinclair2,void)

////////
// mouse
////////

__DPROTO(,,void,,in_mouse_amx_init,uint16_t x_vector,uint16_t y_vector)
__OPROTO(,,void,,in_mouse_amx_reset,void)
__DPROTO(`h,l',`h,l',void,,in_mouse_amx_setpos,uint16_t x,uint16_t y)
__DPROTO(,,void,,in_mouse_amx,uint8_t *buttons,uint16_t *x,uint16_t *y)
__OPROTO(,,uint16_t,,in_mouse_amx_wheel,void)
__OPROTO(,,int16_t,,in_mouse_amx_wheel_delta,void)

__OPROTO(,,void,,in_mouse_kempston_init,void)
__OPROTO(,,void,,in_mouse_kempston_reset,void)
__DPROTO(`h,l',`h,l',void,,in_mouse_kempston_setpos,uint16_t x,uint16_t y)
__DPROTO(,,void,,in_mouse_kempston,uint8_t *buttons,uint16_t *x,uint16_t *y)
__OPROTO(,,uint16_t,,in_mouse_kempston_wheel,void)
__OPROTO(,,int16_t,,in_mouse_kempston_wheel_delta,void)

#endif
