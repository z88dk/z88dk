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
#include <stdio.h>

// constants
#define TVC_CHAR_RETURN 0x0D
#define TVC_CHAR_ESC    0x1B

enum video_mode {VMODE_2C=0x00, VMODE_4C=0x01, VMODE_16C=0x02};

#define CGREEN   0x01
#define CRED     0x04
#define CBLUE    0x10
#define CINTENSE 0x40

enum colors {black  = 0x00, green   = 0x01, red     = 0x04, purple = 0x05,
             blue   = 0x10, cyan    = 0x11, yellow  = 0x14, grey   = 0x15,
             lgreen = 0x41, lred    = 0x44, lpurple = 0x45, lblue  = 0x50,
             lcyan  = 0x51, lyellow = 0x54, white   = 0x55};

// TVC Editor functions
/**
 * Gets a string from the console using TVC's screen editor
 */
char *tvc_fgets_cons(char* str, size_t max);

/**
 * Starts the editor and gets a character on pressing enter (func $A1)
 */
char __LIB__ tvc_ed_getch();

/**
 * Before editor's CHIN this method fixes the character position
 * from where the ccharcters are returned. (func $A4)
 */
void __LIB__ tvc_ed_cfix();

/**
 * Sets the current character position of the editor (1,1) is upper left
 * (16/32/64, 24) is the lower right, depending on the actual resolution
 * returns 0xF6 in case of invalid position provided (func $A3)
 */
void __LIB__ tvc_ed_cpos(char col, char row);

/**
 * Prints one character to the console from the actual
 * character position (func $A4)
 */
#define tvc_ed_chout     fputc_cons_native
char __LIB__ fputc_cons_native(int character);


// TVC Keyboard functions

/**
 * Get a character from the console. If there is no pressed char
 * earlier this call will block (func $A1)
 */
#define tvc_kbd_chin     fgetc_cons
int __LIB__ fgetc_cons();


/**
 * Checks if a key was pressed earlier or not
 */
int __LIB__ tvc_kbd_status();

/**
 * Gets a character from the console. If there is no pressed char
 * earlier this call returns 0x00.
 */
#define tvc_getkey getk

// screen, video functions

/**
 * Clears the screen and sets the cursors to their base position
 * (editor cursor to the upper left, graphic cursor to the lower left)
 */
void __LIB__ tvc_cls(void);

/**
 * Sets the video mode of TVC (2 colours, 4 colours, 16 colours), clears screen
 * and initialize cursor positions.
 */
int __LIB__ tvc_vmode(enum video_mode mode);

/**
  * Returns the border color.
 */
enum colors tvc_get_border();

void tvc_set_border(enum colors c);

#define tvc_set_paper(X) {tvc_set_palette(X, 0); char *p; p = (char *)0x0B4E; *p=X;}
void __LIB__ tvc_set_palette(enum colors, int palette_index);

#endif
