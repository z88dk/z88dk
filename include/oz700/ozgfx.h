/* 
	HTC Compatibility Library and OZ extras 
	1. GRAPHICS AND DISPLAY

	$Id: ozgfx.h,v 1.6 2003-10-23 15:45:47 stefano Exp $
*/

#include <graphics.h>

#ifndef _OZGFX_H
#define _OZGFX_H

#ifndef OZ7XX
#define OZ7XX
#ifdef putchar
# undef putchar
int putchar(char c);
#endif
#endif

#ifndef _OZ_BYTE
typedef unsigned char byte;
#define _OZ_BYTE
#endif

//#ifndef NULL
//#define NULL ((void*)0)
//#endif

#define GREYSHADE_WHITE 0
#define GREYSHADE_BLACK 3
#define GREYSHADE_GREY1 1
#define GREYSHADE_GREY2 2
#define WHITE 0
#define BLACK 1
#define XOR   2
#define FILL   4
#define UNFILL 0
#define FONT_PC_NORMAL 1
#define FONT_PC_LARGE 0
#define FONT_OZ_NORMAL 3
#define FONT_OZ_LARGE 2


//extern __LIB__ ozsetactivepage(byte page);
extern __LIB__ ozsetactivepage(byte page);
extern __LIB__ ozsetdisplaypage(byte page);
extern byte __LIB__ ozgetactivepage(void);
extern byte __LIB__ ozgetdisplaypage(void);
extern __LIB__ ozdisplayactivepage(void);
extern __LIB__ ozactivatedisplaypage(void);
extern __LIB__ ozcopypage(byte dest, byte src);

#define ozswapactivedisplaypages ozswapactivedisplay
extern __LIB__ ozswapactivedisplay(void);

#define MAX_DISPLAYPAGES 2

//extern __LIB__ ozcls(void);
#define ozcls clg

#define _ozpoint ozpoint
//extern int __LIB__ _ozpoint(byte x, byte y, byte color);
//extern int __LIB__ ozpoint(int x, int y, byte color);
int ozpoint(int x, int y, byte color)
{
	if (x>239 || y>80) return -1;
	if (color = BLACK) plot (x,y);
	if (color = WHITE) unplot (x,y);
}

//extern __LIB__ ozcircle(int x,int y,byte r,byte color);
void ozcircle(int x,int y,byte r,byte color)
{
	if (color = BLACK) circle (x,y,r,1);
	if (color = WHITE) uncircle (x,y,r,1);
}

#define _ozline ozline
//extern __LIB__ ozline(int x,int y,int x2,int y2,byte color);
//extern __LIB__ _ozline(byte x,byte y,byte x2,byte y2,byte color);
void ozline(int x,int y,int x2,int y2,byte color)
{
	if (color = BLACK) draw (x,y,x2,y2);
	if (color = WHITE) undraw (x,y,x2,y2);
}


//extern __LIB__ _ozhline(byte x,byte y,byte len,byte color);
void _ozhline(byte x,byte y,byte len,byte color)
{
	if (color = BLACK) draw (x,y,x,y+len);
	if (color = WHITE) undraw (x,y,x,y+len);
}
//extern __LIB__ _ozvline(byte x,byte y,byte len,byte color);
void _ozvline(byte x,byte y,byte len,byte color)
{
	if (color = BLACK) draw (x,y,x+len,y);
	if (color = WHITE) undraw (x,y,x+len,y);
}

extern __LIB__ ozdisplayorbyte(unsigned offset, byte v);
extern __LIB__ ozdisplayputbyte(unsigned offset, byte v);
extern __LIB__ ozdisplayandbyte(unsigned offset, byte v);
extern __LIB__ ozdisplayinbyte(unsigned offset);

//#define ozgetpoint point

//extern int __LIB__ ozgetpoint(int x, int y);
int ozgetpoint(int x, int y)
{
    return (!point (x,y));
}

#define _ozbox ozbox
//extern __LIB__ _ozbox(byte x, byte y, byte width, byte height);
//extern __LIB__ ozbox(int x, int y, int width, int height);
void ozbox(int x, int y, int width, int height)
{
	drawb (x,y,width,height);
}

/*
extern __LIB__ ozsetgreyscale(byte grey);
extern byte __LIB__ ozgetgreyscale(void);
extern __LIB__ ozgreyfilledcircle(int x,int y,byte r,byte shade);
extern __LIB__ ozgreycircle(int x,int y,byte r,byte shade);
extern __LIB__ ozgreyline(int x1,int y1,int x2,int y2,byte shade);
extern int __LIB__ ozgreypoint(int x1,int y1,byte shade);
extern byte __LIB__ ozgetfontheight(byte f);
extern int __LIB__ ozgreyputs(int x,int y,byte shade,char *s);
extern __LIB__ ozgreycls(void);
extern __LIB__ ozgreyfilledbox(int x,int y,int w,int h,byte shade);
extern __LIB__ ozgreybox(int x,int y,int w,int h,byte shade);
extern int __LIB__ ozgreygetpoint(int x, int y);
extern int __LIB__ ozgreyeditline(byte x0,byte y0,char *s,byte slen,byte xlen,byte shade);
extern int __LIB__ ozgreyputch(int x,int y,byte shade,char c);
*/

#define _ozfilledbox ozfilledbox
extern __LIB__ ozfilledbox(int x,int y,int w,int h,byte color);
//extern __LIB__ _ozfilledbox(byte x,byte y,byte w,byte h,byte color);
extern __LIB__ ozscroll(unsigned numbytes);
extern __LIB__ ozscrolldown(unsigned numbytes);
extern __LIB__ ozscrollclear(void);
extern __LIB__ ozsavescreen(void);
extern __LIB__ ozrestorescreen(void);

//extern __LIB__ _ozputsprite(byte x,byte y,byte height,byte *sprite);
#define _ozputsprite ozputsprite
extern __LIB__ ozputsprite(byte x,byte y,byte height,byte *sprite);

extern char __LIB__ *ozputsgetend(void);
extern int __LIB__ ozputs_system(int x, int y, char *string);
extern int __LIB__ ozputs(int x, int y, char *string);
// extern __LIB__ ozfont(byte fontnum);
#define ozfont ozsetfont
extern __LIB__ ozgetfont();
extern __LIB__ ozsetfont(byte fontnum);
extern int __LIB__ ozputch(int x, int y, char c);
extern __LIB__ ozscrollright(byte y , byte rows);
extern __LIB__ ozscrollleft(byte y , byte rows);

#endif
