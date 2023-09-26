/*
 * Headerfile for ZX81 specific stuff
 *
 * $Id: zx81.h $
 */

#ifndef __ZX81_H__
#define __ZX81_H__

#include <sys/compiler.h>
#include <sys/types.h>


/////////////
// CONSTANTS
/////////////

// Basic Tokens

#ifdef __ZX80__

#define TK_THEN         0xD5
#define TK_TO           0xD6
#define TK_NOT          0xDB
#define TK_AND          0xE0
#define TK_OR           0xE1
#define TK_STAR_STAR    0XE2
#define TK_LIST         0xE6
#define TK_RETURN       0xE7
#define TK_CLS          0xE8
#define TK_DIM          0xE9
#define TK_SAVE         0xEA
#define TK_FOR          0xEB
#define TK_GO_TO        0xEC
#define TK_POKE         0xED
#define TK_INPUT        0xEE
#define TK_RANDOMIZE    0xEF

#define TK_LET          0xF0
#define TK_NEXT         0xF3
#define TK_PRINT        0xF4
#define TK_NEW          0xF6
#define TK_RUN          0xF7

#define TK_STOP         0xF8
#define TK_CONT         0xF9
#define TK_CONTINUE     0xF9
#define TK_IF           0xFA
#define TK_GO_SUB       0xFB
#define TK_LOAD         0xFC
#define TK_CLEAR        0xFD
#define TK_REM          0xFE

#else

#define TK_RND         64
#define TK_INKEYS      65
#define TK_PI          66

#define TK_DLBQUOTE    192	; Strange behaviour for '""'
#define TK_AT          193
#define TK_TAB         194

#define TK_CODE        196
#define TK_VAL         197
#define TK_LEN         198
#define TK_SIN         199
#define TK_COS         200
#define TK_TAN         201
#define TK_ASN         202
#define TK_ACS         203
#define TK_ATN         204
#define TK_LN          205
#define TK_EXP         206
#define TK_INT         207
#define TK_SQR         208
#define TK_SGN         209
#define TK_ABS         210
#define TK_PEEK        211
#define TK_USR         212
#define TK_STRS        213
#define TK_CHRS        214
#define TK_NOT         215
#define TK_STAR_STAR   216
#define TK_OR          217
#define TK_AND         218
#define TK_LEQ         219
#define TK_GEQ         220
#define TK_NEQ         221
#define TK_THEN        222
#define TK_TO          223
#define TK_STEP        224
#define TK_LPRINT      225
#define TK_LLIST       226
#define TK_STOP        227
#define TK_SLOW        228
#define TK_FAST        229
#define TK_NEW         230
#define TK_SCROLL      231
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
#define TK_UNPLOT      252
#define TK_CLEAR       253
#define TK_RETURN      254
#define TK_COPY        255

#endif

/////////////////////////////////
// HIGH RESOLUTION RELATED STUFF
/////////////////////////////////

// graphics page
extern int base_graphics;

// direct call for "clear graphics page"
extern void __LIB__ _clg_hr();

// Change the (text or graphics) video page
extern void __LIB__   hrg_sync(void *addr) __z88dk_fastcall;

// Enable/disable High Resolution Graphics mode
// if startup=2, disables/enables the new interrupt handler (dangerous!)
extern void __LIB__ hrg_off();
extern void __LIB__ hrg_on();

// Shift the HRG TV picture
extern void __LIB__ hrg_tune_left();
extern void __LIB__ hrg_tune_right();

// Hides the HRG screen making the zx81 run faster!
extern void __LIB__ zx_blank();
// Shows the HRG screen back
extern void __LIB__ zx_noblank();

// Enable/disable High Resolution Graphics mode for Memotech board
// gfx81mt192.lib or gfx81mt64.lib and "startup=2" mode required
extern void __LIB__ mt_hrg_off();
extern void __LIB__ mt_hrg_on();


// ZX80 or ZX81 in FAST mode: try to generate a TV frame on demand
// programmers should call this repedeately in their program loops
// about every 1300ms;  'init' has to be called once at startup
// by default the delay calibration is set to 0xE9 when '0' is passed.
extern void __LIB__  gen_tv_field_init(int delay) __z88dk_fastcall;
extern void __LIB__ gen_tv_field();

