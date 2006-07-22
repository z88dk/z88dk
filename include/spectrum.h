/*
 * Headerfile for Spectrum specific stuff
 *
 * $Id: spectrum.h,v 1.14 2006-07-22 08:30:21 aralbrec Exp $
 */

#ifndef __SPECTRUM_H__
#define __SPECTRUM_H__

#ifndef _T_UCHAR
#define _T_UCHAR
   typedef unsigned char uchar;
#endif

#ifndef _T_UINT
#define _T_UINT
   typedef unsigned int uint;
#endif

#include <sys/types.h>



#ifdef PLUS3
/* If it's a +3 we want the dodos routine */
#pragma output NEEDplus3dodos
extern int __LIB__ findhand();
extern void __LIB__ freehand(int);
#endif

#ifdef RESIDOS
/* If it's residos then we want dodos routines */
#pragma output NEEDresidos
extern int __LIB__ findhand();
extern void __LIB__ freehand(int);
#endif

/* Tape handling routines */

/* Standard tape header */
struct zxtapehdr {
        unsigned char type;
        char    name[10];
        size_t length;
        size_t address;
        size_t offset;
};

extern int __LIB__ tape_save(char *name, size_t loadstart,void *start, size_t len);
extern int __LIB__ tape_save_block(void *addr, size_t len, unsigned char type);
extern int __LIB__ tape_load_block(void *addr, size_t len, unsigned char type);


/* Joystick Functions */

extern unsigned int __LIB__ in_JoyFuller(void);
extern unsigned int __LIB__ in_JoyKempston(void);
extern unsigned int __LIB__ in_JoySinclair1(void);
extern unsigned int __LIB__ in_JoySinclair2(void);
extern unsigned int __LIB__ in_JoyTimex1(void);
extern unsigned int __LIB__ in_JoyTimex2(void);

/* Mouse Functions */

/*
   AMX Mouse Variables - you must declare
   uint in_AMXcoordX, in_AMXcoordY, in_AMXdeltaX, in_AMXdeltaY;
*/

