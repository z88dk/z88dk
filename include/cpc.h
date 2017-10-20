/*
 * Headerfile for Amstrad CPC specific functions
 *
 * $Id: cpc.h,v 1.5 2016-05-20 20:24:52 dom Exp $
 */

#ifndef __CPC_H__
#define __CPC_H__

#include <sys/compiler.h>
#include <sys/types.h>

///////////////////////////////////////////
// DIAGNOSTICS AND HARDWARE IDENTIFICATION
///////////////////////////////////////////

// FDC detection (0-none, 1-Amstrad, 2-Vortex)
extern int  __LIB__ cpc_fdc(void);

// CPC model detection (0-464, 1-664, 2-6128)
extern int  __LIB__ cpc_model(void);


///////////////////////////////////////////
// KEYBOARD FUNCTIONS
///////////////////////////////////////////

extern char  __LIB__  cpc_AnyKeyPressed(void);
extern char  __LIB__  cpc_TestKey(unsigned char key)  __z88dk_fastcall;
extern char  __LIB__  cpc_TestKeyF(unsigned char key)  __z88dk_fastcall;
extern void  __LIB__  cpc_DeleteKeys(void);
extern char  __LIB__  cpc_RedefineKey(unsigned char key)  __z88dk_fastcall;

extern void __LIB__              cpc_AssignKey(unsigned char key, int value) __smallc ;
void __LIB__    cpc_AssignKey_callee(unsigned char key, int value)  __smallc __z88dk_callee;
#define cpc_AssignKey(a,b) cpc_AssignKey_callee(a,b)

///////////////////////////////////////////
// VIDEO RELATED FUNCTIONS
///////////////////////////////////////////

// Set video mode via Firmware
extern int __LIB__  cpc_setmode(int) __z88dk_fastcall;
extern int __LIB__  cpc_SetModo(int) __z88dk_fastcall;

// Switch video mode directly
extern int __LIB__  cpc_SetMode(int) __z88dk_fastcall;

// Set CPC color for a specified pen (set color in a palette element)
extern void __LIB__              cpc_set_palette(int pen, int color) __smallc ;
void __LIB__    cpc_set_palette_callee(int pen, int color)  __smallc __z88dk_callee;
extern void __LIB__              cpc_SetInk(int pen, int color) __smallc ;
void __LIB__    cpc_SetInk_callee(int pen, int color)  __smallc __z88dk_callee;
#define cpc_SetInk(a,b) cpc_SetInk_callee(a,b)
#define cpc_set_palette(a,b) cpc_set_palette_callee(a,b)

// Set CPC color
extern void __LIB__              cpc_SetColour(int pos, int color) __smallc ;
void __LIB__    cpc_SetColour_callee(int pos, int color)  __smallc __z88dk_callee;
#define cpc_SetColour(a,b) cpc_cpc_SetColour_callee(a,b)

// Set Border Color
extern void  __LIB__  cpc_SetBorder(int color) __z88dk_fastcall;

// Print to direct screen address
extern void __LIB__              cpc_PrintGphStrStd(int pen, char *, unsigned int address) __smallc ;
void __LIB__    cpc_PrintGphStrStd_callee(int pen, char *, unsigned int address)  __smallc __z88dk_callee;
#define cpc_PrintGphStrStd(a,b,c) cpc_PrintGphStrStd_callee(a,b,c)

// Print at x,y
extern void __LIB__              cpc_PrintGphStrStdXY(int pen, char *, int x, int y) __smallc ;
void __LIB__    cpc_PrintGphStrStdXY_callee(int pen, char *, int x, int y)  __smallc __z88dk_callee;
#define cpc_PrintGphStrStdXY(a,b,c,d) cpc_PrintGphStrStdXY_callee(a,b,c,d)

// Rotate left region
extern void __LIB__              cpc_RLI(unsigned int pos, unsigned char w, unsigned char h) __smallc ;
void __LIB__    cpc_RLI_callee(unsigned int pos, unsigned char w, unsigned char h)  __smallc __z88dk_callee;
#define cpc_RLI(a,b,c) cpc_RLI_callee(a,b,c)

