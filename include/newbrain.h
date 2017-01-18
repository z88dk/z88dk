/*
 *      Grundy Newbrain specific functions
 *
 *      $Id: newbrain.h,v 1.12 2016-06-23 21:11:24 dom Exp $
 */

#ifndef __NEWBRAIN_H__
#define __NEWBRAIN_H__

#include <sys/compiler.h>
#include <sys/types.h>


/* structures for streams, devices, etc..*/

struct NB_STREAM {
        u8_t    stream;         /* stream number      */
        u8_t    driver;         /* driver number      */
        u8_t    port;           /* port number        */
        u8_t    unused;         /* unused             */
        u16_t   address;        /* own memory address */
};

struct NB_DRIVER {
        u8_t    entries;        /* Number of entry points less 1 */
        u8_t    openin;         /* open for input           -0-  */
        u8_t    openout;        /* open for output          -1-  */
        u8_t    dinput;         /* reads a byte from device -2-  */
        u8_t    doutput;        /* outputs a byte           -3-  */
        u8_t    dclose;         /* close the device         -4-  */
//        u8_t    move;           /* not always implemented   -5-  */
};

/* mewbrain "system variables" */

#define NB_TOPN         1       /* transfer for Z80 wakeup after power down */
#define NB_JOPN         2       /* jump location for Z80 wakeup after power down */
#define NB_B3PRM        4       /* lower bound of RAM allocation to user program */
#define NB_B4           6       /* upper bound +1 of RAM allocation to user program */
#define NB_TRST8        8       /* transfer for RST 8, used by maths and cassette */
#define NB_JRST8        9       /* jump location for RST 8 */
#define NB_DEV0         0x0B    /* default console device in BASIC */
#define NB_EXCESS       0x0C    /* for TV device driver */
#define NB_TV0          0x0D    /* for TV device driver - flash clock */
#define NB_TV2          0x0E    /* for TV device driver - cursor flags */
#define NB_TV1          0x0F    /* for TV device driver - character at cursor */
#define NB_TV1          0x0F    /* for TV device driver - character at cursor */
#define NB_TEXM         0x10    /* transfer for RST 16, user program intercept "call by name" */
#define NB_JEXM         0x11    /* jump location for RST 16 */
#define NB_DEV2         0x13    /* default store device (LOAD and SAVE, etc.. in BASIC) */
#define NB_SAVE2        0x14    /* IX save for communicating between IOS and user program */
#define NB_SAVE3        0x16    /* IY save for communicating between IOS and user program */
#define NB_TEXMNC       0x18    /* transfer for RST 24, user program intercept, "call no carry by name" */
#define NB_JEXMNC       0x19    /* jump location for RST 24 */
#define NB_PL1EN        0x1B    /* PRINT line length for TAB and POS in BASIC */
#define NB_PHPOS        0x1C    /* PRINT head position for TAB and POS in BASIC */
#define NB_PZLEN        0x1D    /* PRINT zone length TAB and POS in BASIC */
#define NB_SAVE1        0x1E    /* SP save for power down */
#define NB_TRST32       0x20    /* transfer for RST 32, use by OS intercept, "call by name" */
#define NB_JRST32       0x21    /* jump location for RST 32 */
#define NB_BRKBUF       0x23    /* used by break detection routines */
#define NB_ENREGMAP     0x24    /* last byte sent to enable port register */
#define NB_IOPUTC       0x25    /* I/O power user count */
#define NB_UP           0x26    /* user program address defaults to BASIC */
#define NB_TRST40       0x28    /* transfer for RST 40, use by OS intercept, "call no carry by name" */
#define NB_JRST40       0x29    /* jump location for RST 40 */
#define NB_KBMODE       0x2B    /* graphics and shift key lock status */
#define NB_GSPR         0x2C    /* user program make space routine address */
#define NB_RSPR         0x2E    /* user program return space routine address */
#define NB_TRST48       0x30    /* transfer for RST 48 */
#define NB_JRST48       0x31    /* jump location for RST 48 */
#define NB_BUFLG        0x33    /* when set indicates buffer in motion */
#define NB_DPSP         0x34    /* default parameter string pointer for device 0, */
                                /* initially points to string "L24" */
