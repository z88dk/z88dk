/* Simple latch mode0 implementation for i8255 */

#include "ticks.h"
#include <stdio.h>

struct i8255 {
    uint8_t porta;
    uint8_t portb;
    uint8_t portc;
    uint8_t control;
    uint8_t (*input)(struct i8255 *dev, uint8_t port);
    void (*output)(struct i8255 *dev, uint8_t port, uint8_t val);
};

#define I8255_CONTROL_PORT_C_LOWER_INPUT  0x01
#define I8255_CONTROL_PORT_B_INPUT        0x02
#define I8255_CONTROL_PORT_C_UPPER_INPUT  0x08
#define I8255_CONTROL_PORT_A_INPUT        0x10
#define I8255_CONTROL_MODE_SET            0x80




uint8_t i8255_read(struct i8255 *dev, uint8_t addr)
{
    uint8_t t;

    switch ( addr & 3 ) {
    case 0:
        if ( dev->control & I8255_CONTROL_PORT_A_INPUT) {
            if (dev->input) return dev->input(dev, 0);
            return 0xff;
        }
        return dev->porta;
    case 1:
        if ( dev->control & I8255_CONTROL_PORT_B_INPUT) {
            if (dev->input) return dev->input(dev, 1);
            return 0xff;
        }
        return dev->portb;
    case 2:
        t = dev->input ? dev->input(dev, 2) : 0xff;
        if ( dev->control & I8255_CONTROL_PORT_C_UPPER_INPUT) {
            t &= 0x0f;
            t |= dev->portc & 0xf0;
        }
        if ( dev->control & I8255_CONTROL_PORT_C_LOWER_INPUT) {
            t &= 0xf0;
            t |= dev->portc & 0x0f;
        }
        return t;
    case 3:
        return dev->control;
    }
    return 0xff;
}


void i8255_write(struct i8255 *dev, uint8_t addr, uint8_t val)
{
    uint8_t t;

    switch ( addr & 3 ) {
    case 0:
        dev->porta = val;
        if ( dev->output && (dev->control & I8255_CONTROL_PORT_A_INPUT) == 0 ) dev->output(dev, 0, val);
        break;
    case 1:
        dev->portb = val;
        if ( dev->output && (dev->control & I8255_CONTROL_PORT_B_INPUT) == 0 ) dev->output(dev, 1, val);
        break;
    case 2:
        dev->portc = val;
        t = val;
        if ( (dev->control & (I8255_CONTROL_PORT_C_LOWER_INPUT|I8255_CONTROL_PORT_C_UPPER_INPUT)) == (I8255_CONTROL_PORT_C_LOWER_INPUT|I8255_CONTROL_PORT_C_UPPER_INPUT)) {
            return;
        }
        if ( dev->control & I8255_CONTROL_PORT_C_LOWER_INPUT ) t |= 0x0f;
        if ( dev->control & I8255_CONTROL_PORT_C_UPPER_INPUT ) t |= 0xf0;
        if ( dev->control & (I8255_CONTROL_PORT_C_LOWER_INPUT|I8255_CONTROL_PORT_C_UPPER_INPUT) && dev->output ) dev->output(dev, 2, val);
        break;
    case 3:
        if ( val & I8255_CONTROL_MODE_SET ) {
            if ( val & I8255_CONTROL_PORT_A_INPUT ) dev->porta = 0;
            if ( val & I8255_CONTROL_PORT_B_INPUT ) dev->portb = 0;
            if ( val & I8255_CONTROL_PORT_C_LOWER_INPUT ) dev->portc &= 0x0f;
            if ( val & I8255_CONTROL_PORT_C_UPPER_INPUT ) dev->portc &= 0xf0;
        }
        break;
    }
    return;
}

void i8255_reset(struct i8255 *dev)
{
    dev->control = 0x9B;        // Input mode completely
    i8255_write(dev, 0, 0xff);
    i8255_write(dev, 1, 0xff);
    i8255_write(dev, 2, 0xff);
}

struct i8255 *i8255_create(
      uint8_t (*input)(struct i8255 *dev, uint8_t port),
      void (*output)(struct i8255 *dev, uint8_t port, uint8_t val))
{
    struct i8255 *dev = calloc(1,sizeof(*dev));

    if ( dev == NULL ) {
        fprintf(stderr, "Out of memory - can't create i8255\n");
        exit(1);
    }
    dev->input = input;
    dev->output = output;
    i8255_reset(dev);

    return dev;
}

void i8255_free(struct i8255 *dev)
{
    free(dev);
}