extern void __LIB__ in_MouseAMXInit(uchar xvector, uchar yvector);
extern void __LIB__ in_MouseAMXInit2(void);
extern void __LIB__ in_MouseAMX(uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__ in_MouseAMXSetPos(uint xcoord, uint ycoord);

/*
   Kempston Mouse Variables - you must declare
   uchar in_KempcoordX, in_KempcoordY, in_KemprawX, in_KemprawY;
*/

extern void __LIB__ in_MouseKempInit(void);
extern void __LIB__ in_MouseKemp(uchar *buttons, uint *xcoord, uint *ycoord);
extern void __LIB__ in_MouseKempSetPos(uint xcoord, uint ycoord);

/* Colour Attributes */

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

/* Display Functions */

extern void __LIB__ __FASTCALL__ border(uchar colour);
extern uchar __LIB__ attr(uchar row, uchar col);

/* Manipulating Screen (Pixel) Addresses */

extern void __LIB__ __FASTCALL__ *scr_chardown(void *scrnaddr);
extern void __LIB__ __FASTCALL__ *scr_charleft(void *scrnaddr);
extern void __LIB__ __FASTCALL__ *scr_charright(void *scrnaddr);
extern void __LIB__ __FASTCALL__ *scr_charup(void *scrnaddr);
extern void __LIB__ __FASTCALL__ *scr_getattraddr(void *scrnaddr);
extern void __LIB__ *scr_getcharaddr(uchar row, uchar col);
extern void __LIB__ *scr_getscrnaddr(uint xcoord, uchar ycoord, uchar *mask);
extern void __LIB__ __FASTCALL__ *scr_pixeldown(void *scrnaddr);
extern void __LIB__ __FASTCALL__ *scr_pixelup(void *scrnaddr);
extern void __LIB__ *scr_pixelleft(void *scrnaddr, uchar *mask);
extern void __LIB__ *scr_pixelright(void *scrnaddr, uchar *mask);

/* Manipulating Attribute Addresses */

extern void __LIB__ *attr_getcharaddr(uchar row, uchar col);
extern void __LIB__ __FASTCALL__ *attr_chardown(void *attraddr);
extern void __LIB__ __FASTCALL__ *attr_charleft(void *attraddr);
extern void __LIB__ __FASTCALL__ *attr_charright(void *attraddr);
extern void __LIB__ __FASTCALL__ *attr_charup(void *attraddr);
extern void __LIB__ __FASTCALL__ *attr_getscrnaddr(void *attraddr);

/* Diagnostics - TRUE or FALSE */

extern int __LIB__ zx_128();
extern int __LIB__ zx_128mode();
extern int __LIB__ zx_issue3();

/* Other Diagnostics */

extern int __LIB__ zx_basic_length();
extern int __LIB__ zx_var_length();

/* Interface to call BASIC */

extern int __LIB__ zx_goto(int line);
extern int __LIB__ zx_getstr(char variable, char *value);
extern void __LIB__ zx_setstr(char variable, char *value);
extern int __LIB__ zx_getint(char *variable);
extern void __LIB__ zx_setint(char *variable, int value);

/* Token codes for BASIC keyworks */

#define TK_RND     165
#define TK_INKEYS  166
#define TK_PI      167
#define TK_FN      168
#define TK_POINT   169
#define TK_SCREENS 170
#define TK_ATTR    171
#define TK_AT      172
#define TK_TAB     173
#define TK_VALS    174
#define TK_CODE    175
#define TK_VAL     176
#define TK_LEN     177
#define TK_SIN     178
#define TK_COS     179
#define TK_TAN     180
#define TK_ASN     181
#define TK_ACS     182
#define TK_ATN     183
#define TK_LN      184
#define TK_EXP     185
#define TK_INT     186
#define TK_SQR     187
#define TK_SGN     188
#define TK_ABS     189
#define TK_PEEK    190
#define TK_IN      191
#define TK_USR     192
#define TK_STRS    193
#define TK_CHRS    194
#define TK_NOT     195
#define TK_BIN     196
#define TK_OR      197
#define TK_AND     198

#define TK__LEQ    199
#define TK__GEQ    200
#define TK__NEQ    201

#define TK_LINE      202
#define TK_THEN      203
#define TK_TO        204
#define TK_STEP      205
#define TK_DEF_FN    206
#define TK_CAT       207
#define TK_FORMAT    208
#define TK_MOVE      209
#define TK_ERASE     210
#define TK_OPEN      211
#define TK_CLOSE     212
#define TK_MERGE     213
#define TK_VERIFY    214
#define TK_BEEP      215
#define TK_CIRCLE    216
#define TK_INK       217
#define TK_PAPER     218
#define TK_FLASH     219
#define TK_BRIGHT    220
#define TK_INVERSE   221
#define TK_OVER      222
#define TK_OUT       223
#define TK_LPRINT    224
#define TK_LLIST     225
#define TK_STOP      226
#define TK_READ      227
#define TK_DATA      228
#define TK_RESTORE   229
#define TK_NEW       230
#define TK_BORDER    231
#define TK_CONTINUE  232
#define TK_DIM       233
#define TK_REM       234
#define TK_FOR       235
#define TK_GO_TO     236
#define TK_GO_SUB    237
#define TK_INPUT     238
#define TK_LOAD      239
#define TK_LIST      240
#define TK_LET       241
#define TK_PAUSE     242
#define TK_NEXT      243
#define TK_POKE      244
#define TK_PRINT     245
#define TK_PLOT      246
#define TK_RUN       247
#define TK_SAVE      248
#define TK_RANDOMIZE 249
#define TK_IF        250
#define TK_CLS       251
#define TK_DRAW      252
#define TK_CLEAR     253
#define TK_RETURN    254
#define TK_COPY      255

#endif
