/*
 * Headerfile for Spectrum specific stuff
 *
 * $Id: spectrum.h,v 1.17 2007-06-11 08:32:59 aralbrec Exp $
 */

#ifndef __SPECTRUM_H__
#define __SPECTRUM_H__

#include <sys/types.h>

/////////////
// CONSTANTS
/////////////

// Attributes

#define BLACK          0x00
#define BLUE           0x01
#define RED            0x02
#define MAGENTA        0x03
#define GREEN          0x04
#define CYAN           0x05
#define YELLOW         0x06
#define WHITE          0x07

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
extern int  __LIB__ zx_multiface(void);
extern int  __LIB__ zx_disciple(void);
extern int  __LIB__ zx_plus3fdc(void);
extern int  __LIB__ zx_trd(void);
extern int  __LIB__ zx_extsys(void);
extern int  __LIB__ zx_basemem(void);


///////////////////////////////
// INTERFACE FOR CALLING BASIC
///////////////////////////////

extern int  __LIB__ __FASTCALL__ zx_goto(int line);
extern int  __LIB__              zx_getstr(char variable, char *value);
extern void __LIB__              zx_setstr(char variable, char *value);
extern int  __LIB__ __FASTCALL__ zx_getint(char *variable);
extern void __LIB__              zx_setint(char *variable, int value);

extern int  __LIB__ __CALLEE__   zx_getstr_callee(char variable, char *value);
extern void __LIB__ __CALLEE__   zx_setstr_callee(char variable, char *value);
extern void __LIB__ __CALLEE__   zx_setint_callee(char *variable, int value);

#define zx_getstr(a,b)           zx_getstr_callee(a,b)
#define zx_setstr(a,b)           zx_setstr_callee(a,b)
#define zx_setint(a,b)           zx_setint_callee(a,b)


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

extern int  __LIB__            tape_save(char *name, size_t loadstart,void *start, size_t len);
extern int  __LIB__            tape_save_block(void *addr, size_t len, unsigned char type);
extern int  __LIB__            tape_load_block(void *addr, size_t len, unsigned char type);

extern int  __LIB__ __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type);
extern int  __LIB__ __CALLEE__ tape_load_block_callee(void *addr, size_t len, unsigned char type);

#define tape_save_block(a,b,c) tape_save_block_callee(a,b,c)
#define tape_load_block(a,b,c) tape_load_block_callee(a,b,c)


///////////////////////////////////
// DISK AND OTHER MASS STORAGE I/O
///////////////////////////////////

// +3 Disk

#ifdef PLUS3                   // if it's a +3 we want the dodos routine
#pragma output NEEDplus3dodos

extern int  __LIB__ findhand(void);
extern void __LIB__ freehand(int);

#endif

// RESIDOS

#ifdef RESIDOS                 // if it's residos then we want dodos routines
#pragma output NEEDresidos

extern int  __LIB__ findhand(void);
extern void __LIB__ freehand(int);

#endif


/////////////////////////////////////////////////////////////////
// INPUT DEVICES: KEYBOARD, JOYSTICK AND MICE (SEE ALSO INPUT.H)
/////////////////////////////////////////////////////////////////

// Joystick Functions

extern unsigned int  __LIB__ in_JoyFuller(void);
extern unsigned int  __LIB__ in_JoyKempston(void);
extern unsigned int  __LIB__ in_JoySinclair1(void);
extern unsigned int  __LIB__ in_JoySinclair2(void);
extern unsigned int  __LIB__ in_JoyTimex1(void);
extern unsigned int  __LIB__ in_JoyTimex2(void);

// AMX Mouse
//
// To use you must declare the following global variables
// uint in_AMXcoordX, in_AMXcoordY, in_AMXdeltaX, in_AMXdeltaY;

