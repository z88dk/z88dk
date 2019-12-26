include(__link__.m4)

#ifndef __ARCH_SCZ180_H__
#define __ARCH_SCZ180_H__

#include <arch.h>

// IO MAPPED REGISTERS

#ifdef __CLANG

extern uint8_t io_dio;

extern uint8_t io_system;
extern uint8_t io_led_output;
extern uint8_t io_led_status;

extern uint8_t io_cf;

#else

__sfr __at __IO_DIO_PORT    io_dio;

__sfr __at __IO_SYSTEM      io_system;
__sfr __at __IO_LED_OUTPUT  io_led_output;
__sfr __at __IO_LED_STATUS  io_led_status;

__sfr __at __IO_CF_PORT     io_cf;

#endif

// CSIO SD COMMANDS

__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',void,,sd_clock,uint8_t)
__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',void,,sd_cs_lower,uint8_t)
__DPROTO(`b,c,d,e,h,l,iyh,iyl',`b,c,d,e,h,l,iyh,iyl',void,,sd_cs_raise,void)
__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',void,,sd_write_byte,uint8_t)
__DPROTO(`b,c,d,e,iyh,iyl',`b,c,d,e,iyh,iyl',uint8_t,,sd_read_byte,void)
__DPROTO(`iyh,iyl',`iyh,iyl',void,,sd_write_block,const uint8_t *from)
__DPROTO(`iyh,iyl',`iyh,iyl',void,,sd_read_block,uint8_t *to)

#endif /* !__ARCH_SCZ180_H__ */
