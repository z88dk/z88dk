#ifndef __SORCERER_H__
#define __SORCERER_H__

#include <sys/compiler.h>
#include <sys/types.h>


/* Things relevant to the C library */

//#define __STDIO_BINARY     1    /* We should consider binary/text differences */


// z88dk refers to base_graphics to find the "plot area"
extern void __LIB__ *getplot();


// Creates a standard inverse video character set
extern void __LIB__ invid();


// The Standard Exidy Monitor caller!
// Calling sequence is of the form:  x=monitor("SA IDIOT 100 2BFF 2");
extern int __LIB__ monitor(char *s) __z88dk_fastcall;


// Reads Standard Exidy tape file of name 'name' from tape 'unit' into address 'addr'.
extern int __LIB__ rtape(char *name, int unit, int addr) __smallc;


// Writes standard Exidy tape file of 'name' from address 'addr1' to address 'addr2' to tape 'unit'.
extern int __LIB__ wtape(char *name, int addr1, int addr2, int unit) __smallc;


// Reads standard Exidy tape as in 'rtape' but then chains to the execution address on the tape header.
extern void __LIB__ rtapeg(char *name, int unit, int addr) __smallc;


// z88dk "standard" API for tape stuff
#define tape_save(name, addr, len)  wtape(name, addr1, addr+len, 1)
extern int  __LIB__  tape_save_block(void *addr, size_t len, unsigned char type) __smallc;
extern int  __LIB__  tape_load_block(void *addr, size_t len, unsigned char type) __smallc;


// Fills the plot area from the string pointed to by s.
// The string is reused until the plot area is full.
// The address of the (0,0) position of the screen is returned.
extern int __LIB__ *fillplot(char *s) __z88dk_fastcall;


// If (mode==0) fills the plot area from the beginning of the current line to the cursor address.
//    else fills the plot area from the cursor address to the end of the current line.
// The string pointed to by s is used as many times
// as needed to fill the area.
// Returns the cursor address.
extern int __LIB__ linefill(int mode, char *s) __smallc;


// If (mode==0) fills from the beginning of the screen to the cursor.
//    else fills from the cursor to the end of the screen.
// The string pointed to by s is used as many times as required to fill.
// Returns the cursor address.
extern int __LIB__ fillcur(int mode, char *s) __smallc;


// If (opt==0) Fills a contiguous block of RAM starting at saddr and ending at eaddr with the string pointed to by "string".
//    else Fills a contiguous block of RAM starting at saddr of length eaddr bytes with the string pointed to.
extern char __LIB__ *srr_fill(int saddr,int eaddr,char *string,int opt) __smallc;


// if (mode==0) Fills memory from address a1 to address a2 (inclusive) with the byte c.
//    else Fills memory from address a1 for a2 bytes with byte c.
extern int __LIB__ srr_fillb(int a1, int a2, char c, int mode) __smallc;


// Used to generate tight status port loops
// If polarity is TRUE (non zero) then the routine returns when (PORT AND MASK) gives a ZERO result (ie when PORT and MASK have NO bits in common)
// If polarity is FALSE (zero) then the routine returns when (PORT AND MASK) gives a NON ZERO result (ie when PORT and MASK have SOME bits in common)
// The value returned is data input from the port.
extern int __LIB__ srr_wait(int port, int mask, int polarity) __smallc;


// Rotates the string (end around) pointed to by"s".
// If mode==0 then rotate LEFT, and
// if mode<>0 then rotate RIGHT.
// Returns the address of the string.
extern char __LIB__ *strrot(int mode,char *s) __smallc;


// Moves the cursor to position x (line), y (column) of the Sorcerer screen. (if possible)!
// Returns the offset from the beginning of the screen RAM of the new cursor position.
extern int __LIB__ cursor(int x, int y) __smallc;


// Removes the cursor from the screen.
// Returns the cursor address.
extern int __LIB__ remcur();


// Returns the Monitor Work Area address.
extern int __LIB__ mwa();


// Calls the Exidy Standard Monitor using the monitor command found at MWA.
// Returns 0 if illegal command (or no command) or 1 if command successfully executed.
// WARNING: This function may not return AT ALL if you crash it in the Monitor itself!
extern void __LIB__ exycall();


// Returns the 16 bit word P1 with HI and LO bytes swapped.
extern int __LIB__ swaphl(int p1) __z88dk_fastcall;



#endif
