/*
 * Headerfile for Spectrum specific stuff
 *
 * $Id: spectrum.h,v 1.12 2006-06-28 22:09:47 stefano Exp $
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
extern int __LIB__ zx_interface1();

/* Other Diagnostics */

extern int __LIB__ zx_basic_length();
extern int __LIB__ zx_var_length();

/* Interface to call BASIC */

extern int __LIB__ zx_goto(int line);
extern int __LIB__ zx_getstr(char variable, char *value);
extern int __LIB__ zx_getint(char *variable);
extern void __LIB__ zx_setint(char *variable, int value);

#endif
