/*
 * Headerfile for Spectrum specific stuff
 *
 * $Id: spectrum.h$
 */

#ifndef __SPECTRUM_H__
#define __SPECTRUM_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <arch/zx/zx_input.h>

/////////////
// CONSTANTS
/////////////

// Attributes
/*
#define BLACK          0x00
#define BLUE           0x01
#define RED            0x02
#define MAGENTA        0x03
#define GREEN          0x04
#define CYAN           0x05
#define YELLOW         0x06
#define WHITE          0x07
*/
#define INK_BLACK      0x00
#define INK_BLUE       0x01
#define INK_RED        0x02
#define INK_MAGENTA    0x03
#define INK_GREEN      0x04
#define INK_CYAN       0x05
#define INK_YELLOW     0x06
#define INK_WHITE      0x07

#define PAPER_BLACK    0x00
#define PAPER_BLUE     0x08
#define PAPER_RED      0x10
#define PAPER_MAGENTA  0x18
#define PAPER_GREEN    0x20
#define PAPER_CYAN     0x28
#define PAPER_YELLOW   0x30
#define PAPER_WHITE    0x38

#define BRIGHT         0x40
#define FLASH          0x80

// Basic Tokens

#define TK_RND         165
#define TK_INKEYS      166
#define TK_PI          167
#define TK_FN          168
#define TK_POINT       169
#define TK_SCREENS     170
#define TK_ATTR        171
#define TK_AT          172
#define TK_TAB         173
#define TK_VALS        174
#define TK_CODE        175
#define TK_VAL         176
#define TK_LEN         177
#define TK_SIN         178
#define TK_COS         179
#define TK_TAN         180
#define TK_ASN         181
#define TK_ACS         182
#define TK_ATN         183
#define TK_LN          184
#define TK_EXP         185
#define TK_INT         186
#define TK_SQR         187
#define TK_SGN         188
#define TK_ABS         189
#define TK_PEEK        190
#define TK_IN          191
#define TK_USR         192
#define TK_STRS        193
#define TK_CHRS        194
#define TK_NOT         195
#define TK_BIN         196
#define TK_OR          197
#define TK_AND         198
#define TK_LEQ         199
#define TK_GEQ         200
#define TK_NEQ         201
#define TK_LINE        202
#define TK_THEN        203
#define TK_TO          204
#define TK_STEP        205
#define TK_DEF_FN      206
#define TK_CAT         207
#define TK_FORMAT      208
#define TK_MOVE        209
#define TK_ERASE       210
#define TK_OPEN        211
#define TK_CLOSE       212
#define TK_MERGE       213
#define TK_VERIFY      214
#define TK_BEEP        215
#define TK_CIRCLE      216
#define TK_INK         217
#define TK_PAPER       218
#define TK_FLASH       219
#define TK_BRIGHT      220
#define TK_INVERSE     221
#define TK_OVER        222
#define TK_OUT         223
#define TK_LPRINT      224
#define TK_LLIST       225
#define TK_STOP        226
#define TK_READ        227
#define TK_DATA        228
#define TK_RESTORE     229
#define TK_NEW         230
#define TK_BORDER      231
#define TK_CONTINUE    232
#define TK_CONT        232
#define TK_DIM         233
#define TK_REM         234
#define TK_FOR         235
#define TK_GO_TO       236
#define TK_GO_SUB      237
#define TK_INPUT       238
#define TK_LOAD        239
#define TK_LIST        240
#define TK_LET         241
#define TK_PAUSE       242
#define TK_NEXT        243
#define TK_POKE        244
#define TK_PRINT       245
#define TK_PLOT        246
#define TK_RUN         247
#define TK_SAVE        248
#define TK_RANDOMIZE   249
#define TK_RAND        249
#define TK_IF          250
#define TK_CLS         251
#define TK_DRAW        252
#define TK_CLEAR       253
#define TK_RETURN      254
#define TK_COPY        255


///////////////////////////////////////////
// DIAGNOSTICS AND HARDWARE IDENTIFICATION
///////////////////////////////////////////

