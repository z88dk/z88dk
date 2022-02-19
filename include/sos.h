/*
 *      S-O low level support
 *
 *      Stefano Bodrato - 2013
 *
 *	$Id: sos.h $
 */


#ifndef __SOS_H__
#define __SOS_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <fcntl.h>

extern unsigned int   SOS_COLD;
extern unsigned int   SOS_HOT;
extern unsigned int   SOS_USR;
extern unsigned char  SOS_DVSW;
extern unsigned char  SOS_LPSW;
extern unsigned int   SOS_PRCNT;
extern unsigned char *SOS_XYADR;
extern unsigned char  SOS_XADR;
extern unsigned char  SOS_YADR;
extern unsigned int   SOS_KBFAD;
extern unsigned int   SOS_IBFAD;
extern unsigned int   SOS_SIZE;
extern unsigned int   SOS_DTADR;
extern unsigned int   SOS_EXADR;
extern unsigned int   SOS_STKAD;
extern unsigned int   SOS_MEMAX;
extern unsigned int   SOS_WKSIZ;
extern unsigned char  SOS_DIRNO;
extern unsigned char  SOS_MXTRK;
extern unsigned int   SOS_DTBUF;
extern unsigned int   SOS_FATBF;
extern unsigned int   SOS_DIRPS;
extern unsigned int   SOS_FATPS;
extern unsigned char  SOS_DSK;
extern unsigned char  SOS_WIDTH;
extern unsigned char  SOS_MXLIN;

// For positioning the text cursor.  The macros can be
// used to inline code if the parameters resolve to constants.

#define M_SOS_GOTOXY(xpos,ypos) __asm__("ld\tl,"#xpos"\nld\th,"#ypos"\ncall\t$201E\n");

// Set console cursor position, top-left=(0;0)
extern void  __LIB__              setcursorpos(int x, int y) __smallc;
extern void  __LIB__    setcursorpos_callee(int x, int y) __smallc __z88dk_callee;
#define setcursorpos(a,b)     setcursorpos_callee(a,b)

// Get character at given position, top-left=(0;0)
extern int  __LIB__              screen(int x, int y) __smallc;
extern int  __LIB__    screen_callee(int x, int y) __smallc __z88dk_callee;
#define screen(a,b)     screen_callee(a,b)

// Set screen size (if possible)
extern int  __LIB__   width(int columns) __z88dk_fastcall;

// Print the error message for the given code
extern int  __LIB__   print_error(int err_code) __z88dk_fastcall;

#define SOS_ERR_DEV_IO            1
#define SOS_ERR_DEV_OFFLINE       2
#define SOS_ERR_FILE_DESCRIPTOR   3
#define SOS_ERR_WR_PROTECTED      4
#define SOS_ERR_BAD_RECORD        5
#define SOS_ERR_FILE_MODE         6
#define SOS_ERR_ALLOCATION_TABLE  7
#define SOS_ERR_FILE_NOT_FOUND    8
#define SOS_ERR_DEVICE_FULL       9
#define SOS_ERR_FILE_EXISTS      10
#define SOS_ERR_RESERVED         11
#define SOS_ERR_FILE_NOT_OPEN    12
#define SOS_ERR_SYNTAX           13
#define SOS_ERR_BAD_DATA         14

// Enable/disable echo on printer
extern void  __LIB__ lpton();
extern void  __LIB__ lptoff();

// Test for BREAK being pressed
extern int  __LIB__ break_key(void);

// Set console cursor position, top-left=(0;0)
extern void  __LIB__              setcursorpos(int x, int y) __smallc;
extern void  __LIB__    setcursorpos_callee(int x, int y) __smallc __z88dk_callee;
#define setcursorpos(a,b)     setcursorpos_callee(a,b)

// Get cursor position
extern int  __LIB__     get_cursor_x();
extern int  __LIB__     get_cursor_y();

// Set file name and type
extern void  __LIB__              sos_file(char *name, int attributes) __smallc;
extern void  __LIB__    sos_file_callee(char *name, int attributes) __smallc __z88dk_callee;
#define sos_file(a,b)     sos_file_callee(a,b)

#define SOS_FILEATTR_BIN    0x01
#define SOS_FILEATTR_BAS    0x02
#define SOS_FILEATTR_ASC    0x04
#define SOS_FILEATTR_DIR    0x80

// Open the file for reading/writing (false on error)
extern int  __LIB__       sos_ropen();
extern int  __LIB__       sos_wopen();

// Actually read/write the data block
extern int  __LIB__       sos_wrd();
extern int  __LIB__       sos_rdd();

// Block transfer for both tape and disk, work on current device (set in SOS_DSK)
extern int  __LIB__            tape_save(char *name, size_t loadstart,void *start, size_t len) __smallc;
extern int  __LIB__            tape_save_block(void *addr, size_t len, unsigned char type) __smallc;
extern int  __LIB__            tape_load(char *name, size_t loadstart,void *start, size_t len) __smallc;
extern int  __LIB__            tape_load_block(void *addr, size_t len, unsigned char type) __smallc;

// Get S-OS version: model ID
extern int  __LIB__     get_sos_model();
extern int  __LIB__     get_sos_version();

#define SOS_VER_SWORD 0x20



#endif /* __SOS_H__ */