// Invert HRG display ("hardware" way)
extern void __LIB__ invhrg();

// Copies text to HRG screen
extern void __LIB__  copytxt(int ovmode) __z88dk_fastcall;

// modes for copytxt
#define txt_and      47          // AND (HL)
#define txt_and_cpl  47+166*256  // AND (HL) - CPL
#define txt_or       182         // OR (HL)
#define txt_xor      174         // XOR (HL)
#define txt_or_r     31+182*256  // RRA - OR (HL)
#define txt_or_l     23+182*256  // RLA - OR (HL)
#define txt_and_r    31+47*256  // RRA - AND (HL)
#define txt_and_l    23+47*256  // RLA - AND (HL)


//////////////////
// MISC FUNCTIONS
//////////////////

// Clear text screen and set cursor at (0;0)
// It also restores the ROM character set and expands a collapsed D-FILE
extern void __LIB__ zx_cls();

// Position text cursor at (0;0)
extern void __LIB__ zx_topleft();

// Invert screen in text mode
extern void __LIB__ invtxt();

// Mirror screen in text mode
extern void __LIB__ mirrortxt();

// Fill text screen in text mode with specified character code
// and position text cursor at (0;0)
extern void __LIB__  filltxt(char character) __z88dk_fastcall;

// Special effect: roll all displayed text characters vertically
// 0..7, where '0' is the 'correct' adjustment
extern void __LIB__  rollchr(int offset) __z88dk_fastcall;

// Scroll up text screen
extern void __LIB__ scrolluptxt();

// Scroll down text screen and set cursor at (0;0)
extern void __LIB__ scrolldowntxt();

// Activates / Deactivates the ZX81 <-> ASCII converter,
// used in some output routine and interfacing to the BASIC strings
// 0=disable ASCII converter - 1=re-activates it
extern void __LIB__  zx_asciimode(int mode) __z88dk_fastcall;

// ZX81 <-> ASCII char conversion
extern char __LIB__ zx_ascii(char character);

// ASCII <-> ZX81 char conversion
extern char __LIB__ ascii_zx(char character);

// FAST / SLOW mode switching, available only if startup >= 2
extern void __LIB__ zx_fast();
extern void __LIB__ zx_slow();

// Test for BREAK being pressed
extern int  __LIB__ zx_break(void);

// Set console cursor position, top-left=(0;0)
extern int  __LIB__              zx_setcursorpos(int x, int y) __smallc;
extern int  __LIB__    zx_setcursorpos_callee(int x, int y) __smallc __z88dk_callee;
#define zx_setcursorpos(a,b)     zx_setcursorpos_callee(a,b)


//////////////////////////
// CHROMA-81 ONLY
//////////////////////////

#define INK_BLACK      0x00
#define INK_BLUE       0x01
#define INK_RED        0x02
#define INK_MAGENTA    0x03
#define INK_GREEN      0x04
#define INK_CYAN       0x05
#define INK_YELLOW     0x06
#define INK_WHITE      0x07

#define PAPER_BLACK    0x00
#define PAPER_BLUE     0x10
#define PAPER_RED      0x20
#define PAPER_MAGENTA  0x30
#define PAPER_GREEN    0x40
#define PAPER_CYAN     0x50
#define PAPER_YELLOW   0x60
#define PAPER_WHITE    0x70

#define BRIGHT         0x80
#define PAPER_BRIGHT   0x80
#define INK_BRIGHT     0x08

// Set the border color
extern void  __LIB__  zx_border(uchar colour) __z88dk_fastcall;
// Quickly set the whole screen color attributes
extern void  __LIB__  zx_colour(uchar colour) __z88dk_fastcall;
// Get color attribute at given position
extern uint  __LIB__              zx_attr(uchar row, uchar col) __smallc;
extern uint  __LIB__    zx_attr_callee(uchar row, uchar col) __smallc __z88dk_callee;
#define zx_attr(a,b)              zx_attr_callee(a,b)


// DISPLAY ATTRIBUTE ADDRESS MANIPULATORS
// refer to 'spectrum.h' for details about the "aaddr" naming convention

extern uchar __LIB__              *zx_cyx2aaddr(uchar row, uchar col) __smallc;
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