extern int  __LIB__ zx_128mode(void);            // true or false
extern int  __LIB__ zx_floatingbus(void);        // true or false
extern int  __LIB__ zx_issue3(void);             // true or false
extern int  __LIB__ zx_type(void);		 // 0:48K - 1: 128K - 2: TS2068
extern int  __LIB__ zx_model(void);
extern int  __LIB__ zx_basic_length(void);
extern int  __LIB__ zx_var_length(void);
extern int  __LIB__ zx_printer(void);
extern int  __LIB__ zx_soundchip(void);
extern int  __LIB__ zx_timexsound(void);
extern int  __LIB__ zx_fullerstick(void);
extern int  __LIB__ zx_kempstonmouse(void);
extern int  __LIB__ zx_kempston(void);
extern int  __LIB__ zx_iss_stick(void);
extern int  __LIB__ zx_mb02(void);
extern int  __LIB__ zx_multiface(void);
extern int  __LIB__ zx_disciple(void);
extern int  __LIB__ zx_plus3fdc(void);
extern int  __LIB__ zx_zxmmc(void);
extern int  __LIB__ zx_extsys(void);
extern int  __LIB__ zx_basemem(void);
extern int  __LIB__ zx_break(void);
extern int  __LIB__ zx_ulaplus(void);


/////////////////////////////////////////
// ULAPLUS/Arlequin palette mode project
/////////////////////////////////////////

extern int  __LIB__ ula_plus_mode(void);
extern void __LIB__ ula_normal_mode(void);
extern void __LIB__ ula_sync(void);
extern int __LIB__ ulaplus_set(unsigned char attribute, unsigned char rgbcolor) __smallc;
extern int  __LIB__  ulaplus_get(unsigned char attribute) __z88dk_fastcall;


///////////////////////////////
// INTERFACE FOR CALLING BASIC
///////////////////////////////

// Check syntax of an immediate BASIC command (e.g. {TK_CLS, '#', 13} would probe the Interface 1), max 20 bytes.
extern int  __LIB__  zx_syntax(char *statement) __z88dk_fastcall;

// enter BASIC at a given program line, execution will stop gettin back to the
// calling C program when STOP or end of program will happen
extern int  __LIB__  zx_goto(int line) __z88dk_fastcall;

// executes a single BASIC line (also TS2068 but does not work in 128k mode)
extern int  __LIB__  zx_line(int line) __z88dk_fastcall;

// set/get string variable values, e.g. for A$: zx_setstr('a',"hello");
extern int  __LIB__              zx_getstr(char variable, char *value) __smallc;
extern void __LIB__              zx_setstr(char variable, char *value) __smallc;

// set/get positive integer values in numeric variables
extern unsigned int  __LIB__  zx_getint(char *variable) __z88dk_fastcall;
extern void __LIB__              zx_setint(char *variable, unsigned int value) __smallc;

// set/get FP values in numeric variables, e.g.  double a = zx_getfloat("number");
extern double_t __LIB__  zx_getfloat(char *variable) __z88dk_fastcall;
extern void __LIB__              zx_setfloat(char *variable, double_t value) __smallc;

extern int  __LIB__    zx_getstr_callee(char variable, char *value) __smallc __z88dk_callee;
extern void __LIB__    zx_setstr_callee(char variable, char *value) __smallc __z88dk_callee;
extern void __LIB__    zx_setint_callee(char *variable, unsigned int value) __smallc __z88dk_callee;
extern void __LIB__    zx_setfloat_callee(char *variable, double_t value) __smallc __z88dk_callee;

#define zx_getstr(a,b)           zx_getstr_callee(a,b)
#define zx_setstr(a,b)           zx_setstr_callee(a,b)
#define zx_setint(a,b)           zx_setint_callee(a,b)
#define zx_setfloat(a,b)         zx_setfloat_callee(a,b)


///////////////////////////////
// INTERFACE FOR BASIC CALLS
///////////////////////////////

