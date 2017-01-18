/* 
	HTC Compatibility Library and OZ extras 
	1. GRAPHICS AND DISPLAY

	$Id: ozgfx.h,v 1.10 2016-07-07 05:53:28 stefano Exp $
*/


#ifndef _OZGFX_H
#define _OZGFX_H

#include <graphics.h>
#include <sys/compiler.h>

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


extern __LIB__ ozsetactivepage(int page);
extern __LIB__ ozsetdisplaypage(int page);
extern byte __LIB__ ozgetactivepage(void);
extern byte __LIB__ ozgetdisplaypage(void);
extern __LIB__ ozdisplayactivepage(void);
extern __LIB__ ozactivatedisplaypage(void);
extern __LIB__ ozcopypage(int dest, int src) __smallc;

#define ozswapactivedisplaypages ozswapactivedisplay
extern __LIB__ ozswapactivedisplay(void);

#define MAX_DISPLAYPAGES 2

//extern __LIB__ ozcls(void);
#define ozcls clg

#define _ozpoint ozpoint
//extern int __LIB__ _ozpoint(int x, int y, int colour);
extern int __LIB__ ozpoint(int x, int y, int color) __smallc;
/*int ozpoint(int x, int y, int colour)
{
	if (x>239 || y>80) return -1;
	if (color = BLACK) plot (x,y);
	if (color = WHITE) unplot (x,y);
}
*/

extern __LIB__ ozcircle(int x,int y,int r,int color) __smallc;
/*
void ozcircle(int x,int y,int r,int colour)
{
	if (color = BLACK) circle (x,y,r,1);
	if (color = WHITE) uncircle (x,y,r,1);
}
*/

#define _ozline ozline
extern __LIB__ ozline(int x,int y,int x2,int y2,int color) __smallc;
//extern __LIB__ _ozline(int x,int y,int x2,int y2,int colour);
/*
void ozline(int x,int y,int x2,int y2,int colour)
{
	if (color = BLACK) draw (x,y,x2,y2);
	if (color = WHITE) undraw (x,y,x2,y2);
}
*/
#define _ozhline ozhline
extern __LIB__ ozhline(int x,int y,int len,int colour) __smallc;
/*
void _ozhline(int x,int y,int len,int colour)
{
	if (color = BLACK) draw (x,y,x,y+len);
	if (color = WHITE) undraw (x,y,x,y+len);
}
*/
#define _ozvline ozvline
extern __LIB__ ozvline(int x,int y,int len,int colour) __smallc;
/*
void _ozvline(int x,int y,int len,int colour)
{
	if (color = BLACK) draw (x,y,x+len,y);
	if (color = WHITE) undraw (x,y,x+len,y);
}
*/
extern __LIB__ ozdisplayorbyte(unsigned offset, int v) __smallc;
extern __LIB__ ozdisplayputbyte(unsigned offset, int v) __smallc;
extern __LIB__ ozdisplayandbyte(unsigned offset, int v) __smallc;
extern __LIB__ ozdisplayinbyte(unsigned offset);

//#define ozgetpoint point

//extern int __LIB__ ozgetpoint(int x, int y);
int ozgetpoint(int x, int y)
{
    return (!point (x,y));
}

#define _ozbox ozbox
extern __LIB__ ozbox(int x, int y, int width, int height) __smallc;
//extern __LIB__ ozbox(int x, int y, int width, int height);
/*
void ozbox(int x, int y, int width, int height)
{
	drawb (x,y,width,height);
}
*/

/*
extern __LIB__ ozsetgreyscale(int grey);
extern byte __LIB__ ozgetgreyscale(void);
extern __LIB__ ozgreyfilledcircle(int x,int y,int r,int shade) __smallc;
extern __LIB__ ozgreycircle(int x,int y,int r,int shade) __smallc;
extern __LIB__ ozgreyline(int x1,int y1,int x2,int y2,int shade) __smallc;
extern int __LIB__ ozgreypoint(int x1,int y1,int shade) __smallc;
extern byte __LIB__ ozgetfontheight(int f);
extern int __LIB__ ozgreyputs(int x,int y,int shade,char *s) __smallc;
extern __LIB__ ozgreycls(void);
extern __LIB__ ozgreyfilledbox(int x,int y,int w,int h,int shade) __smallc;
extern __LIB__ ozgreybox(int x,int y,int w,int h,int shade) __smallc;
extern int __LIB__ ozgreygetpoint(int x, int y) __smallc;
extern int __LIB__ ozgreyeditline(int x0,int y0,char *s,int slen,int xlen,int shade) __smallc;
extern int __LIB__ ozgreyputch(int x,int y,int shade,int c) __smallc;
*/

#define _ozfilledbox ozfilledbox
extern __LIB__ ozfilledbox(int x,int y,int w,int h,int colour) __smallc;
//extern __LIB__ _ozfilledbox(int x,int y,int w,int h,int colour);
extern __LIB__ ozscroll(unsigned numbytes);
extern __LIB__ ozscrolldown(unsigned numbytes);
extern __LIB__ ozscrollclear(void);
extern __LIB__ ozsavescreen(void);
extern __LIB__ ozrestorescreen(void);

//extern __LIB__ _ozputsprite(int x,int y,int height,byte *sprite);
#define _ozputsprite ozputsprite
extern __LIB__ ozputsprite(int x,int y,int height,byte *sprite) __smallc;

extern char __LIB__ *ozputsgetend(void);
extern int __LIB__ ozputs_system(int x, int y, char *string) __smallc;
extern int __LIB__ ozputs(int x, int y, char *string) __smallc;
// extern __LIB__ ozfont(byte fontnum);
#define ozfont ozsetfont
extern __LIB__ ozgetfont();
extern __LIB__ ozsetfont(int fontnum);
extern int __LIB__ ozputch(int x, int y, int c) __smallc;
extern __LIB__ ozscrollright(int y , int rows) __smallc;
extern __LIB__ ozscrollleft(int y , int rows) __smallc;

#endif
