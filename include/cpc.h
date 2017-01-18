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
// MISC FUNCTIONS
///////////////////////////////////////////

// Switch mode
extern int __LIB__  cpc_setmode(int) __z88dk_fastcall;
// Tiny ROM based console gets implementation
extern int __LIB__ cpc_gets(char *s);

// Copies a string to a CPC RSX compatible one
extern char __LIB__  *cpc_rsx_str(char *str) __z88dk_fastcall;    // (malloc lib is required)
extern char __LIB__              *cpc_rsx_strcpy(char *, char *) __smallc ;
extern char __LIB__    *cpc_rsx_strcpy_callee(char *, char *)  __smallc __z88dk_callee;

#define cpc_rsx_strcpy(a,b) cpc_rsx_strcpy_callee(a,b)

// Call RSX/Bar command
extern int __LIB__ cpc_rsx(char *cmd,...);

// RSX return error codes
#define RSX_NOT_FOUND	-1

#define RSX_NOT_OPEN	0x0E	// file not open as expected
#define RSX_HARD_EOF	0x0F	// hard end of file
#define RSX_SOFT_EOF	0x1A	// soft end of file
#define RSX_BAD_CMD	0x10	// bad command, usually wrong filename
#define RSX_FILE_EXIST	0x11	// file already exists
#define RSX_NOT_FOUND	0x12	// file doesn't exist
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
