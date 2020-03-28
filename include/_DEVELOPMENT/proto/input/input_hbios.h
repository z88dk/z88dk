include(__link__.m4)

#ifndef __INPUT_HBIOS_H__
#define __INPUT_HBIOS_H__

#include <stdint.h>

///////////
// keyboard
///////////

__OPROTO(,,int,,in_inkey,void)
__OPROTO(,,int,,in_test_key,void)
__OPROTO(,,void,,in_wait_key,void)
__OPROTO(,,void,,in_wait_nokey,void)

__DPROTO(,,uint16_t,,in_pause,uint16_t dur_ms)

////////////
// joysticks
////////////

////////
// mouse
////////

#endif
