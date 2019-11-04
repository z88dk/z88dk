include(__link__.m4)

#ifndef __SYSTEM_TIME_H__
#define __SYSTEM_TIME_H__

#include <arch.h>
#include <stdint.h>

extern volatile uint32_t _system_time;
extern volatile uint8_t  _system_time_fraction;

//
// SYSTEM TIME COMMANDS
//

// system_tick_init( void *prt0_isr) is needed for non-asci0 subtypes (basic, basic_dcio)

__DPROTO(`a,b,c,d,e,iyh,iyl',`a,b,c,d,e,iyh,iyl',void,,system_tick_init,void *prt0_isr)

#endif
