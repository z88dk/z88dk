/*
 *      S-O low level support
 *
 *      Stefano Bodrato - 2013
 *
 *	$Id: sos.h,v 1.1 2013-11-29 14:34:02 stefano Exp $
 */


#ifndef __SOS_H__
#define __SOS_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <fcntl.h>

extern unsigned int   SOS_USR   @0x1f7e;	// Address to jump to after a cold start.
extern unsigned char  SOS_DVSW  @0x1f7d;	// Tape format.
extern unsigned char  SOS_LPSW  @0x1f7c;	// If non-zero, output also to the printer.
extern unsigned int   SOS_PRCNT @0x1f7a;	// Number of characters displayed in a new line.
extern unsigned int   SOS_XYADR @0x1f78;	// Cursor coordinates.
extern unsigned char  SOS_XADR  @0x1f78;
extern unsigned char  SOS_YADR  @0x1f79;
extern unsigned int   SOS_KBFAD @0x1f76;	// Keyboard input buffer address.
extern unsigned int   SOS_IBFAD @0x1f74;	// File Control Block position.
extern unsigned int   SOS_SIZE  @0x1f72;	// File size.
extern unsigned int   SOS_DTADR @0x1f70;	// File start address.
extern unsigned int   SOS_EXADR @0x1f6e;	// File exec address (program entry point).
extern unsigned int   SOS_STKAD @0x1f6c;	// Initial value of STACK.
extern unsigned int   SOS_MEMEX @0x1f6a;	// User area upper limit (z88dk moves the SP here).
extern unsigned int   SOS_WKSIZ @0x1f68;	// Size of special work area.
extern unsigned char  SOS_DIRNO @0x1f67;	// Current file number.
extern unsigned char  SOS_MXTRK @0x1f66;	// The maximum number of tracks.
extern unsigned int   SOS_DTBUF @0x1f64;	// Disk read buffer PTR (256 bytes long area).
extern unsigned int   SOS_FATBF @0x1f62;	// FAT read buffer PTR (256 bytes long area).
extern unsigned int   SOS_DIRPS @0x1f60;	// Directory start position (track / sector).
extern unsigned int   SOS_FATPS @0x1f5e;	// FAT start position (track / sector).
extern unsigned char  SOS_DSK   @0x1f5d;	// Current device name.
extern unsigned char  SOS_WIDTH @0x1f5c;	// Display size (columns).
extern unsigned char  SOS_MXLIN @0x1f5b;	// Display size (lines).



#endif /* __SOS_H__ */