extern uchar __LIB__    *zx_cyx2aaddr_callee(uchar row, uchar col) __smallc __z88dk_callee;
extern uchar __LIB__    *zx_pxy2aaddr_callee(uchar xcoord, uchar ycoord) __smallc __z88dk_callee;

#define zx_cyx2aaddr(a,b)          zx_cyx2aaddr_callee(a,b)
#define zx_pxy2aaddr(a,b)          zx_pxy2aaddr_callee(a,b)


///////////////////////////////////////////
// DIAGNOSTICS AND HARDWARE IDENTIFICATION
///////////////////////////////////////////

extern int  __LIB__ zx_basic_length(void);
extern int  __LIB__ zx_var_length(void);


///////////////////////////////
// INTERFACE FOR CALLING BASIC
///////////////////////////////

extern int  __LIB__  zx_goto(int line) __z88dk_fastcall;	// calls the BASIC interpreter at a single line
extern int  __LIB__  zx_line(int line) __z88dk_fastcall;	// executes a single BASIC line

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
#define REPORT_8  asm("rst\t8\ndefb\t7\n")   // You have attempted INPUT as a command (not allowed).
#define REPORT_9  asm("rst\t8\ndefb\t8\n")   // STOP statement
#define REPORT_A  asm("rst\t8\ndefb\t9\n")   // Invalid argument
#define REPORT_B  asm("rst\t8\ndefb\t10\n")  // Integer out of range
#define REPORT_C  asm("rst\t8\ndefb\t11\n")  // Nonsense in BASIC (bad values in a VAL expression)
#define REPORT_D  asm("rst\t8\ndefb\t12\n")  // BREAK - CONT repeat
#define REPORT_E  asm("rst\t8\ndefb\t13\n")  // Not used   (Out of DATA)
#define REPORT_F  asm("rst\t8\ndefb\t14\n")  // Invalid file name (The program name provided is the empty string)

#define REPORT_G  asm("rst\t8\ndefb\t15\n")  // Not used   (No room for line)
#define REPORT_H  asm("rst\t8\ndefb\t16\n")  // Not used   (STOP in INPUT)
#define REPORT_I  asm("rst\t8\ndefb\t17\n")  // Not used   (FOR without NEXT)
#define REPORT_J  asm("rst\t8\ndefb\t18\n")  // Not used   (Invalid I/O device)
#define REPORT_K  asm("rst\t8\ndefb\t19\n")  // Not used   (Invalid colour)
#define REPORT_L  asm("rst\t8\ndefb\t20\n")  // Not used   (BREAK into program)
#define REPORT_M  asm("rst\t8\ndefb\t21\n")  // Not used   (RAMTOP no good)
#define REPORT_N  asm("rst\t8\ndefb\t22\n")  // Not used   (Statement lost)
#define REPORT_O  asm("rst\t8\ndefb\t23\n")  // Not used   (Invalid stream)
#define REPORT_P  asm("rst\t8\ndefb\t24\n")  // Not used   (FN without DEF)
#define REPORT_Q  asm("rst\t8\ndefb\t25\n")  // Not used   (Parameter error)
#define REPORT_R  asm("rst\t8\ndefb\t26\n")  // Not used   (Tape loading error)


/*
Macros to write new BASIC statement in C, in example:

#include <stdio.h>
#include <zx81.h>

main(unsigned int arg2, char *arg1)
{
	ARG_STR;
	ARG_UINT;
	ARG_END;
	
	printf("Arg1: ");
	zx_asciimode(0);
	printf("%s", arg1);
	zx_asciimode(1);
	printf(", arg2: %u \n" ,arg2);

	STMT_RET;
}

------------------
1   REM  @#@#@# <-- C compiled code
10  LET A$="ABC": LET A2=123
20  PRINT USR 16514,A$,A2
------------------

*/

// Capture arguments and push them on the stack
// The macros will also fire a "Nonsense in BASIC" message when the argument type is wrong
// Arguments must be declared in reverse order but captured sequentially

#ifdef __LAMBDA__

// int   (0x28,7 = JR Z,7)
#define ARG_INT    asm("rst\t0x08\nEXTERN\t__lambda_class_6\ncall\t__lambda_class_6\nEXTERN\t__lambda_find_int\ncall\t__lambda_find_int\ndefb\t0x28,7\nld\thl,0\nsbc\thl,bc\nld\tb,h\nld\tc,l\npush\tbc\n")