// BASIC error messages.  This will abruptly stop the program execution.
#define REPORT_OK asm("rst\t8\ndefb\t255\n") // OK
#define REPORT_1  asm("rst\t8\ndefb\t0\n")   // NEXT without FOR
#define REPORT_2  asm("rst\t8\ndefb\t1\n")   // Variable not found
#define REPORT_3  asm("rst\t8\ndefb\t2\n")   // Subscript wrong
#define REPORT_4  asm("rst\t8\ndefb\t3\n")   // Out of memory
#define REPORT_5  asm("rst\t8\ndefb\t4\n")   // Out of screen
#define REPORT_6  asm("rst\t8\ndefb\t5\n")   // Number too big
#define REPORT_7  asm("rst\t8\ndefb\t6\n")   // RETURN without GOSUB
#define REPORT_8  asm("rst\t8\ndefb\t7\n")   // End of file
#define REPORT_9  asm("rst\t8\ndefb\t8\n")   // STOP statement
#define REPORT_A  asm("rst\t8\ndefb\t9\n")   // Invalid argument
#define REPORT_B  asm("rst\t8\ndefb\t10\n")  // Integer out of range
#define REPORT_C  asm("rst\t8\ndefb\t11\n")  // Nonsense in BASIC
#define REPORT_D  asm("rst\t8\ndefb\t12\n")  // BREAK - CONT repeat
#define REPORT_E  asm("rst\t8\ndefb\t13\n")  // Out of DATA
#define REPORT_F  asm("rst\t8\ndefb\t14\n")  // Invalid file name
#define REPORT_G  asm("rst\t8\ndefb\t15\n")  // No room for line
#define REPORT_H  asm("rst\t8\ndefb\t16\n")  // STOP in INPUT
#define REPORT_I  asm("rst\t8\ndefb\t17\n")  // FOR without NEXT
#define REPORT_J  asm("rst\t8\ndefb\t18\n")  // Invalid I/O device
#define REPORT_K  asm("rst\t8\ndefb\t19\n")  // Invalid colour
#define REPORT_L  asm("rst\t8\ndefb\t20\n")  // BREAK into program
#define REPORT_M  asm("rst\t8\ndefb\t21\n")  // RAMTOP no good
#define REPORT_N  asm("rst\t8\ndefb\t22\n")  // Statement lost
#define REPORT_O  asm("rst\t8\ndefb\t23\n")  // Invalid stream
#define REPORT_P  asm("rst\t8\ndefb\t24\n")  // FN without DEF
#define REPORT_Q  asm("rst\t8\ndefb\t25\n")  // Parameter error
#define REPORT_R  asm("rst\t8\ndefb\t26\n")  // Tape loading error


/*
Macros to write new BASIC statement in C, in example:

#include <stdio.h>
#include <arch/zx/spectrum.h>

main(unsigned int arg2, char *arg1)
{
	ARG_STR;
	ARG_UINT;
	ARG_END;
	
	printf("Arg1: %s, arg2: %u \n", arg1 ,arg2);

	STMT_RET;
}

------------------
10   LET a$="abc": LET a2=123
20   PRINT USR 32768,a$,a2
------------------

*/

// Capture arguments and push them on the stack
// The macros will also fire a "Nonsense in BASIC" message when the argument type is wrong
// Arguments must be declared in reverse order but captured sequentially


#ifdef __TS2068__

// int
#define ARG_INT    asm("rst\t0x20\ncall\t0x1BE5\ncall\t0x3160\ndefb\t0x28,7\nld\thl,0\nsbc\thl,bc\nld\tb,h\nld\tc,l\npush\tbc\n")

// unsigned int
#define ARG_UINT   asm("rst\t0x20\ncall\t0x1BE5\ncall\t0x3160\npush\tbc\n")

// void *, struct, char *...
#define ARG_PTR    asm("rst\t0x20\ncall\t0x1BEF\ncall\t0x2FAF\npush\tde\n")

// C style strings (adds the string termination automatically)
#define ARG_STR    asm("rst\t0x20\ncall\t0x1BEF\nld\tde,0x040F\nld\tbc,1\ncall\t0x2E70\ncall\t0x39B7\ncall\t0x2FAF\npush\tde\n")

// End of argument list
#define ARG_END    asm("push\tbc\n")

// Terminate your custom statement and get back to the BASIC interpreter
#define STMT_RET   asm("ld\tiy,0x5C3A\nld\tsp,(0x5C3D)\njp\t0x1AB9\n")


