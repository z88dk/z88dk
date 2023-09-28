#ifndef ARCH_COLECO_H
#define ARCH_COLECO_H

#include <stdint.h>

// Access to the buffers that are used by OS7
//
// Configure the size using the following pragmas:
//
// -pragma-define:CRT_COLECO_SPRITE_NAME_SIZE=nn
// -pragma-define:CRT_COLECO_SPRITE_ORDER_SIZE=nn
// -pragma-define:CRT_COLECO_BIOS_BUFFER_SIZE=nn
// -pragma-define:CRT_COLECO_BIOS_CONTROLLER_SIZE=nn
//
extern uint8_t  os7_sprite_order_table[];
extern uint8_t  os7_sprite_name_table[];
extern uint8_t  os7_bios_buffer[];
extern uint8_t  os7_bios_controller[];

#endif