// Rotate left region
extern void __LIB__              cpc_RRI(unsigned int pos, unsigned char w, unsigned char h) __smallc ;
void __LIB__    cpc_RRI_callee(unsigned int pos, unsigned char w, unsigned char h)  __smallc __z88dk_callee;
#define cpc_RRI(a,b,c) cpc_RRI_callee(a,b,c)

// Clear Screen
extern void   __LIB__   	cpc_ClrScr(void);

// Print String using firmware
extern char  __LIB__  cpc_PrintStr(char *cadena)  __z88dk_fastcall;

// Set Sprite position
extern void __LIB__              cpc_SpUpdX(int sprite, char x) __smallc ;
void __LIB__    cpc_SpUpdX_callee(int sprite, char x)  __smallc __z88dk_callee;
#define cpc_SpUpdX(a,b,c) cpc_SpUpdX_callee(a,b,c)
extern void __LIB__              cpc_SpUpdY(int sprite, char y) __smallc ;
void __LIB__    cpc_SpUpdY_callee(int sprite, char y)  __smallc __z88dk_callee;
#define cpc_SpUpdY(a,b,c) cpc_SpUpdY_callee(a,b,c)

// Update Screen
extern void  __LIB__		cpc_UpdScr(void);



///////////////////////////////////////////
// MISC FUNCTIONS
///////////////////////////////////////////

// (old way) Enable/Disable firmware: forcefully modify interrupts to jump to nothing
extern void   __LIB__   	cpc_DisableFirmware(void);
extern void   __LIB__   	cpc_EnableFirmware(void);

// Tiny ROM based console gets implementation
extern int __LIB__ cpc_gets(char *s);

// Copies a string to a CPC RSX compatible one
extern char __LIB__  *cpc_rsx_str(char *str) __z88dk_fastcall;    // (malloc lib is required)

extern char __LIB__              *cpc_rsx_strcpy(char *, char *) __smallc ;
extern char __LIB__    *cpc_rsx_strcpy_callee(char *, char *)  __smallc __z88dk_callee;
#define cpc_rsx_strcpy(a,b) cpc_rsx_strcpy_callee(a,b)

// Data decompression, PUcrunch format
extern char __LIB__              *cpc_Uncrunch(char *, char *) __smallc ;
extern char __LIB__    *cpc_Uncrunch_callee(char *, char *)  __smallc __z88dk_callee;
#define cpc_Uncrunch(a,b) cpc_Uncrunch_callee(a,b)

// Call RSX/Bar command
extern int __LIB__ cpc_rsx(char *cmd,...);

// RSX return error codes
#define RSX_NOT_FOUND	-1

#define RSX_NOT_OPEN	0x0E	// file not open as expected
#define RSX_HARD_EOF	0x0F	// hard end of file
#define RSX_SOFT_EOF	0x1A	// soft end of file
#define RSX_BAD_CMD	0x10	// bad command, usually wrong filename
#define RSX_FILE_EXIST	0x11	// file already exists
#define RSX_FILE_NOT_FOUND	0x12	// file doesn't exist
#define RSX_DIR_FULL	0x13	// directory is full
#define RSX_DISK_FULL	0x14	// disc is full
#define RSX_DISK_CHANGE	0x15	// disk has been changed with files open on it
#define RSX_READ_ONLY	0x16	// file is read-only

// RSX bitwise coded return error codes
#define RSX_HARD_ERR	64
#define RSX_HE_CRC	32	// data error - CRC err. on data or ID field
#define RSX_HE_OVERRUN	16	// overrun error
#define RSX_HE_NOTREADY	8	// drive not ready - no disk in drive
#define RSX_HE_NOSECTOR	4	// no data - can't find sector
#define RSX_HE_WPROTECT	2	// not writable - wr protected
#define RSX_HE_NOMARK	1	// address mark missing


// Hide/Show BIOS error messages
extern void  __LIB__  bios_msg(int flag) __z88dk_fastcall;

#define MSG_ENABLE	0
#define MSG_DISABLE	255

#endif