#else


// int
#define ARG_INT    asm("rst\t0x20\ncall\t0x1C82\ncall\t0x2DA2\ndefb\t0x28,7\nld\thl,0\nsbc\thl,bc\nld\tb,h\nld\tc,l\npush\tbc\n")

// unsigned int
#define ARG_UINT   asm("rst\t0x20\ncall\t0x1C82\ncall\t0x2DA2\npush\tbc\n")

// void *, struct, char *...
#define ARG_PTR    asm("rst\t0x20\ncall\t0x1C8C\ncall\t0x2BF1\npush\tde\n")

// C style strings (adds the string termination automatically)
#define ARG_STR    asm("rst\t0x20\ncall\t0x1C8C\nld\tde,0x03d1\nld\tbc,1\ncall\t0x2ab2\ncall\t0x359C\ncall\t0x2BF1\npush\tde\n")

// End of argument list
#define ARG_END    asm("push\tbc\n")

// Terminate your custom statement and get back to the BASIC interpreter
#define STMT_RET   asm("ld\tiy,0x5C3A\nld\tsp,(0x5C3D)\njp\t0x1b76\n")

#endif



//////////////
// ZX PRINTER
//////////////

extern void __LIB__  zx_lprintc(int chr);
extern void __LIB__  zx_hardcopy(void);
// Print out a 256 bytes buffer (8 rows)
extern void __LIB__  zx_print_buf(char *buf) __z88dk_fastcall;
// Print out a single graphics row (a 32 bytes buffer is required)
extern void __LIB__  zx_print_row(char *buf) __z88dk_fastcall;


////////////
// TAPE I/O
////////////

struct zxtapehdr {             // standard tape header
   unsigned char type;
   char          name[10];
   size_t        length;
   size_t        address;
   size_t        offset;
};

extern int  __LIB__            tape_save(char *name, size_t loadstart,void *start, size_t len) __smallc;
extern int  __LIB__            tape_save_block(void *addr, size_t len, unsigned char type) __smallc;
extern int  __LIB__            tape_load_block(void *addr, size_t len, unsigned char type) __smallc;

extern int  __LIB__  tape_save_block_callee(void *addr, size_t len, unsigned char type) __smallc __z88dk_callee;
extern int  __LIB__  tape_load_block_callee(void *addr, size_t len, unsigned char type) __smallc __z88dk_callee;

#define tape_save_block(a,b,c) tape_save_block_callee(a,b,c)
#define tape_load_block(a,b,c) tape_load_block_callee(a,b,c)


///////////////////////////////////
// DISK AND OTHER MASS STORAGE I/O
///////////////////////////////////

// RESIDOS

#ifdef RESIDOS                 // if it's residos then we want dodos routines
#pragma output NEEDresidos

#endif




//////////////////////////
// DISPLAY FILE FUNCTIONS
//////////////////////////

// NOTE: remember to compile with -pragma-define:CLIB_CONIO_NATIVE_COLOUR=1
// in order to use INK_BLACK to INK_WHITE and PAPER_BLACK to PAPER_WHITE.
// Clear the screen
#define zx_cls()                  fputc_cons(12)

// Set or unset the flash attribute for now on
#define zx_setattrflash(b)        fputc_cons(18); fputc_cons((b)? 49: 48)

// Set or unset the bright attribute for now on
#define zx_setattrbright(b)       fputc_cons(19); fputc_cons((b)? 49: 48)

// Set or unset the inverse attribute for now on
#define zx_setattrinverse(b)      fputc_cons(20); fputc_cons((b)? 49: 48)

// Set the border color
// Param colour can be any of: INK_BLACK, INK_BLUE,... to INK_WHITE
extern void  __LIB__  zx_border(uchar colour) __z88dk_fastcall;
// Quickly set the whole screen color attributes
// Param colour must be in the form i | p, where
// i can be any of: INK_BLACK, INK_BLUE,... to INK_WHITE
// p can be any of: PAPER_BLACK, PAPER_BLUE,... to PAPER_WHITE
extern void  __LIB__  zx_colour(uchar colour) __z88dk_fastcall;
// Change the paper attr from now on
// i can be any of: INK_BLACK, INK_BLUE,... to INK_WHITE
#define zx_setink(i) fputc_cons(16); fputc_cons(48 + i)
// Change the paper attr from now on
// p can be any of: INK_BLACK, INK_BLUE,... to INK_WHITE
#define zx_setpaper(p) fputc_cons(17); fputc_cons(48 + p)
// Get color attribute at given position
extern uint  __LIB__              zx_attr(uchar row, uchar col) __smallc;
extern uint  __LIB__              zx_screenstr(uchar row, uchar col) __smallc;