// unsigned int
#define ARG_UINT   asm("rst\t0x08\nEXTERN\t__lambda_class_6\ncall\t__lambda_class_6\nEXTERN\t__lambda_find_int\ncall\t__lambda_find_int\npush\tbc\n")

// void *, struct, char *...
#define ARG_PTR    asm("rst\t0x08\nEXTERN\t__lambda_scanning\ncall\t__lambda_scanning\nEXTERN\t__lambda_stk_fetch\ncall\t__lambda_stk_fetch\npush\tde\n")

// C style strings (adds the string termination automatically)
#define ARG_STR    asm("rst\t0x08\nEXTERN\t__lambda_scanning\ncall\t__lambda_scanning\nld\tde,0x0008\nld\tbc,1\nEXTERN\t__lambda_stk_store\ncall\t__lambda_stk_store\nEXTERN\t__lambda_strs_add\ncall\t__lambda_strs_add\nEXTERN\t__lambda_stk_fetch\ncall\t__lambda_stk_fetch\npush\tde\n")

// End of argument list
#define ARG_END    asm("push\tbc\n")

// Terminate your custom statement and get back to the BASIC interpreter
#define STMT_RET   asm("ld\tix,0x4000\nld\tsp,(0x4002)\nEXTERN\t__lambda_next_one\njp\t__lambda_next_one\n")

#else

// int   (0x28,7 = JR Z,7)
#define ARG_INT    asm("rst\t0x20\ncall\t0x0D92\ncall\t0x158A\ndefb\t0x28,7\nld\thl,0\nsbc\thl,bc\nld\tb,h\nld\tc,l\npush\tbc\n")

// unsigned int
#define ARG_UINT   asm("rst\t0x20\ncall\t0x0D92\ncall\t0x158A\npush\tbc\n")

// void *, struct, char *...
#define ARG_PTR    asm("rst\t0x20\ncall\t0x0F55\ncall\t0x13F8\npush\tde\n")

// C style strings (adds the string termination automatically)
#define ARG_STR    asm("rst\t0x20\ncall\t0x0F55\nld\tde,0x001E\nld\tbc,1\ncall\t0x12C3\ncall\t0x1B62\ncall\t0x13F8\npush\tde\n")

// End of argument list
#define ARG_END    asm("push\tbc\n")

// Terminate your custom statement and get back to the BASIC interpreter
#define STMT_RET   asm("ld\tix,0x4000\nld\tsp,(0x4002)\njp\t0x09F2\n")

#endif

//////////////
// ZX PRINTER
//////////////

extern void __LIB__  zx_lprintc(int chr);
extern void __LIB__  zx_lprintc5(int chr);
extern void __LIB__  zx_hardcopy();
// Print out a 256 bytes buffer (8 rows)
extern void __LIB__  zx_print_buf(char *buf) __z88dk_fastcall;
// Print out a single graphics row (a 32 bytes buffer is required)
extern void __LIB__  zx_print_row(char *buf) __z88dk_fastcall;


////////////
// TAPE I/O
////////////

#define LDERR_OK                  0       // LOAD OK
#define LDERR_WRONG_DATA          1       // LOAD error
#define LDERR_VERIFY_ERROR        2
#define LDERR_BREAK               3       // BREAK pressed
#define LDERR_WRONG_BLOCK         4       // LOAD error: loaded block has wrong type

extern int  __LIB__            tape_load_block(void *addr, size_t len, unsigned char type) __smallc;

// SAVE - return with nonzero if BREAK is pressed
// example values for custom speed:
// 3  = 4800 bps, 9  = 3600 bps
// 20 = 2400 bps, 40 = 1200 bps
extern void __LIB__  set_tape_speed(unsigned char speed);
extern int  __LIB__            tape_save_block(void *addr, size_t len, unsigned char type) __smallc;

extern int  __LIB__  tape_load_block_callee(void *addr, size_t len, unsigned char type) __smallc __z88dk_callee;
extern int  __LIB__  tape_save_block_callee(void *addr, size_t len, unsigned char type) __smallc __z88dk_callee;

#define tape_save_block(a,b,c) tape_save_block_callee(a,b,c)
#define tape_load_block(a,b,c) tape_load_block_callee(a,b,c)


#endif
