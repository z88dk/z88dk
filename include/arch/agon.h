
#ifndef __ARCH_AGON_H
#define __ARCH_AGON_H

#include <sys/compiler.h>
#include <stdint.h>

// Set a palette
// If paletted mode (i.e. < 64) 
//   - If physical < 64 use that entry as the logical collur
//   - If physical = 255, set the actual colour using r,g,b
// 
__ZPROTO5(void,,agon_set_palette,uint8_t,logical,uint8_t,physical,uint8_t,r, uint8_t,g, uint8_t,b)


__ZPROTO(void,,agon_set_cursor_state,uint8_t,enabled,uint8_t)



#endif
