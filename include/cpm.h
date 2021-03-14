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

/* If you want fileio to support devices then link with -lcpmdevice.
 * This adds the following devices: CON: RDR: PUN: LST: without this
 * library an optimised driver saves memory and
 * permits to specify the user area in filenames, i.e.  "0/c:file.ext"
 */
 

/* Size of CPM Sector */
#define SECSIZE  128

/* Flags for fcp->use */
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
    unsigned long rwptr;    /* read/write pointer in bytes */
    u8_t    use;            /* use flag */
    u8_t    uid;            /* user id belonging to this file */
    u8_t    mode;           /* TEXT/BINARY discrimination */
};

struct sfcb {
    u8_t    drive;          /* drive code */
    char    name[8];        /* file name */
    char    ext[3];         /* file type */
    u8_t    pwdmode;        /* Password mode (0=no pwd): bit 7-Read, bit 6-Write, bit 4-Delete */
    char    filler[10];     /* not used */
	int 	c_date;			/* Create or Access date/time (depends on settings) */
	u8_t	c_hours;
	u8_t	c_minutes;
	int 	date;			/* Update date/time (days since January 1, 1978) */
	u8_t	hours;
	u8_t	minutes;
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
extern char __LIB__ *dir_get_entry_name();
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



/***************************/
/* GSX graphics extensions */
/***************************/

/* GIOS parameter block structure */
struct GSX_PB {
	void *control;    /* Addr of control array */
	void *intin;      /* Addr of integer input array */
	void *ptsin;      /* Addr of pixel input array */
	void *intout;     /* Addr of integer input array */
	void *ptsout;     /* Addr of pixel input array */
};


/* GSX functions */
#define GSX_OPEN       1      /* Open workstation, n_intin=0 */
#define GSX_CLOSE      2      /* Close workstation, n_intin=0 */
#define GSX_CLEAR      3      /* Clear picture, n_intin=0 */
#define GSX_OUTPUT     4      /* Output graphics, n_intin=0 */

#define GSX_ESC        5      /* Special function entered via ESC code */

#define GSX_POLYLINE   6      /* Draw a polyline, n_ptsin=number of points */
#define GSX_MARKERS    7      /* Plot a group of markers, n_ptsin=number of markers */
#define GSX_TEXT       8      /* Draw text, n_ptsin=1, n_intin=characters number */
#define GSX_POLYGON    9      /* Draw a filled polygon, n_ptsin=vertices number */
#define GSX_COLORS     10     /* Output colour index array, n_ptsin=2 */

#define GSX_DRAW       11     /* General drawing primitive */

#define GSX_T_SZ       12     /* Set text size, n_ptsin=1 */
#define GSX_T_D        13     /* Set text direction, n_intin=3 */
#define GSX_PALETTE    14     /* Set colour index (palette registers), n_intin=4 */
#define GSX_L_STYLE    15     /* Set line style, n_intin=1 */
#define GSX_L_WIDTH    16     /* Set line width, n_ptsin=1 */
#define GSX_L_COLOR    17     /* Set line colour, n_intin=1 */
#define GSX_M_TYPE     18     /* Set marker type, n_intin=1 */
#define GSX_M_HEIGHT   19     /* Set marker height, n_ptsin=1 */
#define GSX_M_COLOR    20     /* Set marker colour, n_intin=1 */
#define GSX_T_FONT     21     /* Set text font, n_intin=1 */
#define GSX_T_COLOR    22     /* Set text colour, n_intin=1 */
#define GSX_F_STYLE    23     /* Set fill style, n_intin=1 (0=transparent, 1=solid, 2=pattern, 3=hatch) */
#define GSX_F_INDEX    24     /* Set fill index, n_intin=1 used only with styles 2 & 3*/
#define GSX_F_COLOR    25     /* Set fill colour, n_intin=1 */
#define GSX_GETPALETTE 26     /* Read palette, n_intin=2 */
#define GSX_CELLARRAY  27     /* Inquire cell array, n_ptsin=2, n_intin=max length of colour index array */
#define GSX_GETMOUSEXY 28     /* Get coordinates where mouse or tablet key was pressed, n_ptsin=1, n_intin=1 */
#define GSX_GETVALU    29     /* Read valuator. In request mode: n_intin=2, in samplemode, n_intin=1 */
#define GSX_CHOICE     30     /* Read choice, n_intin=1 */
#define GSX_GETSTRING  31     /* Read string. In request mode: n_intin=3, in samplemode, n_intin=2 */
#define GSX_WRTMODE    32     /* Set writing mode, n_intin=1 */
#define GSX_INPUTMODE  33     /* Set input mode, n_intin=2 */


/* GSX_ESCAPE related */
#define ESC_GT_SIZE     1    /* Get text screen size in characters */
#define ESC_GRAPHICS    2    /* Enter in graphics mode */
#define ESC_TEXT        3    /* Enter in text mode */
#define ESC_CUR_UP      4    /* Text cursor up */
#define ESC_CUR_DOWN    5    /* Text cursor down */
#define ESC_CUR_LEFT    6    /* Text cursor left */
#define ESC_CUR_RIGHT   7    /* Text cursor right */
#define ESC_CLS         8    /* Clear text screen */
#define ESC_C_BOTTOM    9    /* Clear text from cursor to end of screen */
#define ESC_C_EOL       10   /* Clear text from cursor to end of line */
#define ESC_SETXY       11   /* Move text cursor to coordinates given in "intin" */
#define ESC_PRINT       12   /* Print (to text screen), 16bit-characters text in "intin" */
#define ESC_INVERSE     13   /* Select reverse video */
#define ESC_TRUE        14   /* Cancel reverse video */
#define ESC_GETXY       15   /* Return the coordinates of the text cursor in "intout" */
#define ESC_MOUSE       16   /* Do we have a mouse or a tablet? 1/0 in "intout" */
#define ESC_COPY        17   /* Send a screen hardcopy to the printer */
#define ESC_MOUSE_XY    18   /* Place mouse, enter with n_ptsin=1 */
#define ESC_MOUSE_OFF   19   /* Remove the graphic cursor */


/* GSX_DRAW related */
#define DRAW_BAR        1    /* Draw filled bar, n_ptsin=2, ptsin = diagonally opposite corners */
#define DRAW_ARC        2    /* Draw arc, n_ptsin=4, n_intin=2 */
#define DRAW_PIESLICE   3    /* Draw pie slice,as for arc */
#define DRAW_CIRCLE     4    /* Draw circle n_ptsin=3, ptsin=centre, a point and (radius,0) */
#define DRAW_TEXT       5    /* Draw text, n_ptsin=1, n_intin=no.chars, ptsin=coordinates, intin=16bit-characters */


struct GSX_CTL {
	int	fn;         /* GSX function, 1-33 */
	int	n_ptsin;    /* number of pts in ptsin */
	int	n_ptsout;   /* number of pts in ptsout */
	int	n_intin;    /* number of pts in intin */
	int	n_intout;   /* number of pts in intin */
	int	xctrl;      /* for special uses */
};


/* GSX GIOS Parameter block */
extern struct GSX_PB gios_pb;

/* GSX GIOS Control block */
extern struct GSX_CTL gios_ctl;



#endif
