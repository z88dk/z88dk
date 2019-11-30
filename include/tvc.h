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

// console
/**
 * Get a string from the console
 */
char *tvc_fgets_cons(char* str, size_t max);

/**
 * Starts the editor and gets a character on pressing enter ($A1)
 */
extern char __LIB__ asm_tvc_ed_getch();

/**
 * Before editor's CHIN this method fixes the character position 
 * from where the ccharcters are returned.
 */
extern void __LIB__ asm_tvc_ed_cfix();
// extern void __LIB__ tvc_gotoxy(uint8_t row, uint8_t col);
// extern bool __LIB__ tvc_iskeypressed();

/**
 * Get a character from the console. If there is no pressed earlier
 * this call will block
 */
#define tvc_fgetc_cons() fgetc_cons()



#endif
