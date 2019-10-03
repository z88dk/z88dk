include(__link__.m4)

#ifndef __I2C_H__
#define __I2C_H__

#include <arch.h>
#include <stdint.h>
#include <stddef.h>

// Defines

#define I2C1_PORT   __IO_I2C1_PORT_MSB
#define I2C2_PORT   __IO_I2C2_PORT_MSB

#define I2C_CON_ECHO_BUS_STOPPED    __IO_I2C_CON_ECHO_BUS_STOPPED
#define I2C_CON_ECHO_BUS_RESTART    __IO_I2C_CON_ECHO_BUS_RESTART
#define I2C_CON_ECHO_BUS_ILLEGAL    __IO_I2C_CON_ECHO_BUS_ILLEGAL

#define I2C_RESTART_ENABLE          0
#define I2C_RESTART                 I2C_RESTART_ENABLE
#define I2C_RESTART_DISABLE         1
#define I2C_STOP                    I2C_RESTART_DISABLE

// Data Structures

typedef enum {
    I2C_SPEED_STD           = 0,
    I2C_SPEED_FAST          = 1,
    I2C_SPEED_FAST_PLUS     = 2,
    I2C_SPEED_TURBO         = 3
} i2c_speed_mode;

// Functions

// Interrupt routines for the I2C interfaces: Byte Mode
extern void i2c1_byte_isr(void);
extern void i2c2_byte_isr(void);

// Interrupt routines for the I2C interfaces: Buffer Mode
extern void i2c1_buffer_isr(void);   // TODO
extern void i2c2_buffer_isr(void);   // TODO

// void i2c_reset( uint8_t device ) __z88dk_fastcall
__DPROTO(`d,e,h,l,iyh,iyl',`d,e,h,l,iyh,iyl',void,,i2c_reset,uint8_t device)

// void i2c_initialise( uint8_t device ) __z88dk_fastcall
__DPROTO(`d,e,h,l,iyh,iyl',`d,e,h,l,iyh,iyl',void,,i2c_initialise,uint8_t device)

// void i2c_set_speed_mode( uint8_t device, enum i2c_speed_mode ) __z88dk_callee
__DPROTO(`d,e,iyh,iyl',`d,e,iyh,iyl',void,,i2c_set_speed_mode,uint8_t device,i2c_speed_mode speed_mode)

// void i2c_interrupt_attach( uint8_t device, void *isr ) __z88dk_callee
__DPROTO(`d,e,iyh,iyl',`d,e,iyh,iyl',void,,i2c_interrupt_attach,uint8_t device,void *isr)

// void i2c_write_byte( uint8_t device, uint8_t addr, uint8_t *dp, uint8_t length, uint8_t stop );
__DPROTO(`iyh,iyl',`iyh,iyl',void,,i2c_write_byte,uint8_t device,uint8_t addr,uint8_t *dp,uint8_t length,uint8_t stop)

// void i2c_read_byte_set( uint8_t device, uint8_t addr, uint8_t *dp, uint8_t length, uint8_t stop );
__DPROTO(`iyh,iyl',`iyh,iyl',void,,i2c_read_byte_set,uint8_t device,uint8_t addr,uint8_t *dp,uint8_t length,uint8_t stop)

// uint8_t i2c_read_byte_get( uint8_t device, uint8_t addr, uint8_t length );
__DPROTO(`iyh,iyl',`iyh,iyl',uint8_t,,i2c_read_byte_get,uint8_t device,uint8_t addr,uint8_t length)

#endif