extern void __LIB__             in_MouseAMXInit(uchar xvector, uchar yvector);
extern void __LIB__             in_MouseAMX(uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__             in_MouseAMXSetPos(uint xcoord, uint ycoord);

extern void __LIB__ __CALLEE__  in_MouseAMXInit_callee(uchar xvector, uchar yvector);
extern void __LIB__ __CALLEE__  in_MouseAMX_callee(uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__ __CALLEE__  in_MouseAMXSetPos_callee(uint xcoord, uint ycoord);

#define in_MouseAMXInit(a,b)    in_MouseAMXInit_callee(a,b)
#define in_MouseAMX(a,b,c)      in_MouseAMX_callee(a,b,c)
#define in_MouseAMXSetPos(a,b)  in_MouseAMXSetPos_callee(a,b)

// Kempston Mouse
//
// To use you must declare the following global variables
// uchar in_KempcoordX, in_KempcoordY, in_KemprawX, in_KemprawY;

extern void __LIB__             in_MouseKempInit(void);
extern void __LIB__             in_MouseKemp(uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__             in_MouseKempSetPos(uint xcoord, uint ycoord);

extern void __LIB__ __CALLEE__  in_MouseKemp_callee(uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__ __CALLEE__  in_MouseKempSetPos_callee(uint xcoord, uint ycoord);

#define in_MouseKemp(a,b,c)     in_MouseKemp_callee(a,b,c)
#define in_MouseKempSetPos(a,b) in_MouseKempSetPos_callee(a,b)


//////////////////////////
// DISPLAY FILE FUNCTIONS
//////////////////////////

extern void  __LIB__ __FASTCALL__ border(uchar colour);
extern uchar __LIB__              attr(uchar row, uchar col);

extern uchar __LIB__ __CALLEE__   attr_callee(uchar row, uchar col);
#define attr(a,b)                 attr_callee(a,b)

// DISPLAY PIXEL ADDRESS MANIPULATORS

extern uchar __LIB__              *zx_CharYXToPixelAddr(uchar row, uchar col);
extern uchar __LIB__ __FASTCALL__ *zx_CharYToPixelAddr(uchar row);

extern uchar __LIB__              *zx_PixelXYToPixelAddr(uchar xcoord, uchar ycoord, uchar *mask);
extern uchar __LIB__ __FASTCALL__ *zx_PixelYToPixelAddr(uchar ycoord);

extern uchar __LIB__ __FASTCALL__  zx_PixelAddrToCharX(void *pixeladdr);
extern uchar __LIB__ __FASTCALL__  zx_PixelAddrToCharY(void *pixeladdr);

extern uchar __LIB__               zx_PixelAddrToPixelX(void *pixeladdr, uchar mask);
extern uchar __LIB__ __FASTCALL__  zx_PixelAddrToPixelY(void *pixeladdr);

extern uchar __LIB__ __FASTCALL__ *zx_PixelAddrToAttrAddr(void *pixeladdr);

extern uchar __LIB__ __FASTCALL__ *zx_PixelAddrCharDown(void *pixeladdr);
extern uchar __LIB__ __FASTCALL__ *zx_PixelAddrCharLeft(void *pixeladdr);
extern uchar __LIB__ __FASTCALL__ *zx_PixelAddrCharRight(void *pixeladdr);
extern uchar __LIB__ __FASTCALL__ *zx_PixelAddrCharUp(void *pixeladdr);

extern uchar __LIB__ __FASTCALL__ *zx_PixelAddrPixelDown(void *pixeladdr);
extern uchar __LIB__              *zx_PixelAddrPixelLeft(void *pixeladdr, uchar *mask);
extern uchar __LIB__              *zx_PixelAddrPixelRight(void *pixeladdr, uchar *mask);
extern uchar __LIB__ __FASTCALL__ *zx_PixelAddrPixelUp(void *pixeladdr);

// DISPLAY ATTRIBUTE ADDRESS MANIPULATORS

extern uchar __LIB__              *zx_CharYXToAttrAddr(uchar row, uchar col);
extern uchar __LIB__ __FASTCALL__ *zx_CharYToAttrAddr(uchar row);

extern uchar __LIB__              *zx_PixelXYToAttrAddr(uchar xcoord, uchar ycoord);
extern uchar __LIB__ __FASTCALL__ *zx_PixelYToAttrAddr(uchar ycoord);

extern uchar __LIB__ __FASTCALL__  zx_AttrAddrToCharX(void *attraddr);
extern uchar __LIB__ __FASTCALL__  zx_AttrAddrToCharY(void *attraddr);
 
extern uchar __LIB__ __FASTCALL__  zx_AttrAddrToPixelX(void *attraddr);
extern uchar __LIB__ __FASTCALL__  zx_AttrAddrToPIxelY(void *attraddr);

extern uchar __LIB__ __FASTCALL__ *zx_AttrAddrToPixelAddr(void *attraddr);

extern uchar __LIB__ __FASTCALL__ *zx_AttrAddrCharDown(void *attraddr);
extern uchar __LIB__ __FASTCALL__ *zx_AttrAddrCharLeft(void *attraddr);
extern uchar __LIB__ __FASTCALL__ *zx_AttrAddrCharRight(void *attraddr);
extern uchar __LIB__ __FASTCALL__ *zx_AttrAddrCharUp(void *attraddr);


#endif