extern uint  __LIB__    zx_attr_callee(uchar row, uchar col) __smallc __z88dk_callee;
extern uint  __LIB__    zx_screenstr_callee(uchar row, uchar col) __smallc __z88dk_callee;

#define zx_attr(a,b)              zx_attr_callee(a,b)
#define zx_screenstr(a,b)         zx_screenstr_callee(a,b)

// Sets the cursor position on screen
// Remember to add 32 to both the desired row & col.
#define zx_setcursorpos(row,col)      fputc_cons(22); fputc_cons(row); fputc_cons(col);

// Sets the cursor position on screen
#define zx_movecursorto(row,col)      fputc_cons(22); fputc_cons(row + 32); fputc_cons(col + 32)

#define zx_topleft()              fputc_cons(22); fputc_cons(0); fputc_cons(0);

// Print a string on the screen
extern int __LIB__ zx_printf(char *fmt, ...);

// In the following, screen address refers to a pixel address within the display file while
// attribute address refers to the attributes area.
//
// Function names are constructed from the following atoms:
//
// saddr = screen address
// aaddr = attribute address
// 
// px    = pixel x coordinate (0..255)
// py    = pixel y coordinate (0..191)
// pxy   = pixel (x,y) coordinate
//
// cx    = character x coordinate (0..31)
// cy    = character y coordinate (0..23)
// cyx   = character (y,x) coordinate - ordering borrowed from Sinclair Basic
//
// So for example:
//
// zx_saddr2cy(saddr) will return the character y coordinate corresponding to the given screen address
// zx_saddr2aaddr(saddr) will return the attribute address corresponding to the given screen address
// zx_pxy2aaddr(px,py) will return the attribute address corresponding to the given (x,y) pixel coordinate
//
// Some functions will return with carry flag set if coordinates or addresses move out of
// bounds.  In these cases the special z88dk keywords iferror() and ifnerror() can be used
// to test the carry flag and determine if invalid results are returned.  Check with the
// wiki documentation or the asm source files to see which functions support this.  If
// comments in the asm source file do not mention this it is not supported.

// DISPLAY PIXEL ADDRESS MANIPULATORS

extern uchar __LIB__              *zx_cxy2saddr(uchar row, uchar col) __smallc;
extern uchar __LIB__  *zx_cy2saddr(uchar row) __z88dk_fastcall;           // cx assumed 0

extern uchar __LIB__              *zx_pxy2saddr(uchar xcoord, uchar ycoord) __smallc;
extern uchar __LIB__  *zx_py2saddr(uchar ycoord) __z88dk_fastcall;        // px assumed 0

extern uint  __LIB__   zx_saddr2cx(void *pixeladdr) __z88dk_fastcall;
extern uint  __LIB__   zx_saddr2cy(void *pixeladdr) __z88dk_fastcall;

extern uint  __LIB__               zx_saddr2px(void *pixeladdr, uchar mask) __smallc;
extern uint  __LIB__   zx_saddr2py(void *pixeladdr) __z88dk_fastcall;

extern uchar __LIB__  *zx_saddr2aaddr(void *pixeladdr) __z88dk_fastcall;

extern uchar __LIB__  *zx_saddrcdown(void *pixeladdr) __z88dk_fastcall;
extern uchar __LIB__  *zx_saddrcleft(void *pixeladdr) __z88dk_fastcall;
extern uchar __LIB__  *zx_saddrcright(void *pixeladdr) __z88dk_fastcall;
extern uchar __LIB__  *zx_saddrcup(void *pixeladdr) __z88dk_fastcall;