#define NB_DPSL         0x36    /* string length of DPSP */
#define NB_TINT         0x38    /* transfer for RST 56, mode 1 device interrupt service */
#define NB_JINT         0x39    /* jump location for RST 56 */
#define NB_COPCTL       0x3B    /* COP control, interrupt acknowledge byte written to COP */
                                /* in response to a COP interrupt */
#define NB_COPST        0x3C    /* COP status, set by COP interrupt service routine */
#define NB_COPBUFF      0x3D    /* data characters to COP */
#define NB_OUTBUFF      0x3E    /* VF display buffer (LCD) */
#define NB_TIMBUFF      0x40    /* COP internal counter value used to time the 1 minute power down interval */
#define NB_CHKSUM       0x50    /* tape transfer accumulated checksum */
#define NB_CLACK        0x52    /* count of COP interrupts */
#define NB_STRTAB       0x56    /* address of start of stream table */
#define NB_DEVTAB       0x58    /* address of start of device table */
#define NB_TVCUR        0x5A    /* address of cursor position */
#define NB_TVRAM        0x5C    /* start address of TV own memory */
#define NB_OTHER1       0x5E    /* reserved for driver which needs to mantain page zero memory.. */
#define NB_OTHER2       0x60    /* ..address variable if own memory moves */
#define NB_IOSRAM       0x62    /* address of device driver own memory area for streams */
#define NB_STRTOP       0x64    /* address of top of stream table */
#define NB_TNMI         0x66    /* transfer for NMI, (normally not used, NMI pin strapped high) */
#define NB_JNMI         0x67    /* jump location for NMI */
#define NB_FICLKM       0x69    /* frame interrupt counter, while video device is active */
#define NB_TBRP         0x6C    /* transmit baud rate parameter */
#define NB_RBRP         0x6D    /* receive baud rate parameter */

#define NB_CHAR_SET_LOCATION 0x77


/* device driver codes */

#define DEV_TVIO     0       /* screen editor, I/O                  */
#define DEV_TP1IO    1       /* primary tape device                 */
#define DEV_TP2IO    2       /* secondary tape device               */
#define DEV_LIIO     3       /* VF display, (LCD)              "16" */
#define DEV_TLIO     4       /* combined TL and VF display          */
#define DEV_KBWIO    5       /* keyboard, wait for a key            */
#define DEV_KBIIO    6       /* keyboard, immediate                 */
#define DEV_UPIO     7       /* User Port                           */
#define DEV_LPIO     8       /* most common printer device          */
#define DEV_JGIO     9       /* alias for software driven V24       */
#define DEV_DUMMY    10      /* similar to /dev/null                */
#define DEV_GRAPHICS 11      /* graphics device                     */
#define DEV_BDISCIO  12      /* disk binary file, sequential access */
#define DEV_TDISCIO  13      /* disk text file, sequential access   */
#define DEV_RDISCIO  14      /* disk binary file, random access     */
#define DEV_SDISCIO  15      /* disk directory access               */
#define DEV_LP2IO    16      /* printer, various hardware,   "l0*0" */
#define DEV_JG2IO    17      /* serial PUN/RDR, string,       "n*0" */
#define DEV_SSEIO    18      /* 80 columns simplified TTY device    */
#define DEV_KBFIO    19      /* enhanced fuffered keyboard driver   */
#define DEV_SMDD     20      /* Serial Memory Device: RAMDISK       */
#define DEV_LP3IO    21      /* less common printer device          */
#define DEV_HRG      33      /* high resolution graphics       "*0" */


/* IOS and generic ERRORS */

#define NB_ERR_NOROOM   100     /* Error code: no space for new stream */
#define NB_ERR_NOSTRM   105     /* Error code: no stream table entry   */
#define NB_ERR_NODEV    106     /* Error code: invalid device          */
#define NB_ERR_DEVOPN   107     /* Error code: device/port pair already open */
#define NB_ERR_STROPN   108     /* Error code: stream already open     */
#define NB_ERR_REQERR   109     /* Error code: illegal request code    */
                                /* i.e. attempt to read following an "open out" */

#define NB_ERR_PARAMETER        110     /* Syntax error in parameter string     */
#define NB_ERR_NOPOWER          111     /* Device without mains power connected */
#define NB_ERR_STREAM_CLOSED    115     /* Linked stream has been closed        */


/* GRAPHICS and screen device control errors */

