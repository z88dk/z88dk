
#ifndef _INPUT_H
#define _INPUT_H

#include <stdint.h>

/////////////////////////////////
// CROSS-PLATFORM INPUT FUNCTIONS
/////////////////////////////////

///////////
// keyboard
///////////

#if __SDCC | __SDCC_IX | __SDCC_IY

// sdcc

extern int                            in_inkey(void);
extern int                            in_key_pressed(uint16_t scancode);
extern uint16_t                       in_key_scancode(int c);

extern uint16_t                       in_pause(uint16_t dur_ms);
extern int                            in_test_key(void);
extern void                           in_wait_key(void);
extern void                           in_wait_nokey(void);

#else

// sccz80

extern int       __LIB__              in_inkey(void);
extern int       __LIB__ __FASTCALL__ in_key_pressed(uint16_t scancode);
extern uint16_t  __LIB__ __FASTCALL__ in_key_scancode(int c);

extern uint16_t  __LIB__ __FASTCALL__ in_pause(uint16_t dur_ms);
extern int       __LIB__              in_test_key(void);
extern void      __LIB__              in_wait_key(void);
extern void      __LIB__              in_wait_nokey(void);

#endif

////////////
// joysticks
////////////

// user defined keys structure for simulated joystick

typedef struct udk_s
{

   uint16_t fire;      // scancode
   uint16_t right;     // scancode
   uint16_t left;      // scancode
   uint16_t down;      // scancode
   uint16_t up;        // scancode
   
} udk_t;

// masks for return values from joystick functions

#define IN_STICK_FIRE    0x80
#define IN_STICK_FIRE_1  0x80
#define IN_STICK_FIRE_2  0x40

#define IN_STICK_UP      0x01
#define IN_STICK_DOWN    0x02
#define IN_STICK_LEFT    0x04
#define IN_STICK_RIGHT   0x08

#if __SDCC | __SDCC_IX | __SDCC_IY

// sdcc

extern uint16_t                       in_stick_keyboard(udk_t *u);

#else

// sccz80

extern uint16_t  __LIB__ __FASTCALL__ in_stick_keyboard(udk_t *u);

#endif

////////
// mouse
////////

/******************************

stick mouse is not widely used yet and there may be a better
way to handle it so postpone the implementation

// mouse deltas for stick mouse

typedef struct md_s
{

   uint8_t  count;     // number of times to use this delta
   uint16_t dx;        // horizontal step size
   uint16_t dy;        // vertical step size

} md_t;

// stick mouse structure

typedef struct udm_s
{

   udk_t    *keys;     // keys if keyboard joystick used
   void     *stick;    // stick function
   md_t    **deltas;   // pointer to array of mouse deltas
   uint8_t   state;    // current index into delta array
   uint8_t   count;    // current count for delta
   uint16_t  x;        // x coordinate
   uint16_t  y;        // y coordinate

} udm_t;

extern udm_t input_stick_mouse_state;

******************************/

// masks for return values from mouse functions

#define IN_MOUSE_BUTTON_LEFT    0x01
#define IN_MOUSE_BUTTON_RIGHT   0x02
#define IN_MOUSE_BUTTON_MIDDLE  0x04

#define IN_MOUSE_BUTTON_1       0x01
#define IN_MOUSE_BUTTON_2       0x02
#define IN_MOUSE_BUTTON_3       0x04

/******************************

#if __SDCC | __SDCC_IX | __SDCC_IY

// sdcc

extern void               in_mouse_stick_init(void);
extern void               in_mouse_stick_reset(void);
extern void               in_mouse_stick_setpos(uint16_t x, uint16_t y);
extern void               in_mouse_stick(uint8_t *buttons, uint16_t *x, uint16_t *y);
extern uint16_t           in_mouse_stick_wheel(void);

#else

// sccz80

extern void     __LIB__               in_mouse_stick_init(void);
extern void     __LIB__               in_mouse_stick_reset(void);
extern void     __LIB__               in_mouse_stick_setpos(uint16_t x, uint16_t y);
extern void     __LIB__               in_mouse_stick(uint8_t *buttons, uint16_t *x, uint16_t *y);
extern uint16_t __LIB__               in_mouse_stick_wheel(void);

// sccz80 callee linkage

extern void     __LIB__ __CALLEE__    in_mouse_stick_setpos_callee(uint16_t x, uint16_t y);
extern void     __LIB__ __CALLEE__    in_mouse_stick_callee(uint8_t *buttons, uint16_t *x, uint16_t *y);

// sccz80 make callee linkage the default

#define in_mouse_stick_setpos(a,b)    in_mouse_stick_setpos_callee(a,b)
#define in_mouse_stick(a,b,c)         in_mouse_stick_callee(a,b,c)

#endif

******************************/

////////////////////////////////////
// PLATFORM SPECIFIC INPUT FUNCTIONS
////////////////////////////////////

#ifdef __SPECTRUM
#include <input/input_spectrum.h>
#endif

#endif
