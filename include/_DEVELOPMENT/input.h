
#ifndef _INPUT_H
#define _INPUT_H

#include <stdint.h>

/////////////////////////////////
// CROSS-PLATFORM INPUT FUNCTIONS
/////////////////////////////////

///////////
// keyboard
///////////

#ifdef __SDCC

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

#ifdef __SDCC

// sdcc

extern uint16_t                       in_stick_keyboard(udk_t *u);

#else

// sccz80

extern uint16_t  __LIB__ __FASTCALL__ in_stick_keyboard(udk_t *u);

#endif

////////
// mouse
////////

// masks for return values from mouse functions

#define IN_MOUSE_BUTTON_LEFT    0x01
#define IN_MOUSE_BUTTON_RIGHT   0x02
#define IN_MOUSE_BUTTON_MIDDLE  0x04

#define IN_MOUSE_BUTTON_1       0x01
#define IN_MOUSE_BUTTON_2       0x02
#define IN_MOUSE_BUTTON_3       0x04

////////////////////////////////////
// PLATFORM SPECIFIC INPUT FUNCTIONS
////////////////////////////////////

#ifdef __SPECTRUM
#include <input/input_spectrum.h>
#endif

#endif
