/* Header for Heath/Zenith HDOS specific functions */

#ifndef ARCH_HDOS_H
#define ARCH_HDOS_H


#include <sys/compiler.h>
#include <sys/types.h>
#include <stdint.h>


// Get HDOS version
//
#define HDOS_VER_10 0x00
#define HDOS_VER_15 0x15
#define HDOS_VER_16 0x16
#define HDOS_VER_20 0x20
//
extern int __LIB__ hdos_ver(void);


// Clear console input buffer
//
#define hdos_clrco() asm("rst\t38h\ndefb\t7\n");


// Load HDOS overlay number
// on exit: !=0 if load error
//
extern int __LIB__ hdos_overlay(int ov) __z88dk_fastcall;


/* HDOS channels
 *
 *   -1   : special -- pre-opened on the running program file.
 *    0–5 : normal file/device channels.
 *
 *    In the fcntl library, range is 0..4 will be used for user files,
 *    #5 will be kept for internal use
 *
 */


////////////////////
// File management
//
// The file fucntions will return non-zero if an error occurs
// When no device or file extension is specified, the default values will be used
// The channel 'ch' is in the range -1..5 (the program itself is open on channel -1).


/* Maximum number of open files. If you want to change this then you
 * compile your program with -pragma-define:CLIB_OPEN_MAX=xx
 */
#ifndef CLIB_OPEN_MAX
extern void *_CLIB_OPEN_MAX;
#define CLIB_OPEN_MAX (int)&_CLIB_OPEN_MAX
#endif

#define MAXFILE CLIB_OPEN_MAX

/* Size of HDOS Sector */
#define SECSIZE  256

/* Flags for fcp->use */
#define U_READ  1               /* file open for reading */
#define U_WRITE 2               /* file open for writing */
#define U_RDWR  3               /* open for read and write */
#define U_CON   4               /* device is console */
// #define U_RDR   5               /* device is reader */
// #define U_PUN   6               /* device is punch */
// #define U_LST   7               /* list device */


struct fcb {
    // 19 bytes
    uint8_t    top[1];         /* reserved */
    uint8_t    device[2];      /* disk/device name (e.g. SY) */
    uint8_t    unit[1];        /* disk/device unit (e.g. SY1) */
    uint8_t    name[8];        /* file name */
    uint8_t    ext[3];         /* file type */
    uint8_t    bottom[4];      /* reserved */

    // 12 bytes used by the library
    uint8_t    ch;          /* HDOS channel in use */
    unsigned long rwptr;    /* read/write pointer in bytes */
    uint8_t    use;         /* use flag */
    uint8_t    mode;        /* TEXT/BINARY discrimination */
    uint8_t    rnr_dirty;   /* Set if the rwptr needs to be recalculatd */
    uint32_t   record_nr;   /* Record number that that rwptr refers to */ 

    // 256+5 bytes used for caching
    unsigned long cached_record;    /* Record number that we have cached */
    uint8_t    dirty;       /* Set if the buffer is dirty and needs writing to disc */
    uint8_t    buffer[SECSIZE];
};

extern struct fcb  _fcb[0]; /* Has MAXFILES entries */


/* Spot a free file pointer */
extern struct fcb __LIB__ *getfcb(void);

/* Internal caching calls */
extern int __LIB__ hdos_cache_get(struct fcb *fcb, unsigned long record_nr, int for_read);
extern int __LIB__ hdos_cache_flush(struct fcb *fcb);

/* Fill up the filename stuff */
extern int __LIB__ setfcb(struct fcb *fc, char *name) __smallc;
extern void __LIB__ parsefcb(struct fcb *fc, char *name) __smallc;



extern struct fcb __LIB__ *getfcb(void);
/* Fill up the filename stuff */
extern int __LIB__ setfcb(struct fcb *fc, char *name) __smallc;
extern void __LIB__ parsefcb(struct fcb *fc, char *name) __smallc;

/* Mark an FCB as being unused */
#define clearfcb(f)  (f)->use = 0

