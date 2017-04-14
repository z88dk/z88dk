include(__link__.m4)

#ifndef _INPUT_SMS_H
#define _INPUT_SMS_H

#include <stdint.h>

///////////
// keyboard
///////////

__DPROTO(`iyl,iyh',`iyl,iyh',uint16_t,,in_pause,uint16_t dur_ms)
__OPROTO(`b,c,d,e',`b,c,d,e',int,,in_test_key,void)
__OPROTO(`b,c,d,e,h,l',`b,c,d,e,h,l',void,,in_wait_key,void)
__OPROTO(`b,c,d,e,h,l',`b,c,d,e,h,l',void,,in_wait_nokey,void)

////////////
// joysticks
////////////

__OPROTO(`b,c,d,e',`b,c,d,e',uint16_t,,in_stick_1,void)
__OPROTO(`b,c,d,e',`b,c,d,e',uint16_t,,in_stick_2,void)

#endif
