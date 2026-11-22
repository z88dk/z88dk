#ifndef __ARCH_APPLE2_H__
#define __ARCH_APPLE2_H__

#include <sys/compiler.h>


//////////////////////////
//   Video interface
//////////////////////////

// CP/M screen functions, use a2_ctl(x);
// They can be modified or disabled with the CONFIGIO program

extern void __LIB__ a2_ctl(int chr)  __z88dk_fastcall;

#define TEXT_CLRHOME  1    // Clear Screen
#define TEXT_CLREND   2    // Clear to End of Page
#define TEXT_CLREOL   3    // Clear to End of Line
#define TEXT_NORMAL   4    // Set Normal Text Mode
#define TEXT_INVERSE  5    // Set Inverse (highlight) Text Mode
#define TEXT_HOME     6    // Home Cursor
#define TEXT_CURPOS   7    // Set Cursor Position (see gotoxy_callee.asm)
#define TEXT_CURUP    8    // Move Cursor Up
#define TEXT_CURFWD   9    // Non-destructevly Move Cursor Forward


// Send a character (direct BIOS access)
extern void __LIB__ a2_sendchar(int chr)  __z88dk_fastcall;


// MACROS to toggle the video hardware modes

// Examples to properly deal with the 80 columns card:
//
// TEXT40, PAGE1
//      M_TEXT; M_PAGE1; M_SNG_RES;
//
// TEXT80, PAGE2
//      M_TEXT; M_PAGE2; M_DBL_RES; M_DBL_PAGE2;
//
// HIRES40 mixed with  TEXT40, PAGE1
//      M_GRAPHICS; M_MIXED; M_PAGE1; M_HI_RES; M_DBL_MIXED; M_SNG_RES;
//
// HIRES80, no mix, PAGE1
//      M_GRAPHICS; M_FULL; M_HI_RES; M_DBL_FULL; M_DBL_PAGE1; M_DBL_RES;
//
// LORES40, mixed with TEXT80, PAGE2
//      M_GRAPHICS; M_MIXED; M_PAGE2; M_LO_RES; M_DBL_MIXED; M_DBL_PAGE2; M_DBL_RES;

// Display a GAPHICS page
#define M_GRAPHICS asm("ld\t(0xE050),a\n");
// Display a TEXT page
#define M_TEXT asm("ld\t(0xE051),a\n");

// Display a full GRAPHICS or TEXT page (disable MIXED)
#define M_FULL asm("ld\t(0xE052),a\n");
// Display a mixed page with text at bottom
#define M_MIXED asm("ld\t(0xE053),a\n");

// Low resolution graphics mode
#define M_LO_RES asm("ld\t(0xE056),a\n");
// High resolution graphics mode
#define M_HI_RES asm("ld\t(0xE057),a\n");

// Display the primary TEXT or GRAPHICS page ($0400 or $2000)
#define M_PAGE1 asm("ld\t(0xE054),a\n");
// Display the secondary TEXT or GRAPHICS page ($0800 or $4000)
#define M_PAGE2 asm("ld\t(0xE055),a\n");

// 80 columns or double resolution
// -------------------------------

// 80STORE OFF (disable page2 SCAN)
#define M_DBL_PAGE1 asm("ld\ta,(0xE001)\n");
// 80STORE ON (enable page2 SCAN)
#define M_DBL_PAGE2 asm("ld\ta,(0xE000)\n");

// Single resolution (text and graphics 80COL OFF - no double res)
#define M_SNG_RES asm("ld\ta,(0xE00C)\n");
// Double resolution (text or graphics 80COL mode)
#define M_DBL_RES asm("ld\ta,(0xE00D)");

// AN3 OFF (disable double and low resolution mixing)
#define M_DBL_FULL asm("ld\t(0xE05E),a\n");
// AN3 ON  (enable hires "delayed", mix with text or lorez)
#define M_DBL_MIXED asm("ld\t(0xE05F),a\n");



//////////////////////////
//   Apple II specific
//////////////////////////

// Get the current slot number in use by the Z80 SoftCard
// If the detection fails, -1 is reported
extern void __LIB__ z80_slot();


// Invoke the Rockwell 6502
extern void __LIB__ r6502(int addr)  __z88dk_fastcall;


/* Functions (bank $00 entry points) */

