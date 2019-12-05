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

extern uint8_t io_cf_port;

extern uint8_t io_pio_port_a;
extern uint8_t io_pio_port_b;
extern uint8_t io_pio_port_b;
extern uint8_t io_pio_control;

extern uint8_t io_pio_ide_lsb;
extern uint8_t io_pio_ide_msb;
extern uint8_t io_pio_ide_ctl;
extern uint8_t io_pio_ide_config;

#else

__sfr __at __IO_DIO_PORT    io_dio;

__sfr __at __IO_SYSTEM      io_system;
__sfr __at __IO_LED_OUTPUT  io_led_output;
__sfr __at __IO_LED_STATUS  io_led_status;

__sfr __at __IO_CF_PORT     io_cf_port;

__sfr __at __IO_PIO_PORT_A  io_pio_port_a;
__sfr __at __IO_PIO_PORT_B  io_pio_port_b;
__sfr __at __IO_PIO_PORT_C  io_pio_port_c;
__sfr __at __IO_PIO_CONTROL io_pio_control;

__sfr __at __IO_PIO_IDE_LSB    io_pio_ide_lsb;
__sfr __at __IO_PIO_IDE_MSB    io_pio_ide_msb;
__sfr __at __IO_PIO_IDE_CTL    io_pio_ide_ctl;
__sfr __at __IO_PIO_IDE_CONFIG io_pio_ide_config;

#endif /* !__ARCH_SCZ180_H__ */

#endif
