
#ifndef _INPUT_SPECTRUM_H
#define _INPUT_SPECTRUM_H

#include <stdint.h>

////////////
// joysticks
////////////

#ifdef __SDCC

// sdcc

extern uint16_t           in_stick_cursor(void);
extern uint16_t           in_stick_fuller(void);
extern uint16_t           in_stick_kempston(void);
extern uint16_t           in_stick_sinclair1(void);
extern uint16_t           in_stick_sinclair2(void);

#else

// sccz80

extern uint16_t  __LIB__  in_stick_cursor(void);
extern uint16_t  __LIB__  in_stick_fuller(void);
extern uint16_t  __LIB__  in_stick_kempston(void);
extern uint16_t  __LIB__  in_stick_sinclair1(void);
extern uint16_t  __LIB__  in_stick_sinclair2(void);

#endif

////////
// mouse
////////

#ifdef __SDCC

// sdcc

extern void               in_mouse_amx_init(unit8_t x_vector, uint8_t y_vector);
extern void               in_mouse_amx_reset(void);
extern void               in_mouse_amx_setpos(uint16_t x, uint16_t y);
extern void               in_mouse_amx(uint8_t *buttons, uint16_t *x, uint16_t *y);
extern uint16_t           in_mouse_amx_wheel(void);
extern int16_t            in_mouse_amx_wheel_delta(void);

extern void               in_mouse_kempston_init(void);
extern void               in_mouse_kempston_reset(void);
extern void               in_mouse_kempston_setpos(uint16_t x, uint16_t y);
extern void               in_mouse_kempston(uint8_t *buttons, uint16_t *x, uint16_t *y);
extern uint16_t           in_mouse_kempston_wheel(void);
extern int16_t            in_mouse_kempston_wheel_delta(void);

#else

// sccz80

extern void     __LIB__   in_mouse_amx_init(uint8_t x_vector, uint8_t y_vector);
extern void     __LIB__   in_mouse_amx_reset(void);
extern void     __LIB__   in_mouse_amx_setpos(uint16_t x, uint16_t y);
extern void     __LIB__   in_mouse_amx(uint8_t *buttons, uint16_t *x, uint16_t *y);
extern uint16_t __LIB__   in_mouse_amx_wheel(void);
extern int16_t  __LIB__   in_mouse_amx_wheel_delta(void);

extern void               in_mouse_kempston_init(void);
extern void     __LIB__   in_mouse_kempston_reset(void);
extern void     __LIB__   in_mouse_kempston_setpos(uint16_t x, uint16_t y);
extern void     __LIB__   in_mouse_kempston(uint8_t *buttons, uint16_t *x, uint16_t *y);
extern uint16_t __LIB__   in_mouse_kempston_wheel(void);
extern int16_t  __LIB__   in_mouse_kempston_wheel_delta(void);

// sccz80 callee linkage

extern void     __LIB__ __CALLEE__  in_mouse_amx_init_callee(uint8_t x_vector, uint8_t y_vector);
extern void     __LIB__ __CALLEE__  in_mouse_amx_setpos_callee(uint16_t x, uint16_t y);
extern void     __LIB__ __CALLEE__  in_mouse_amx_callee(uint8_t *buttons, uint16_t *x, uint16_t *y);

extern void     __LIB__ __CALLEE__  in_mouse_kempston_setpos_callee(uint16_t x, uint16_t y);
extern void     __LIB__ __CALLEE__  in_mouse_kempston_callee(uint8_t *buttons, uint16_t *x, uint16_t *y);

// sccz80 make callee linkage the default

#define in_mouse_amx_init(a,b)          in_mouse_amx_init_callee(a,b)
#define in_mouse_amx_setpos(a,b)        in_mouse_amx_setpos_callee(a,b)
#define in_mouse_amx(a,b,c)             in_mouse_amx_callee(a,b,c)

#define in_mouse_kempston_setpos(a,b)   in_mouse_kempston_setpos_callee(a,b)
#define in_mouse_kempston(a,b,c)        in_mouse_kempston_callee(a,b,c)

#endif


#endif