#define NB_ERR_FILLMEM          112     /* Insufficient memory for FILL request */
#define NB_ERR_NOSCREEN         113     /* Linked stream is not a screen device */
#define NB_ERR_HEIGHT           114     /* No memory space for requested height */
#define NB_ERR_SCREEN_POS       116     /* Screen position illegal in context   */
#define NB_ERR_GRAPH_COMMAND    117     /* Invalid graph command or PEN parm.   */
#define NB_ERR_GRAPH_INPUT      118     /* Cannot input from graph dev. Use PEN */
#define NB_ERR_GRAPH_OUTPUT     119     /* Cannot output to graph while reading */


/* TAPE IO ERRORS  */

#define NB_ERR_TAPE_HARDWARE    130     /* Cassette hardware error */
#define NB_ERR_TAPE_LENGTH      131     /* Data block in tape too long for buffer */
#define NB_ERR_TAPE_CHECKSUM    132     /* Cassette checksum error */
#define NB_ERR_TAPE_EOF         133     /* End of file or hardware failure */
#define NB_ERR_TAPE_SEQUENCE    134     /* Data out of sequence or hardware failure */
#define NB_ERR_TAPE_MODE        135     /* Reading on a 'write' channel or vice versa */
#define NB_ERR_TAPE_SYNTAX      136     /* Syntax error in parameter string */

/* DISCIO ERRORS (normally for devices 12, 13, 14 or 15) */

#define NB_ERR_FILENAME         150     /* Bad filename */
#define NB_ERR_INPUT            151     /* Input error */
#define NB_ERR_OUTPUT           152     /* Output error */
#define NB_ERR_DIRECTORY        153     /* Directory error */
#define NB_ERR_INIT             154     /* Initialization error */
#define NB_ERR_TRANSACTION      155     /* Transaction error on dev 14 or 15 */
#define NB_ERR_NONZERO_PORT     156     /* Opening dev 15 with a non-zero port */
#define NB_ERR_FILENAME_LONG    157     /* Filename too long */
#define NB_ERR_TRANSACTION_TYPE 158     /* Transaction type error on dev 15 */
#define NB_ERR_RANDOM_TRANSPUT  159     /* Random transput error, beyond 8MB or zero pos. */

/* SMDD ERRORS (serial memory device driver) */

#define NB_ERR_SMDD_EOF         192     /* read past end of file */
#define NB_ERR_SMDD_NOROOM      193     /* insufficient memory to create object */
#define NB_ERR_SMDD_HLM         197     /* attempt to read past High Level Mark */
#define NB_ERR_SMDD_SAMEDIR     198     /* attempt to open 2nd directory with same name as an active one */

/* JGIO - ACIA drivers ERRORS */

#define NB_ERR_ACIA_SYNTAX      120     /* Syntax error in parameter string */
#define NB_ERR_ACIA_PORT        121     /* Port number different than zero for serial dev. */
#define NB_ERR_ACIA_TIMEOUT     200     /* Time out on serial input port */

#define NB_ERR_ACIA_BUFFER      206     /* ACIA buffer not available */
#define NB_ERR_ACIA_BUSY        207     /* ACIA or buffer already in use */
#define NB_ERR_ACIA_OUTPUT      208     /* ACIA not ready for output OR buffer full */
#define NB_ERR_ACIA_BUFFERED    209     /* Cannot use LP and V24 on EIM unless both are unbuffered */
#define NB_ERR_ACIA_INPUT       210     /* ACIA not ready for input OR buffer empty */
#define NB_ERR_ACIA_BAUD_RATE   211     /* Baud rates differ from ACIA aready open on same module */
#define NB_ERR_ACIA_BAUD_RANGE  212     /* Error 212 Cannot use baud rate over 19200 on EIM (early releases) */
#define NB_ERR_ACIA_N0          213     /* Cannot use protocol N for buffered operation - use N*0 */
#define NB_ERR_ACIA_BUFFER_NO   214     /* Illegal ACIA or buffer number */
#define NB_ERR_ACIA_BITS        215     /* Illegal combination of Data bits, Stop  bits, and parity */
#define NB_ERR_ACIA_FRAME       216     /* ACIA frame error */
#define NB_ERR_ACIA_OVERRUN     217     /* ACIA overrun error OR buffer overrun */
#define NB_ERR_ACIA_PARITY      218     /* ACIA parity error */
#define NB_ERR_ACIA_CARRIER     219     /* ACIA loss-of-carrier error */
#define NB_ERR_ACIA_MODULE      220     /* ACIA number is on a module that is not connected */

