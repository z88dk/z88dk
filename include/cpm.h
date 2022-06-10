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
#include <stdint.h>

/* Maximum number of open files. If you want to change this then you
 * compile your program with -pragma-define:CLIB_OPEN_MAX=xx
 */
#ifndef CLIB_OPEN_MAX
extern void *_CLIB_OPEN_MAX;
#define CLIB_OPEN_MAX &_CLIB_OPEN_MAX
#endif



#define MAXFILE CLIB_OPEN_MAX

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
    // 36 bytes of standard FCB
    uint8_t drive;          /* drive code */
    char    name[8];        /* file name */
    char    ext[3];         /* file type */
    uint8_t extent;         /* file extent */
    char    filler[2];      /* not used */
    char    records;        /* number of records in present extent */
    char    discmap[16];    /* CP/M disc map */
    char    next_record;    /* next record to read or write */
    uint8_t ranrec[3];      /* random record number (24 bit no. ) */
    

    /* Below here is used by the library */
    // 7 bytes used by the library
    unsigned long rwptr;    /* read/write pointer in bytes */
    uint8_t    use;            /* use flag */
    uint8_t    uid;            /* user id belonging to this file */
    uint8_t    mode;           /* TEXT/BINARY discrimination */

    // 133 bytes used for caching
    unsigned long cached_record;   /* Record number that we have cached */
    uint8_t    dirty;          /* Set if the buffer is dirty and needs writing to disc */
    uint8_t    buffer[SECSIZE];
};

struct sfcb {
    uint8_t    drive;       /* drive code */
    char    name[8];        /* file name */
    char    ext[3];         /* file type */
    uint8_t    pwdmode;     /* Password mode (0=no pwd): bit 7-Read, bit 6-Write, bit 4-Delete */
    char    filler[11];     /* not used */
    int 	c_date;			/* Create or Access date/time (depends on settings) */
    uint8_t	c_hours;        /* Hours and minutes are encoded as BCD */
    uint8_t	c_minutes;
    int 	date;			/* Update date/time (days since January 1, 1978) */
    uint8_t	hours;
    uint8_t	minutes;
};


extern struct fcb  _fcb[0];	// Has MAXFILES entries


/* DPB and DPH related functions will probably work on CP/M v2 only.
   block size, basing on BSH and BLM
                 1,024     3       7
                 2,048     4      15
                 4,096     5      31
                 8,192     6      63
                16,384     7     127
*/

struct dpb {
    int 	SPT;			/* "Sectors Per Track", total number of 128 bytes sectors per track */
    uint8_t BSH;            /* "Block Shift Factor", number of 128 bytes sectors per "Allocation Block" */
    uint8_t BLM;            /* "Block Mask", the values of BSH and BLM implicitly determine the data allocation size */
    uint8_t EXM;            /* "Extent Mask", number of extents per directory entry */
    int     DSM;            /* "Total storage capacity" of the disk drive (Number of the last Allocation Block) */
    int     DRM;            /* "Total # of directory entries" (-1) */
    uint8_t AL0;            /* Allocation table (MSB) */
    uint8_t AL1;            /* Allocation table (LSB) */
    int 	CKS;			/* "Check area Size", number of directory entries to check for disk change. */
    uint8_t OFF;            /* "Offset", number of system reserved tracks at the beginning of the disk */
};


extern struct dpb __LIB__  *get_dpb(int drive)  __z88dk_fastcall;


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
#define CPM_GSX 115              /* enter GSX */


/* The CPM bdos call */
extern int __LIB__ bdos(int func,int arg) __smallc;
extern int __LIB__ bios(int func,int arg,int arg2) __smallc;


/* Get a free FCB */

extern struct fcb __LIB__ *getfcb(void);

/* Internal caching calls */
extern int __LIB__ cpm_cache_get(struct fcb *fcb, unsigned long record_nr, int for_read);
extern int __LIB__ cpm_cache_flush(struct fcb *fcb);

/* Fill up the filename stuff */
extern int __LIB__ setfcb(struct fcb *fc, unsigned char *name) __smallc;
extern void __LIB__ parsefcb(struct fcb *fc, unsigned char *name) __smallc;
/* Write the file offset into the FCB */
extern void __LIB__ putoffset(char *dest, long val) __smallc;

/* Set/get userid */
#define setuid(u)  bdos(CPM_SUID,u)
#define getuid()   bdos(CPM_SUID,0xFF)

