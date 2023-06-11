#ifndef __MZ_H__
#define __MZ_H__

#include <sys/compiler.h>
#include <sys/types.h>


// Works on later models only (MZ-700, MZ-800, MZ-1500)

extern void __LIB__  mz_border(char colour) __z88dk_fastcall;


/*
   MZ800 video modes. 
   
   Valid values, with 16K VRAM are 0 (320x200x4) and 4 (640x200x1), single frame.
   With 32K, the options are:
     0 - 320x200x4 (Frame A)
	 1 - 320x200x4 (Frame B)
	 2 - 320x200x16
	 
	 4 - 640x200x1 (Frame A)
	 5 - 640x200x1 (Frame B)
     6 - 640x200x4
	 
	 8 - MZ-700 text mode (40x25, 8 colors)
*/

// Set video mode on MZ800
extern void __LIB__  set_mz800_vmode() __z88dk_fastcall;

// Read current MZ800 video mode register value
extern int __LIB__  get_mz800_vmode();

// Wait VSYNC
extern void __LIB__  mz800_vsync();



////////////
// MACROS
////////////

// Beep
#define MZ_BELL()    asm("call\t0x3E\n");

// Play music (monitor 1A-013A)
#define MZ_MELDY(music) asm("ld\thl,"#music"\ncall\t0x30\n");

// Set the musical tempo (1..7  -> slow..fast)
#define MZ_XTEMP(tempo) asm("ld\ta,"#tempo"\ncall\t0x41\n");


////////////
// TAPE I/O
////////////

// MZ tape file types:
// 01 machine code program file
// 02 MZ-80 BASIC program file
// 03 MZ-80 data file
// 04 MZ-700 data file
// 05 MZ-700 BASIC program file

// The tape header is loaded into the monitor's work area starting at address $10F0 in the length of 128 bytes.

struct mztapehdr {             // standard tape header
   unsigned char type;
   char          name[17];     // file name (end = $0D)
   size_t        length;
   size_t        address;
   size_t        exec;         // execution address of a program file
   char          comment[104];
};


extern struct  mztapehdr mz_hdr;


extern int  __LIB__  tape_save(char *name, size_t loadstart,void *start,void *exec,size_t len) __smallc;
extern int  __LIB__  tape_save_block(void *addr, size_t len, unsigned char type) __smallc;
extern int  __LIB__  tape_load_block(void *addr, size_t len, unsigned char type) __smallc;

extern int  __LIB__  mztape_save_header(void *addr, size_t len) __smallc;
extern int  __LIB__  mztape_load_header(void *addr, size_t len) __smallc;
extern int  __LIB__  mztape_save_block(void *addr, size_t len) __smallc;
extern int  __LIB__  mztape_load_block(void *addr, size_t len) __smallc;
// Start/stop the tape motor (1:ON, 2:OFF)
extern void  __LIB__  mztape_motor(int cmd) __z88dk_fastcall;

extern int  __LIB__  mztape_save_header_callee(void *addr, size_t len) __smallc __z88dk_callee;
extern int  __LIB__  mztape_load_header_callee(void *addr, size_t len) __smallc __z88dk_callee;
extern int  __LIB__  mztape_save_block_callee(void *addr, size_t len) __smallc __z88dk_callee;
extern int  __LIB__  mztape_load_block_callee(void *addr, size_t len) __smallc __z88dk_callee;

#define mztape_save_header(a,b) mztape_save_header_callee(a,b)
#define mztape_load_header(a,b) mztape_load_header_callee(a,b)
#define mztape_save_block(a,b) mztape_save_block_callee(a,b)
#define mztape_load_block(a,b) mztape_load_block_callee(a,b)


#endif
