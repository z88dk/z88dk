/** @file gb/console.h
    Console functions that work like Turbo C's.
    Note that the font is 8x8, making the screen 20x18 characters.
*/
#ifndef _CONSOLE_H
#define _CONSOLE_H

#include <sys/types.h>
#include <sys/compiler.h>

/** Move the cursor to an absolute position.
 */
void __LIB__ gotoxy(uint16_t x, uint16_t y) __smallc;

/** Get the current X position of the cursor.
 */
uint8_t __LIB__ posx(void);

/** Get the current Y position of the cursor.
 */
uint8_t __LIB__ posy(void);

/** Writes out a single character at the current cursor
    position.
    Does not update the cursor or interpret the character.
*/
void __LIB__ setchar(char c);

#endif /* _CONSOLE_H */
