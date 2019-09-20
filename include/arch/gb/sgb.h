/** @file gb/sgb.h
    Super Gameboy definitions.
*/
#ifndef _SGB_H
#define _SGB_H

#include <sys/types.h>
#include <sys/compiler.h>
#include <stdint.h>

/** Return a non-null value if running on Super GameBoy */
uint8_t __LIB__ sgb_check(void);

#endif /* _SGB_H */
