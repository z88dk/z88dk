include(__link__.m4)

#ifndef _INPUT_ZX_H
#define _INPUT_ZX_H

#include <stdint.h>

///////////
// keyboard
///////////

#define IN_KEY_SCANCODE_DISABLE  0xffff
#define IN_KEY_SCANCODE_ANYKEY   0x1f00

#define IN_KEY_SCANCODE_CAPS   0x01fe
#define IN_KEY_SCANCODE_SYM    0x027f

#define IN_KEY_SCANCODE_ENTER  0x01bf
#define IN_KEY_SCANCODE_SPACE  0x017f

#define IN_KEY_SCANCODE_a      0x01fd
#define IN_KEY_SCANCODE_b      0x107f
#define IN_KEY_SCANCODE_c      0x08fe
#define IN_KEY_SCANCODE_d      0x04fd
#define IN_KEY_SCANCODE_e      0x04fb
#define IN_KEY_SCANCODE_f      0x08fd
#define IN_KEY_SCANCODE_g      0x10fd
#define IN_KEY_SCANCODE_h      0x10bf
#define IN_KEY_SCANCODE_i      0x04df
#define IN_KEY_SCANCODE_j      0x08bf
#define IN_KEY_SCANCODE_k      0x04bf
#define IN_KEY_SCANCODE_l      0x02bf
#define IN_KEY_SCANCODE_m      0x047f
#define IN_KEY_SCANCODE_n      0x087f
#define IN_KEY_SCANCODE_o      0x02df
#define IN_KEY_SCANCODE_p      0x01df
#define IN_KEY_SCANCODE_q      0x01fb
#define IN_KEY_SCANCODE_r      0x08fb
#define IN_KEY_SCANCODE_s      0x02fd
#define IN_KEY_SCANCODE_t      0x10fb
#define IN_KEY_SCANCODE_u      0x08df
#define IN_KEY_SCANCODE_v      0x10fe
#define IN_KEY_SCANCODE_w      0x02fb
#define IN_KEY_SCANCODE_x      0x04fe
#define IN_KEY_SCANCODE_y      0x10df
#define IN_KEY_SCANCODE_z      0x02fe

#define IN_KEY_SCANCODE_0      0x01ef
#define IN_KEY_SCANCODE_1      0x01f7
#define IN_KEY_SCANCODE_2      0x02f7
#define IN_KEY_SCANCODE_3      0x04f7
#define IN_KEY_SCANCODE_4      0x08f7
#define IN_KEY_SCANCODE_5      0x10f7
#define IN_KEY_SCANCODE_6      0x10ef
#define IN_KEY_SCANCODE_7      0x08ef
#define IN_KEY_SCANCODE_8      0x04ef
#define IN_KEY_SCANCODE_9      0x02ef

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
