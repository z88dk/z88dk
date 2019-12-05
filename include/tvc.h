/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2019
 *
 *  Headerfile for TVC specific stuff
 *
 */

#ifndef __TVC_H__
#define __TVC_H__

#include <sys/types.h>

// constants
#define TVC_CHAR_RETURN 0x0D
#define TVC_CHAR_ESC    0x1B

// TVC Editor functions
/**
 * Gets a string from the console using TVC's screen editor
 */
char *tvc_fgets_cons(char* str, size_t max);

/**
 * Starts the editor and gets a character on pressing enter (func $A1)
 */
#define tvc_ed_chin    asm_tvc_ed_getch
extern char __LIB__ asm_tvc_ed_getch();

/**
 * Before editor's CHIN this method fixes the character position
 * from where the ccharcters are returned. (func $A4)
 */
#define tvc_ed_cfix     asm_tvc_ed_cfix
extern void __LIB__ asm_tvc_ed_cfix();

/**
 * Sets the current character position of the editor (1,1) is upper left
 * (16/32/64, 24) is the lower right, depending on the actual resolution
 * returns 0xF6 in case of invalid position provided (func $A3)
 */
#define tvc_ed_cpos     asm_tvc_ed_cpos
extern void __LIB__ asm_tvc_ed_cpos(char col, char row);

/**
 * Prints one character to the console from the actual
 * character position (func $A4)
 */
#define tvc_ed_chout     fputc_cons_native
extern char __LIB__ fputc_cons_native(int character);


// TVC Keyboard functions

/**
 * Get a character from the console. If there is no pressed char
 * earlier this call will block (func $A1)
 */
#define tvc_kbd_chin     fgetc_cons
extern int __LIB__ fgetc_cons();


/**
 * Checks if a key was pressed earlier or not
 */
#define tvc_keyboard_status asm_tvc_kbd_status
extern int __LIB__ asm_tvc_kbd_status();

/**
 * Gets a character from the console. If there is no pressed char
 * earlier this call returns 0x00.
 */
#define tvc_getkey getk
extern int __LIB__ getk();



#endif
