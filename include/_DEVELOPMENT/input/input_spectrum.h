
#ifndef _INPUT_SPECTRUM_H
#define _INPUT_SPECTRUM_H

#include <stdint.h>

////////////
// joysticks
////////////

#if __SDCC | __SDCC_IX | __SDCC_IY

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


#endif