// Set the user number to requid, return the current one
extern int __LIB__ swapuid(int reqid) __z88dk_fastcall;

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



/****************************************************************/
/* GSX graphics extensions                                      */
/* After compiling, use GENGRAF.COM on the newly built COM file */
/****************************************************************/

/* GIOS parameter block structure */
struct GSX_PB {
	void *control;    /* Addr of control array */
	void *intin;      /* Addr of integer input array */
	void *ptsin;      /* Addr of pixel input array */
	void *intout;     /* Addr of integer input array */
	void *ptsout;     /* Addr of pixel input array */
};


struct GSX_CTL {
	int	fn;         /* GSX function, 1-33 */
	int	n_ptsin;    /* number of pts in ptsin */
	int	n_ptsout;   /* number of pts in ptsout */
	int	n_intin;    /* number of values in intin */
	int	n_intout;   /* number of values in intout */
	int	special;    /* for special uses (e.g. in-ESC functions) */
};


/* GSX functions */
#define GSX_OPEN       1      /* Open workstation, n_intin=10, n_ptsin=0 */
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

#define GSX_T_SIZE     12     /* Set text size, n_ptsin=1 */
#define GSX_T_ANGLE    13     /* Set text direction, n_intin=3 */
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


/* GSX_DRAW related */
#define DRAW_BAR        1    /* Draw filled bar, n_ptsin=2, ptsin = diagonally opposite corners */
#define DRAW_ARC        2    /* Draw arc, n_ptsin=4, n_intin=2 */
#define DRAW_PIESLICE   3    /* Draw pie slice,as for arc */
#define DRAW_CIRCLE     4    /* Draw circle n_ptsin=3, ptsin=centre, a point and (radius,0) */
#define DRAW_TEXT       5    /* Device specific output, n_ptsin=1, n_intin=no.chars, ptsin=coordinates, intin=16bit-characters */

/* Marker attributes */
#define M_PIX           0    /* Single pixel */
#define M_PLUS          1    /* '+' symbol */
#define M_ASTERISK      2    /* '*' symbol */
#define M_CIRCLE        3    /* 'O' symbol */
#define M_X             4    /* 'X' symbol */


/* GSX GIOS Parameter block */
extern struct GSX_PB gios_pb;

/* GSX GIOS Control block */
extern struct GSX_CTL gios_ctl;


/* GSX GIOS input value list */
extern int gios_intin[];

/* GSX GIOS input coordinate list */
extern int gios_ptsin[];

/* GSX GIOS reslut (values) */
extern int gios_intout[];

/* GSX GIOS reslut (coordinates) */
extern int gios_ptsout[];



/* Invoke a GSX function (setting the GIOS fn number) */
extern int  __LIB__   gios(int fn) __z88dk_fastcall;

/* Invoke an already set-up GSX function */
#define M_GSX() bdos(CPM_GSX,gios_pb)

/* Invoke a GSX function requiring one single parameter */
extern int __LIB__ gios_1pm(int fn, int parm) __smallc;
extern int __LIB__ gios_1pm_callee(int fn, int parm) __smallc __z88dk_callee;
#define gios_1pm(a,b) gios_1pm_callee(a,b)

/* Invoke a GSX function requiring 2 XY coordinates (4 values in 'ptsin') */
extern int __LIB__ gios_2px(int fn, int x1, int y1, int x2, int y2) __smallc;
extern int __LIB__ gios_2px_callee(int fn, int x1, int y1, int x2, int y2) __smallc __z88dk_callee;
#define gios_2px(f,a,b,c,d) gios_2px_callee(f,a,b,c,d)

/* Invoke a GSX function requiring 1 XY coordinate (2 values in 'ptsin') */
extern int __LIB__ gios_1px(int fn, int x1, int y1) __smallc;
extern int __LIB__ gios_1px_callee(int fn, int x1, int y1) __smallc __z88dk_callee;
#define gios_1px(f,a,b) gios_1px_callee(f,a,b)


/* GSX, load text parameter in 'intin' */
extern int  __LIB__   gios_text(const char *s) __z88dk_fastcall;

/* Print text 't' at x,y graphics coordinates */
#define gios_put_text(x,y,t) gios_text(t);gios_1px(GSX_TEXT,x,y)


