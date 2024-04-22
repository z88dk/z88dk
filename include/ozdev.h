/*
 *      Small C+ Library
 *
 *  ozdev.h - OZDEV SDK C compatibility for the Sharp Wizard organizers
 * 
 *	To enabe the ozdev emulation, replace the existing <oz.h> declaration
 *	with <ozdev.h> in your program for the Sharp Wizard
 *
 *  This include file is a quick and dirty porting tool to explore the feasibility of providing a whole compatibility library
 *
 *  Porting hints
 *  - If not present, at the beginning of your program add a call to ozcls()
 *  - ozputs(..) does not have an output value, when a value is expected then pick it from ozdev_x
 *  - The keyboard mapping should probably reorganized (KEY_BACKLIGHT is useless on many targets, KEY_*MENU does not exist, etc..)
 *  - oz_background is used only by ozcopypage(p,q). It is memory consuming, comment it out if useless.
 *  - ozpoint(),ozline(), etc.. are macros including three drawing modes.  Replace with z88dk specific code to save memory.
 *  - the above recomendation is valid for all the oz related code.
 * 
 *
 *      Stefano - Spring 2024
 *
 *	$Id: ozdev.h $
 */

#ifndef __OZDEV_H__
#define __OZDEV_H__


#include <conio.h>
#include <stdio.h>
//#include <stdlib.h>
#include <ctype.h>

//#include <graphics.h>
//typedef unsigned char  byte;
#define OZ7XX
#include <arch/oz700/ozgfx.h>

#include <lib3d.h>
#include <X11/XLib.h>
#include <fcntl.h>

#include <arch/oz700/ozgfx.h>

// BREAK/SPACE
#define KEY_MYPROGRAMS ' '
#define KEY_LOWER_ESC ' '
#define KEY_UPPER_ESC ' '
#define KEY_LOWER_ENTER ' '
#define KEY_UPPER_ENTER ' '

// EDIT
#define KEY_LOWER_MENU 11
#define KEY_UPPER_MENU 11

//#define KEY_BACKLIGHT 255
#define KEY_LEFT '5'
#define KEY_RIGHT '8'
#define KEY_UP '7'
#define KEY_DOWN '6'
#define KEY_PAGEUP '/'
#define KEY_PAGEDOWN '&'
#define KEY_NEWLINE 13


//unsigned char ozdev_stencil[256*4];
//int ozdev_fillstyle;

int ozfile1;

Display *ozdev_display;
XFontStruct *ozdev_font_info;

GC *ozdev_gc;
struct _XWIN ozdev_mywin;
char ozdev_font[]="9xxxxx";
int ozdev_x;
int ozdev_y;
int ozdev_ozpointcolor=1;
// 240x80 display buffer for save/restore
unsigned char oz_background[1244]={240,40,240,40};

#undef ozcls
#define ozcls()	clg();ozdev_mywin.a_x=ozdev_mywin.a_y=0;ozdev_gc=XCreateGC(ozdev_display,0,0,0);ozdev_font_info=XLoadQueryFont(0,"9");XSetFont(ozdev_display,ozdev_gc,ozdev_font_info->fid);
#define ozscrollclear() ozcls()


#undef ozfont
#undef ozsetfont
#define ozsetfont(a) (a&1)?XLoadQueryFont(0,"9"):XLoadQueryFont(0,"12");XSetFont(ozdev_display,ozdev_gc,ozdev_font_info->fid)


//XLoadQueryFont(0,"9");XSetFont(ozdev_display,ozdev_gc,ozdev_font_info->fid);

#define unlink(a) remove(a)

// re#defined functions will trap the keywords overriding the declared functions
#define	ozputs(a,b,c) XDrawString(ozdev_display,ozdev_mywin,ozdev_gc,a,b,c,strlen(c));

  //bksave/bkrestore
#define	ozcopypage(a,b) a?bkrestore(oz_background):bksave(0,0,oz_background)


#define	ozclick(a) {}
#define	ozsound(a) {}
#define	ozquiet(a) {}
#define	ozsnap() {}

#define ozkeyhit() kbhit()
#define	ozngetch() fgetc_cons()
#define	ozgetch()  fgetc_cons()

#define ozdelay(a) msleep(a)

#define ozgetpoint(a,b) point(a,b)

#define open1(a,b) (ozfile1=open(a,b,_IOTEXT))
#define close1() close(ozfile1)
#define read1(a,b) read(ozfile1,a,b)
#define write1(a,b) write(ozfile1,a,b)


// Drawing mode: 0:WHITE, 1=BLACK, 3=XOR

#undef ozpointcolor
#define ozpointcolor(a) ozdev_ozpointcolor=a

#undef ozpoint
#define ozpoint(a,b,c) switch(c){case 1: plot(a,b); case 0: unplot(a,b); default: xorplot(a,b);}

#undef ozline
#define ozline(a,b,d,e,c) switch(c){case 1: draw(a,b,d,e); case 0: undraw(a,b,d,e); default: xordraw(a,b,d,e);}

#undef ozcircle
#define ozcircle(a,b,r,c) switch(r){case 1: circle(a,b,r,1); case 0: uncircle(a,b,r,1); default: xorcircle(a,b,r,1);}

#undef ozbox
#define ozbox(a,b,c,d) drawb(a,b,c,d)

#undef ozfilledbox
#define ozfilledbox(a,b,d,e,c) switch(c){case 1: fillb(a,b,d,e); case 0: clga(a,b,d,e); default: xorclga(a,b,d,e);}

#undef ozhline
#undef ozvline
#define ozhline(a,b,h,c) switch(c){case 1: draw(a,b,a+h,b); case 0: undraw(a,b,a+h,b); default: xordraw(a,b,a+h,b);}
#define ozvline(a,b,h,c) switch(c){case 1: draw(a,b,a,b+h); case 0: undraw(a,b,a,b+h); default: xordraw(a,b,a,b+h);}


#endif /* __OZDEV_H__ */