/* Write an offset as 3 bytes (when a 'long' type is ..just too long) */
extern void __LIB__ _putoffset(unsigned char *where,long offset) __smallc;

/*  **********************  */

// Default device and extension, set to "SY1TXT"
extern char *hdos_default;

// Rename HDOS file, doesn't check existence of files with the same newname
//
extern int __LIB__          hdos_rename(char *name, char *newname) __smallc;
extern int __LIB__   hdos_rename_callee(char *name, char *newname) __smallc __z88dk_callee;
#define hdos_rename(a,b) hdos_rename_callee(a,b)

// Delete HDOS file
//
extern int __LIB__          hdos_delete(char *name) __z88dk_fastcall;

// Change HDOS file attribute flags
//
#define F_HIDDEN    0x80    // "System hidden" attribute.  File won't appear in the directory listing.
#define F_LOCKED    0x40    // A "file lock" cannot be revoked
#define F_RDONLY    0x04    // If a file is "read only" and "locked" it cant be deleted or altered anymore
//
extern int __LIB__          hdos_chflg(char *name, int flags) __smallc;
extern int __LIB__   hdos_chflg_callee(char *name, int flags) __smallc __z88dk_callee;
#define hdos_chflg(a,b) hdos_chflg_callee(a,b)

// Decode a user specifie filespec
//
extern int __LIB__          hdos_decode(char *name, char *decoded) __smallc;
extern int __LIB__   hdos_decode_callee(char *name, char *decoded) __smallc __z88dk_callee;
#define hdos_decode(a,b) hdos_decode_callee(a,b)

// Open HDOS file for reading
//
extern int __LIB__          hdos_open_rd(char *name, int ch) __smallc;
extern int __LIB__   hdos_open_rd_callee(char *name, int ch) __smallc __z88dk_callee;
#define hdos_open_rd(a,b) hdos_open_rd_callee(a,b)

// Open HDOS file for writing
//
extern int __LIB__          hdos_open_wr(char *name, int ch) __smallc;
extern int __LIB__   hdos_open_wr_callee(char *name, int ch) __smallc __z88dk_callee;
#define hdos_open_wr(a,b) hdos_open_wr_callee(a,b)

// Reopen HDOS file for update (refer to the HDOS documentation)
//
extern int __LIB__          hdos_open_upd(char *name, int ch) __smallc;
extern int __LIB__   hdos_open_upd_callee(char *name, int ch) __smallc __z88dk_callee;
#define hdos_open_upd(a,b) hdos_open_upd_callee(a,b)

// This function goes through the sector chain in a file up to the desired sector count.
// If the total sectors are less than the requested position, the remainder will be provided on exit.
// To get the file length:  file_sectors = 65535-hdos_posit(ch,65535);
// 
extern uint16_t __LIB__          hdos_posit(int ch, uint16_t sec) __smallc;
extern uint16_t __LIB__   hdos_posit_callee(int ch, uint16_t sec) __smallc __z88dk_callee;
#define hdos_posit(a,b) hdos_posit_callee(a,b)

// Close HDOS file on the specified channel
//
extern int __LIB__          hdos_close(char *name) __z88dk_fastcall;

// Load bytes from the current sector of an open file channel
// Byte blocks must be multiple of 256 (LDB is ignored).
//
extern int __LIB__          hdos_read(int ch, uint16_t dataptr, int bytes) __smallc;
extern int __LIB__   hdos_read_callee(int ch, uint16_t dataptr, int bytes) __smallc __z88dk_callee;
#define hdos_read(a,b,c) hdos_read_callee(a,b,c)

// Save bytes on the current sector of an open file channel
// Byte blocks must be multiple of 256 (LDB is ignored).
//
extern int __LIB__          hdos_write(int ch, uint16_t dataptr, int bytes) __smallc;
extern int __LIB__   hdos_write_callee(int ch, uint16_t dataptr, int bytes) __smallc __z88dk_callee;
#define hdos_write(a,b,c) hdos_write_callee(a,b,c)



#endif
