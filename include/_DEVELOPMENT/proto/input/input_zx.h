include(__link__.m4)

#ifndef _INPUT_ZX_H
#define _INPUT_ZX_H

#include <stdint.h>

////////////
// joysticks
////////////

__OPROTO(uint16_t,,in_stick_cursor,void)
__OPROTO(uint16_t,,in_stick_fuller,void)
__OPROTO(uint16_t,,in_stick_kempston,void)
__OPROTO(uint16_t,,in_stick_sinclair1,void)
__OPROTO(uint16_t,,in_stick_sinclair2,void)

////////
// mouse
////////

__DPROTO(void,,in_mouse_amx_init,uint16_t x_vector,uint16_t y_vector)
__OPROTO(void,,in_mouse_amx_reset,void)
__DPROTO(void,,in_mouse_amx_setpos,uint16_t x,uint16_t y)
__DPROTO(void,,in_mouse_amx,uint8_t *buttons,uint16_t *x,uint16_t *y)
__OPROTO(uint16_t,,in_mouse_amx_wheel,void)
__OPROTO(int16_t,,in_mouse_amx_wheel_delta,void)

__OPROTO(void,,in_mouse_kempston_init,void)
__OPROTO(void,,in_mouse_kempston_reset,void)
__DPROTO(void,,in_mouse_kempston_setpos,uint16_t x,uint16_t y)
__DPROTO(void,,in_mouse_kempston,uint8_t *buttons,uint16_t *x,uint16_t *y)
__OPROTO(uint16_t,,in_mouse_kempston_wheel,void)
__OPROTO(int16_t,,in_mouse_kempston_wheel_delta,void)

#endif
