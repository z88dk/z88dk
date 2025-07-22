#ifndef __ARCH_APPLE2_H__
#define __ARCH_APPLE2_H__


//////////////////////////
//   Video interface
//////////////////////////

// CP/M screen functions, use a2_ctl(x);
// They can be modified or disabled with the CONFIGIO program

#define A2_CLRHOME  1    // Clear Screen
#define A2_CLREND   2    // Clear to End of Page
#define A2_CLREOL   3    // Clear to End of Line
#define A2_NORMAL   4    // Set Normal Text Mode
#define A2_INVERSE  5    // Set Inverse (highlight) Text Mode
#define A2_HOME     6    // Home Cursor
#define A2_CURPOS   7    // Set Cursor Position (see gotoxy_callee.asm)
#define A2_CURUP    8    // Move Cursor Up
#define A2_CURFWD   9    // Non-destructevly Move Cursor Forward

extern void __LIB__ a2_ctl(int chr)  __z88dk_fastcall;


// Send a character (direct BIOS access)
extern void __LIB__ a2_sendchar(int chr)  __z88dk_fastcall;

  
#endif