extern uchar __LIB__  *zx_saddrpdown(void *pixeladdr) __z88dk_fastcall;
extern uchar __LIB__              *zx_saddrpleft(void *pixeladdr, uchar *mask) __smallc;
extern uchar __LIB__              *zx_saddrpright(void *pixeladdr, uchar *mask) __smallc;
extern uchar __LIB__  *zx_saddrpup(void *pixeladdr) __z88dk_fastcall;

extern uchar __LIB__    *zx_cxy2saddr_callee(uchar row, uchar col) __smallc __z88dk_callee;
extern uchar __LIB__    *zx_pxy2saddr_callee(uchar xcoord, uchar ycoord) __smallc __z88dk_callee;
extern uint  __LIB__     zx_saddr2px_callee(void *pixeladdr, uchar mask) __smallc __z88dk_callee;
extern uchar __LIB__    *zx_saddrpleft_callee(void *pixeladdr, uchar *mask) __smallc __z88dk_callee;
extern uchar __LIB__    *zx_saddrpright_callee(void *pixeladdr, uchar *mask) __smallc __z88dk_callee;

#define zx_cyx2saddr(a,b)          zx_cxy2saddr_callee(b,a)
#define zx_cxy2saddr(a,b)          zx_cxy2saddr_callee(a,b)

#define zx_pxy2saddr(a,b)          zx_pxy2saddr_callee(a,b)
#define zx_saddr2px(a,b)           zx_saddr2px_callee(a,b)
#define zx_saddrpleft(a,b)         zx_saddrpleft_callee(a,b)
#define zx_saddrpright(a,b)        zx_saddrpright_callee(a,b)

// DISPLAY ATTRIBUTE ADDRESS MANIPULATORS

extern uchar __LIB__              *zx_cxy2aaddr(uchar row, uchar col) __smallc;
extern uchar __LIB__  *zx_cy2aaddr(uchar row) __z88dk_fastcall;           // cx assumed 0

extern uchar __LIB__              *zx_pxy2aaddr(uchar xcoord, uchar ycoord) __smallc;
extern uchar __LIB__  *zx_py2aaddr(uchar ycoord) __z88dk_fastcall;        // px assumed 0

extern uint  __LIB__   zx_aaddr2cx(void *attraddr) __z88dk_fastcall;
extern uint  __LIB__   zx_aaddr2cy(void *attraddr) __z88dk_fastcall;
 
extern uint  __LIB__   zx_aaddr2px(void *attraddr) __z88dk_fastcall;
extern uint  __LIB__   zx_aaddr2py(void *attraddr) __z88dk_fastcall;

extern uchar __LIB__  *zx_aaddr2saddr(void *attraddr) __z88dk_fastcall;

extern uchar __LIB__  *zx_aaddrcdown(void *attraddr) __z88dk_fastcall;
extern uchar __LIB__  *zx_aaddrcleft(void *attraddr) __z88dk_fastcall;
extern uchar __LIB__  *zx_aaddrcright(void *attraddr) __z88dk_fastcall;
extern uchar __LIB__  *zx_aaddrcup(void *attraddr) __z88dk_fastcall;

extern uchar __LIB__    *zx_cxy2aaddr_callee(uchar row, uchar col) __smallc __z88dk_callee;
extern uchar __LIB__    *zx_pxy2aaddr_callee(uchar xcoord, uchar ycoord) __smallc __z88dk_callee;

#define zx_cyx2aaddr(a,b)          zx_cxy2aaddr_callee(b,a)
#define zx_cxy2aaddr(a,b)          zx_cxy2aaddr_callee(a,b)
#define zx_pxy2aaddr(a,b)          zx_pxy2aaddr_callee(a,b)


/* Interrupt handling */

#include <interrupt.h>

// Setup an im2 jump table at given address
__ZPROTO2(void,,zx_im2_init,void *,address,uint,byte)


/* This routine strips the drive specifier from the filename header.
   It updates the 'D' BASIC variable with the drive number 
   and N$ with the file name  */
extern int  __LIB__  zxgetfname(char *zxfname);
extern int  __LIB__  zxgetfname2(char *zxfname);

struct dirent {
    ino_t   d_ino;
    char    d_name[12];
};

#endif
