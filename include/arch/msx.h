

#ifndef __ARCH_MSX_H
#define __ARCH_MSX_H


/* asmlib by Konamiman */
#include <arch/msx/asm.h>

/* Contains a mapping of logical banks to physical pages
 * 
 * - Logical banks are those banks labeled with #pragma bank
 * - Physical pages are allocated by the MSX memory mapper
 *
 * Exposing this information allows named address spaces to
 * work on the MSX.
 */
extern uint8_t _msx_bank_mapping[256];

#endif