#define A2_PLOT        0xF800   // Put a Lo-Rez pixel (block)
#define A2_PLOT1       0xF80E   // (alternate entry point in PLOT)
#define A2_HLINE       0xF819   // Draw a horizontal line in Lo-Rez
#define A2_VLINE       0xF828   // Draw a verictal line in Lo-Rez
#define A2_CLRSCR      0xF832   // Clear the Lo-Rez display to black
#define A2_CLRTOP      0xF836   // Clear only the top 40 lines in Lo-Rez
#define A2_GBASCALC    0xF847   // Calculate a Lo-Rez plot position
#define A2_NXTCOL      0xF85F   // Add 3 to the current Lo-Rez color setting
#define A2_SETCOL      0xF864   // Set the color for Lo-Rez graphics mode
#define A2_SCRN        0xF871   // Determine the color of a Lo-Rez pixel (A = block color)
#define A2_INSDS1      0xF882   // Print the monitor's current PC (program counter)
#define A2_INSDS2      0xF88E   // Calculate length of 6502 instruction in A
#define A2_INSDS816    0xF890   // (Apple II GS) Calculate length of 65816 instruction..
#define A2_INSTDSP     0xF8D0   // Display one disassembled instruction at the PC
#define A2_PRNTYX      0xF940   // Print X and Y in hexadecimal to COUT
#define A2_PRNTAX      0xF941   // Print A and X in hexadecimal to COUT
#define A2_PRNTX       0xF944   // Print X in hexadecimal to COUT
#define A2_PRBLNK      0xF948   // Print 3 spaces to COUT
#define A2_PRBL2       0xF94A   // Print X spaces to COUT
#define A2_PCADJ       0xF953   // Adjust monitor's program counter (PC)
#define A2_TEXT2COPY   0xF962   // Manipulate shadowing of text page 2
#define A2_OLDIRQ      0xFA40   // Save registers and call interrupt handler (NEWIRQ)
#define A2_BREAK       0xFA4C   // Save registers and jump through the BRK vector ($03F0)
#define A2_OLDBRK      0xFA59   // Prints address of BRK instruction and all regs
#define A2_RESET       0xFA62   // Reset key handler
#define A2_PWRUP       0xFAA6   // Reboot the computer
#define A2_SLOOP       0xFABA   // Search the slots for a bootable device
#define A2_REGDSP      0xFAD7   // Display the A, X, Y and system registers
#define A2_PREAD       0xFB1E   // Return paddle X value (0 to 3) in Y register
#define A2_PREAD4      0xFB21   // (alternate entry point in PREAD
#define A2_SETTXT1     0xFB2F   // Init text mode entry used by GBASIC
#define A2_SETTXT      0xFB39   // Set text mode and a full width text window
#define A2_SETGR       0xFB40   // Set Lo-Rez graphics mode
#define A2_SETWND      0xFB4B   // Set the text window determined by zero page bounds
#define A2_SETWND2     0xFB51   // (alternate entry point in SETWND)
#define A2_TABV        0xFB5B   // Tab to the screen row in the A reguster
#define A2_APPLEII     0xFB60   // Display the Apple II banner (e.g. "Apple IIGS")
#define A2_SETPWRC     0xFB6F   // Calculate reset vector's power-up complement
#define A2_VIDWAIT     0xFB78   // Check for a Ctrl-S key when $8D is printed
#define A2_KBDWAIT     0xFB88   // Wait for a keypress, then print it
#define A2_BASCALC     0xFBC1   // Determine cursor's address in video RAM
#define A2_BELL1       0xFBDD   // Beep the speaker for .1 seconds at 1Khz
#define A2_BELL1_2     0xFBE2   // Beep the speaker
#define A2_BELL2       0xFBE4   // Beep the speaker
#define A2_STORADV     0xFBF0   // Print A register to screen at the base index
#define A2_ADVANCE     0xFBF4   // Increment the cursor's position
#define A2_VIDOUT      0xF8FD   // Print A register to screen, with format control
#define A2_BS          0xFC10   // Move cursor left (backspace)
#define A2_UP          0xFC1A   // Move cursor up
#define A2_VTAB        0xFC22   // Tab to row given in location $25
#define A2_VTABZ       0xFC24   // Tab to row given in accumulator
#define A2_CLREOP      0xFC42   // Clear screen from cursor to end of page
#define A2_HOME        0xFC58   // Clear screen and home cursor
#define A2_CR          0xFC62   // Perform a carriage return and linefeed
#define A2_LF          0xFC66   // Perform a linefeed only
#define A2_SCROLL      0xFC70   // Scroll screen up one line
#define A2_CLREOL      0xFC9C   // Clear from cursor to end of line
#define A2_CLEOLZ      0xFC9E   // Clear from the base index plus Y to end of line
#define A2_WAIT        0xFCA8   // Wait 13+(11*A)+(5*A*A) microseconds
#define A2_NXTA4       0xFCB4   // 16bit increment of location $42/$43
#define A2_NXTA1       0xFCBA   // 16bit compare of $3C/$3D with $3E/$3F
#define A2_RDKEY       0xFD0C   // Show cursor, get keypress, return A in register
#define A2_FD10        0xFD10   // Get keypress, return in A register
#define A2_RDKEY1      0xFD18   // Jump to vector at $38/$39, return keypress in A
#define A2_KEYIN       0xFD1B   // Standard low-level keypress input handler
#define A2_RDCHAR      0xFD35   // Read keyboard and perform Escape-key commands
#define A2_GETLNZ      0xFD67   // Perform a carriage return and fall into GETLN
#define A2_GETLN       0xFD6A   // Load A register with character at $33, fall into GETLN0
#define A2_GETLN0      0xFD6C   // Display character in A register, fall into GETLN1
#define A2_GETLN1      0xFD6F   // Get a line of input
#define A2_CROUT1      0xFD8B   // Clear to end of line and perform a carriage return
#define A2_CROUT       0xFD8E   // Send a carriage return to COUT
#define A2_PRA1        0xFD92   // Call CROUT and print $3C/$3D in hexadecimal
#define A2_PRBYTE      0xFDDA   // Print accumulator in hexadecimal
#define A2_PRHEX       0xFDE3   // Print lower 4 bits of accumulator in hexadecimal
#define A2_COUT        0xFDED   // Send accumulator to vector at $36/$37
#define A2_COUT1       0xFDF0   // Print character to screen with format control
#define A2_COUTZ       0xFDF0   // Print character to screen, ignoring inverse video
#define A2_IDROUTINE   0xFE1F   // Determine machine type and system information
#define A2_MOVE        0xFE2C   // Move a block of memory
#define A2_SETINV      0xFE80   // Set inverse video mode
#define A2_SETNORM     0xFE84   // Set normal video mode
#define A2_SETKBD      0xFE89   // Reset standard input vectors to the keyboard
#define A2_INPORT      0xFE8B   // Reset input to the slot determined by the A register
#define A2_SETVID      0xFE93   // Reset standard output vectors to the screen
#define A2_OUTPORT     0xFE95   // Reset output to the slot determined by the A register
#define A2_GO          0xFEB6   // Run instructions at address pointed by $3C/$3D
#define A2_PRERR       0xFF2D   // Print ERR to COUT, fall into BELL
#define A2_BELL        0xFF3A   // Load accumulator with $87 (CTRL-G) and call COUT
#define A2_IOREST      0xFF3F   // Restore processor registers (a.k.a. RESTORE)
#define A2_IOSAVE      0xFF4A   // Save processor registers (a.k.a. SAVE)
#define A2_IORTS       0xFF58   // Do nothing (just a known RTS instruction)
#define A2_OLDRST      0xFF59   // Old entry for the monitor
#define A2_MON         0xFF65   // Enter the monitor with a bell tone
#define A2_MONZ        0xFF69   // Enter the monitor, reset registers storage area
#define A2_MONZ2       0xFF6C   // Enter the monitor, leave registers storage area intact
#define A2_MONZ4       0xFF70   // Same as MONZ2, but does not display the * prompt
#define A2_DIG         0xFF8A   // Put hex version of A register into $3E/$3F, branch to  NXTCHR
#define A2_GETNUM      0xFFA7   // Convert hex input to 16bit value, fall into NXTCHR
#define A2_NXTCHR      0xFFAD   // Parse input buffer characters
#define A2_ZMODE       0xFFC7   // Zero monitor's MODE flag


#endif
