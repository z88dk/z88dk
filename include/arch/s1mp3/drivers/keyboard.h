#ifndef __KEYBOARD_H__
#define __KEYBOARD_H__

#include <ATJ2085_Ports.h>

extern void __LIB__ KEYBOARD_Initialise( void );
extern void __LIB__ KEYBOARD_ISR( void );
extern unsigned char __LIB__ KEYBOARD_GetKeyState( void );

#define KEY_MODE 128
#define KEY_HOLD 64
#define KEY_VOL_UP 32
#define KEY_VOL_DOWN 16
#define KEY_PREV 8
#define KEY_NEXT 4
#define KEY_REC 2
#define KEY_PLAY 1

#endif /* __USB_H__ */