/* Open graphics workstation (colour 1, solid styles) */
/* 'device_id' is defined in assign.sys, usually 1=screen, 21=printer */
#define gios_open(device_id) gios_ctl.n_ptsin=0;gios_ctl.n_intin=10;gios_intin[0]=device_id;gios_intin[2]=gios_intin[4]=gios_intin[6]=gios_intin[8]=gios_intin[9]=1;gios_intin[1]=gios_intin[3]=gios_intin[5]=gios_intin[7]=0;gios(GSX_OPEN);gios_ctl.n_intin=1;gios_intin[0]=0;gios(GSX_L_STYLE)

/* Close graphics workstation */
#define gios_close() gios_ctl.n_intin=0;gios(GSX_CLOSE)

/* Output graphics (update graphics workstation) */
#define gios_update() gios_ctl.n_intin=0;gios(GSX_OUTPUT)

/* Clear picture (hide cursor) */
#define gios_clg() gios_ctl.n_intin=0;gios(GSX_CLEAR)

/* GSX_WRTMODE related */
#define W_REPLACE       1
#define W_OVERSTRIKE    2
#define W_COMPLEMENT    3    /* XOR */
#define W_ERASE         4

/* Set writing mode */
#define gios_wmode(mode) gios_1pm(GSX_WRTMODE,mode)

/* Line style attributes */
#define L_SOLID         0    /* Normal line drawing */
#define L_DASH          1    /* Dashes */
#define L_DOT           2    /* Dotted line */
#define L_DASHDOT       3    /* Alterning dashes and dots */
#define L_LONGDASH      4    /* Long dashes */

/* Set line style */
#define gios_l_style(style) gios_1pm(GSX_L_STYLE,style)

/* Set line width */
#define gios_l_width(width) gios_1px(GSX_L_WIDTH,width,0)

/* Set line colour */
#define gios_l_color(color) gios_1pm(GSX_L_COLOR,color)

/* Fill attributes */
#define F_EMPTY         0    /* No fill (a.k.a. 'TRANSPARENT' or 'HOLLOW' */
#define F_FULL          1    /* Solid fill */
#define F_PATTERN       2    /* (also for 'HALFTONE') */
#define F_HATCH         3    /*  */

/* Set fill style */
#define gios_f_style(style) gios_1pm(GSX_F_STYLE,style)

/* Hatch types */
#define H_VERTICAL      0
#define H_HORIZONTAL    1
#define H_DEG45         2
#define H_DEG315        3
#define H_CROSS         4
#define H_X             5

/* Set fill index (e.g. hatch style) */
#define gios_f_index(style) gios_1pm(GSX_F_INDEX,style)

/* Default colors */
#define GSX_BLACK       0
#define GSX_RED         1
#define GSX_GREEN       2
#define GSX_BLUE        3
#define GSX_CYAN        4
#define GSX_YELLOW      5
#define GSX_MAGENTA     6
#define GSX_WHITE       7

/* Set fill color */
#define gios_f_color(color) gios_1pm(GSX_F_COLOR,color)

/* Draw a line */
#define gios_draw(x1,y1,x2,y2) gios_2px(GSX_POLYLINE,x1,y1,x2,y2)

/* Relative coord. drawing */
#define gios_drawr(x1,y1) gios_2px(GSX_POLYLINE,gios_ptsin[2],gios_ptsin[3],gios_ptsin[2]+x1,gios_ptsin[3]+y1)

/* Absolute coord. drawing */
#define gios_drawto(x1,y1) gios_2px(GSX_POLYLINE,gios_ptsin[2],gios_ptsin[3],x1,y1)

/* Draw a box */
#define gios_drawb(x1,y1,x2,y2) gios_ctl.special=DRAW_BAR;gios_2px(GSX_DRAW,x1,y1,x2,y2)

/* Plot a pixel */
#define gios_plot(x1,y1) gios_2px(GSX_POLYLINE,x1,y1,x1,y1)


/* Set marker type */
#define gios_m_type(type) gios_1pm(GSX_M_TYPE,type)

/* Set marker size */
#define gios_m_height(height) gios_1px(GSX_M_HEIGHT,0,height)

/* Set marker colour */
#define gios_m_color(color) gios_1pm(GSX_M_COLOR,color)


/* Set text font */
#define gios_t_font(font) gios_1pm(GSX_T_FONT,font)

/* Set text colour */
#define gios_t_colour(color) gios_1pm(GSX_T_COLOR,color)

/* Set text size */
#define gios_t_size(height) gios_1px(GSX_T_SIZE,0,height)


/* GSX_ESCAPE related: gios_esc(ESC_x) */
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

/* Invoke a special GSX function */
extern int  __LIB__   gios_esc(int esc_code) __z88dk_fastcall;

#endif
