#ifndef __CPM_H__
#define __CPM_H__

/*
 *    CPM Specific Header File
 *
 *    Many of these values have been obtained via reference to
 *    Hitech C
 *
 *    $Id: cpm.h,v 1.16 2016-11-03 09:25:26 stefano Exp $
 */

#include <sys/compiler.h>
#include <sys/types.h>

/* Maximum number of open files. If you want to change this then you
 * should recompile the CPM library and change the crt0 code to creat
 * enough space for the the FCBs */
#define MAXFILE  10

/* Whether we want fileio to support devices (default, no), if you
 * change it then recompile the library
 * the DEVICES flag adds the following filenames:  CON: RDR: PUN: LST:
 * When DEVICES is not set, an optimized driver helps saving memory and
 * permits to specify the user area in filenames, i.e.  "0/c:file.ext"
 */
 
#if 0
#define DEVICES
#endif

/* Size of CPM Sector */
#define SECSIZE  128

/* Falgs for fcp->use */
#define U_READ  1               /* file open for reading */
#define U_WRITE 2               /* file open for writing */
#define U_RDWR  3               /* open for read and write */
#define U_CON   4               /* device is console */
#define U_RDR   5               /* device is reader */
#define U_PUN   6               /* device is punch */
#define U_LST   7               /* list device */

#define __STDIO_EOFMARKER  26   /* End of file marker (^Z) */
#define __STDIO_BINARY     1    /* We should consider binary/text differences */
#define __STDIO_CRLF       1    /* Automatically convert between CR and CRLF */

struct fcb {
    u8_t    drive;          /* drive code */
    char    name[8];        /* file name */
    char    ext[3];         /* file type */
    u8_t    extent;         /* file extent */
    char    filler[2];      /* not used */
    char    records;        /* number of records in present extent */
    char    discmap[16];    /* CP/M disc map */
    char    next_record;    /* next record to read or write */
    u8_t    ranrec[3];      /* random record number (24 bit no. ) */
    /* Below here is used by the library */
    unsigned long    rwptr;          /* read/write pointer in bytes */
    u8_t    use;            /* use flag */
    u8_t    uid;            /* user id belonging to this file */
};

extern struct fcb  _fcb[MAXFILE];


/* BDOS calls */
#define CPM_RCON 1               /* read console */
#define CPM_WCON 2               /* write console */
#define CPM_RRDR 3               /* read reader */
#define CPM_WPUN 4               /* write punch */
#define CPM_WLST 5               /* write list */
#define CPM_DCIO 6               /* direct console I/O */
#define CPM_GIOB 7               /* get I/O byte */
#define CPM_SIOB 8               /* set I/O byte */
#define CPM_RCOB 10              /* read console buffered */
#define CPM_ICON 11              /* interrogate console ready */
#define CPM_VERS 12              /* return version number */
#define CPM_RDS  13              /* reset disk system */
#define CPM_LGIN 14              /* log in and select disk */
#define CPM_OPN  15              /* open file */
#define CPM_CLS  16              /* close file */
#define CPM_FFST 17              /* find first */
#define CPM_FNXT 18              /* find next */
#define CPM_DEL  19              /* delete file */
#define CPM_READ 20              /* read next record */
#define CPM_WRIT 21              /* write next record */
#define CPM_MAKE 22              /* create file */
#define CPM_REN  23              /* rename file */
#define CPM_ILOG 24              /* get bit map of logged in disks */
#define CPM_IDRV 25              /* interrogate drive number */
#define CPM_SDMA 26              /* set DMA address for i/o */
#define CPM_SUID 32              /* set/get user id */
#define CPM_RRAN 33              /* read random record */
#define CPM_WRAN 34              /* write random record */
#define CPM_CFS  35              /* compute file size */
#define CPM_DSEG 51              /* set DMA segment */


/* The CPM bdos call */
extern int __LIB__ bdos(int func,int arg) __smallc;
extern int __LIB__ bios(int func,int arg,int arg2) __smallc;


/* Get a free FCB */

extern struct fcb __LIB__ *getfcb(void);

/* Fill up the filename stuff */
extern int __LIB__ setfcb(struct fcb *fc, unsigned char *name) __smallc;
extern void __LIB__ parsefcb(struct fcb *fc, unsigned char *name) __smallc;
/* Write the file offset into the FCB */
extern void __LIB__ putoffset(char *dest, long val) __smallc;

/* Set/get userid */
#define setuid(u)  bdos(CPM_SUID,u)
#define getuid()   bdos(CPM_SUID,0xFF)

/* Write an offset as 3 bytes */
extern void __LIB__ _putoffset(unsigned char *where,long offset) __smallc;

/* Mark an FCB as being unused */
#define clearfcb(f)  (f)->use = 0

/*******************/
/* directory stuff */
/*******************/

extern struct fcb __LIB__ fc_dir;
extern char __LIB__ fc_dirpos;
extern char __LIB__ *fc_dirbuf;

/* Disk control (as for OSCA FLOS) */
extern int __LIB__  change_volume(int volume);
extern int __LIB__ get_current_volume();   // Current 'drive' (0..n)
/* Directory related commands (as for OSCA FLOS) */
extern int __LIB__ dir_move_first();
extern int __LIB__ dir_move_next();
extern int __LIB__ dir_get_entry_type();  // 0=normal, 1=directory
extern int __LIB__ dir_get_entry_name();
extern unsigned long __LIB__ dir_get_entry_size();
extern int __LIB__ get_dir_name();


/********************************/
/* Amstrad CP/M Plus extensions */
/********************************/

/* Enable/disable the bottom status line */
extern int __LIB__  a_statusline(int onoff);
/* Set keyboard speed */
extern int __LIB__ a_keyspeed(int delay, int repeat) __smallc;
/* Set border color, 6 bit color encoding, (or 8 bit if ULA256.FID is installed) */
extern int __LIB__  a_border(int color);
/* Set paper color, 6 bit color encoding, (OS patch needed or 8 bit if ULA256.FID is installed) */
extern int __LIB__  a_paper(int color);
/* Set ink color, 6 bit color encoding, (OS patch needed or 8 bit if ULA256.FID is installed) */
extern int __LIB__  a_ink(int color);
/* Get x cursor position in viewport */
extern int __LIB__ a_curx();
/* Get y cursor position in viewport */
extern int __LIB__ a_cury();

/* Get Machine */
extern int __LIB__ a_machine();
#define M_CPC        0    // CPC6128
#define M_PCW        1    // PCW8000/9000/10 series
#define M_SPECTRUM   3    // Spectrum +3
#define M_PCW16     65    // (65 = 'A', ie "Anne")

/* Get Machine HW version (or HW details on recent PCW versions) */
extern int __LIB__ a_machinever();
/* Get BIOS version */
extern int __LIB__ a_biosver();

/* Get system memory size */
extern int __LIB__ a_memsize();
/* 2 drives available ? */
extern int __LIB__ a_driveb();
/* Serial Port available ? */
extern int __LIB__ a_serialport();

#endif