/* TN111 CENTRONICS Printer Device Driver errors */

#define NB_ERR_TN111_READ       109     /* Attempt was made to read from printer */
// #define NB_ERR_TN111_PARAMETER       110     /* Syntax error in parameter string */
#define NB_ERR_TN111_MEMORY     120     /* Insufficient memory to allocate buffer */


/* GRAPHICS device commands */
#define NBGR_ESCAPE     16

#define NBGR_MOVE       0
#define NBGR_TURN       1
#define NBGR_ARC        2
#define NBGR_TURNBY     3
#define NBGR_MODE       4
#define NBGR_FILL       5
#define NBGR_COLOUR     6
#define NBGR_GTEXT      7
#define NBGR_PEN        8
#define NBGR_DOT        9
#define NBGR_RANGE      10
#define NBGR_CENTRE     11
#define NBGR_MOVEBY     12
#define NBGR_DRAW       13
#define NBGR_DRAWBY     14
#define NBGR_BACKGROUND 15
#define NBGR_WIPE       16
#define NBGR_AXES       17
#define NBGR_PLACE      18
#define NBGR_RADIANS    19
#define NBGR_DEGREES    20
#define NBGR_CIRCLE     21
#define NBGR_DUMP       22


/* SDISCIO device commands (disk directory control) */
#define NBSD_DELETE     0       /* delete a file, wildcards allowed           */
#define NBSD_RENAME     1       /* rename a file, wildcards not allowed       */
#define NBSD_SETDISK    2       /* select default disk drive (capital letter) */
#define NBSD_FIRST      3       /* search for first file, wildcards allowed   */
#define NBSD_NEXT       4       /* search for next file, wildcards allowed    */
#define NBSD_GETDISK    5       /* get default disk drive (capital letter)    */
#define NBSD_RESET      6


/* CONSOLE control characters */
#define NBCON_ESCAPE    27
#define NBCON_CRLF      13

#define NBCON_CURSON    6
#define NBCON_CURSOFF   7
#define NBCON_TAB       9

#define NBCON_CURLEFT   8
#define NBCON_CURRIGHT  26
#define NBCON_CURUP     11
#define NBCON_CURDOWN   10
#define NBCON_CURHOME   12
#define NBCON_CURHOMEL  28
#define NBCON_CURHOMER  29
#define NBCON_CURXY     22      /* two bytes must follow */

#define NBCON_LINECLS   30
#define NBCON_LINEINS   1

#define NBCON_CLS       31
#define NBCON_TVCTL     23


/* 
 * LCD display handling (position from 0 to 15)
 * lowercase characters are not ASCII coded
 */

extern void __LIB__ fputc_lcd(int position, int character) __smallc;
extern void __LIB__  fputs_lcd( char *text ) __z88dk_fastcall;

/* 
 * Check if break has been pressed
 */

extern int __LIB__ break_status();

/* 
 * warm_reset: jump to BASIC entry
 */

extern void __LIB__ warm_reset();


/* 
 * newbrain resident OS related libraries
 */

#define INP     0x32    /* open mode for input with 'nb_open'*/
#define OUTP    0x33    /* open mode for output with 'nb_open'*/

extern int __LIB__ nb_open( int mode, int stream, int device, int port, char *paramstr ) __smallc;
extern void __LIB__  nb_close( int stream ) __z88dk_fastcall;
extern void __LIB__ nb_clear( );
extern void __LIB__ nb_putc( int stream, int byte ) __smallc;
extern void __LIB__ nb_puts( int stream, char *text ) __smallc;
extern int __LIB__ nb_putblock( int stream, char *bytes, int length ) __smallc;
extern void __LIB__ nb_putval( int stream, int value ) __smallc;

extern char __LIB__  nb_getc( int stream ) __z88dk_fastcall;
extern char __LIB__ *nb_gets( int stream, char *bytes, int length ) __smallc;
extern int __LIB__ nb_getblock( int stream, char *bytes, int length ) __smallc;

#endif
