/*
 *      Small C+ Library
 *
 *  bgi.h - Turbo C compatibility
 * 
 *	Minimal implementation of the Borland BGI style functions
 *	plus few more TC peculiarities.
 *
 * 
 *  Good value for gfxscale (256x192):  -DGFXSCALEX=2/5 and -DGFXSCALEY=2/5   (try also 1/3)
 *  TS2068 HR (512x192):  -DGFXSCALEX=4/5 -DGFXSCALEY=2/5
 * 
 *  Do not use GFXSCALEX/Y if the program relies on getmaxx() and getmaxy()
 * 
 * 
 * Build examples:
 *  zcc +zx -lndos -create_app -DGFXSCALEX=2/5 -lx11 -llib3d myprogram.c
 *  zcc +ts2068 -startup=2 -lgfx2068hr -lndos -DGFXSCALEX=4/5 -DGFXSCALEY=2/5 -lx11 -llib3d -create-app -zorg=40000 -O3 bar3d.c
 *
 *      stefano - 22/10/2012
 *
 *	$Id: bgi.h,v 1.2 2013-09-30 15:10:34 stefano Exp $
 */

#ifndef __BGI_H__
#define __BGI_H__

/* Let's assure <graphics.h> is already loaded */
#include <graphics.h>
#include <lib3d.h>
#include <conio.h>
#include <X11/XLib.h>


#define	setfillstyle(a,b) {}
// setcolor(a) printf("\033[%um",PCDOS_COLORS[a]+30)
#define setcolor(a) {}
#define setbkcolor(a) {}
#define setlinestyle(a,b,c) {}
#define getmacc(a) {}

enum horiz { LEFT_TEXT, CENTER_TEXT, RIGHT_TEXT };

enum vertical { BOTTOM_TEXT, VCENTER_TEXT, TOP_TEXT };

enum font_names { DEFAULT_FONT, TRIPLEX_FONT, SMALL_FONT, SANS_SERIF_FONT,
             GOTHIC_FONT, SCRIPT_FONT, SIMPLEX_FONT, TRIPLEX_SCR_FONT,
			 COMPLEX_FONT, EUROPEAN_FONT, BOLD_FONT };

enum line_styles { SOLID_LINE, DOTTED_LINE, CENTER_LINE, DASHED_LINE, USERBIT_LINE };

enum fill_styles { EMPTY_FILL, SOLID_FILL, LINE_FILL, LTSLASH_FILL, SLASH_FILL,
                   BKSLASH_FILL, LTBKSLASH_FILL, HATCH_FILL, XHATCH_FILL, INTERLEAVE_FILL,
                   WIDE_DOT_FILL, CLOSE_DOT_FILL, USER_FILL };

enum graphics_drivers { DETECT, CGA, MCGA, EGA, EGA64, EGAMONO, IBM8514, HERCMONO,
                        ATT400, VGA, PC3270 };

enum graphics_modes { CGAC0, CGAC1, CGAC2, CGAC3, CGAHI, 
                      MCGAC0 = 0, MCGAC1, MCGAC2, MCGAC3, MCGAMED, MCGAHI,
                      EGALO = 0, EGAHI,
                      EGA64LO = 0, EGA64HI,
                      EGAMONOHI = 3,
                      HERCMONOHI = 0,
                      ATT400C0 = 0, ATT400C1, ATT400C2, ATT400C3, ATT400MED, ATT400HI,
                      VGALO = 0, VGAMED, VGAHI,
                      PC3270HI = 0,
                      IBM8514LO = 0, IBM8514HI };

enum graph_errors { grInvalidVersion = -18, grInvalidDeviceNum = -15, grInvalidFontNum,
                    grInvalidFont, grIOerror, grError, grInvalidMode, grNoFontMem,
                    grFontNotFound, grNoFloodMem, grNoScanMem, grNoLoadMem,
                    grInvalidDriver, grFileNotFound, grNotDetected, grNoInitGraph,
                    grOk };

enum putimage_ops{ COPY_PUT, XOR_PUT, OR_PUT, AND_PUT, NOT_PUT };

#define NORM_WIDTH      1
#define THICK_WIDTH     3

#define USER_CHAR_SIZE  0
#define HORIZ_DIR       0
#define VERT_DIR        1

#define CURRENT_WINDOW -1
#define ALL_WINDOWS -2
#define NO_CURRENT_WINDOW -3

Display *bgi_display;
XFontStruct *bgi_font_info;
GC *bgi_gc;
struct _XWIN bgi_mywin;
char bgi_font[]="9xxxxx";
int bgi_x;
int bgi_y;

#define setviewport(a,b,c,d,e) {}
//#define initgraph(a,b,c)	bgi_display=XOpenDisplay(NULL);bgi_screen=DefaultScreen(bgi_display);bgi_win=XCreateSimpleWindow(bgi_display,RootWindow(bgi_display,bgi_screen),0,0,DisplayWidth(bgi_display,bgi_screen)-4,DisplayHeight(bgi_display,bgi_screen)-4,4,BlackPixel(bgi_display,bgi_screen),WhitePixel(bgi_display,bgi_screen));XMapWindow(bgi_display,bgi_win)
#define initgraph(a,b,c)	clg();bgi_mywin.a_x=bgi_mywin.a_y=0;bgi_gc=XCreateGC(bgi_display,0,0,0);bgi_font_info=XLoadQueryFont(0,"9");XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define detectgraph(a,b)	{}
#define cleardevice()		clg()
//#define closegraph() clg;XFreeGC(bgi_display,bgi_gc);XCloseDisplay(bgi_display)
#define closegraph() clg

#define getmaxcolor()	1
#define graphresult()	grOk
//#define	grOk	0
#define grapherrormsg(a) "z88dk gfx emulation ready"
//#define DETECT	0

#define	moveto(a,b) bgi_x=a;bgi_y=b


#define	settextjustify(a,b)	{}
//#define setviewport(vp) {}
#define getviewsettings(vp) {}

typedef struct arccoordstype {
    int x;
    int y;
    int xstart;
    int ystart;
    int xend;
    int yend;
} arccoordstype;

//typedef char fillpatterntype[8];

struct fillsettingstype {
    int pattern;
    int color;
};

struct linesettingstype {
    int linestyle;
    unsigned int upattern;
    int thickness;
};

struct palettetype {
    unsigned char size;
    signed char colors[16];
};

struct textsettingstype {
    int font;	
    int direction;  
    int charsize;
    int horiz;
    int vert;
};

struct viewporttype {
    int left;
    int top;
    int right;
    int bottom;
    int clip;
};


#ifndef GFXSCALEY
#define GFXSCALEY GFXSCALEX
#endif

#ifdef GFXSCALEX
#define	getpixel(a,b)	point((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	putpixel(a,b,c)	((c) ? plot((a)*GFXSCALEX,(b)*GFXSCALEY):unplot((a)*GFXSCALEX,(b)*GFXSCALEY))
//#define	linerel(a,b)	drawr(a*GFXSCALEX,b*GFXSCALEY)
#define	rectangle(a,b,c,d)	drawb((a)*GFXSCALEX,(b)*GFXSCALEY,((c)-(a))*GFXSCALEX,((d)-(b))*GFXSCALEY)
#define	bar(a,b,c,d)	drawb((a)*GFXSCALEX,(b)*GFXSCALEY,((c)-(a))*GFXSCALEX,((d)-(b))*GFXSCALEY);fill((a)*GFXSCALEX+1,(b)*GFXSCALEY+1);xorborder((a)*GFXSCALEX+1,(b)*GFXSCALEY+1,((c)-(a)+1)*GFXSCALEX+2,((d)-(b)+1)*GFXSCALEY+2)
//#define	circle(a,b,c)	circle(a*GFXSCALEX,b*GFXSCALEY,c*GFXSCALEX,1)
#define	ellipse(a,b,c,d,e,f)	ellipse((a)*GFXSCALEX,(b)*GFXSCALEY,c,d,(e)*GFXSCALEX,(f)*GFXSCALEY)
#define	circle(a,b,c)	ellipse(a,b,0,360,c,c)
#define	circle(a,b,c) polygon((a)*GFXSCALEX,(b)*GFXSCALEY,180,(c)*GFXSCALEY,0);
//#define	ellipse(a,b,c,d,e,f)	plot((a-e)*GFXSCALEX,b*GFXSCALEY);drawr(e*GFXSCALEX,f*GFXSCALEY);drawr(e*GFXSCALEX,-f*GFXSCALEY);drawr(-e*GFXSCALEX,-f*GFXSCALEY);drawr(-e*GFXSCALEX,f*GFXSCALEY)
//#define	ellipse(a,b,c,d,e,f)	ellipse(a*GFXSCALEX,b*GFXSCALEY,c*GFXSCALEX,d*GFXSCALEY,e*GFXSCALEX,f*GFXSCALEY)
#define	sector(a,b,c,d,e,f)	plot(((a)-(e))*GFXSCALEX,(b)*GFXSCALEY);drawr((e)*GFXSCALEX,(f)*GFXSCALEY);drawr((e)*GFXSCALEX,-(f)*GFXSCALEY);drawr(-(e)*GFXSCALEX,-(f)*GFXSCALEY);drawr(-(e)*GFXSCALEX,(f)*GFXSCALEY);fill(((a)-(e)/2)*GFXSCALEX,(b)*GFXSCALEY);
//#define	fillellipse(a,b,c,d)	ellipse((a)*GFXSCALEX,(b)*GFXSCALEY,1,350,(c)*GFXSCALEX,(d)*GFXSCALEY);plot((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	fillellipse(a,b,c,d)	ellipse(a,b,0,360,c,d)
#define	line(a,b,c,d)	draw((a)*GFXSCALEX,(b)*GFXSCALEY,(c)*GFXSCALEX,(d)*GFXSCALEY)
//#define	arc(a,b,c,d,e)	draw(a*GFXSCALEX,b*GFXSCALEY,(a+e)*GFXSCALEX,(d+e)*GFXSCALEY)
//#define	pieslice(a,b,c,d,e)	draw(a*GFXSCALEX,b*GFXSCALEY,(a+e)*GFXSCALEX,(d+e)*GFXSCALEY)
#define	drawpoly(a,b)	for(bgi_x=0;bgi_x<((a)-1);bgi_x++){draw(b[bgi_x*2]*GFXSCALEX,b[1+bgi_x*2]*GFXSCALEY,b[2+bgi_x*2]*GFXSCALEX,b[3+bgi_x*2]*GFXSCALEY);}
#define floodfill(a,b,c)	fill((a)*GFXSCALEX,(b)*GFXSCALEY)
#define	outtext(c) XDrawString(bgi_display,bgi_mywin,&bgi_gc,bgi_x*GFXSCALEX,bgi_y*GFXSCALEY,c,strlen(c));bgi_x+=XTextWidth(bgi_font_info->fid,c,strlen(c))
#define	outtextxy(a,b,c) XDrawString(bgi_display,bgi_mywin,&bgi_gc,(a)*GFXSCALEX,(b)*GFXSCALEY,c,strlen(c));
#define	settextstyle(a,b,c) itoa((c)+(a)*3*GFXSCALEX,bgi_font,10);bgi_font_info=XLoadQueryFont(0,bgi_font);XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define	setusercharsize(a,b,c,d) itoa(10*(a)*GFXSCALEX/(b),bgi_font,10);bgi_font_info=XLoadQueryFont(0,bgi_font);XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define textheight(a) 10*GFXSCALEX

#else
#define	getpixel(a,b)	point(a,b)
#define	putpixel(a,b,c)	(c ? plot(a,b):unplot(a,b))
//#define	linerel(a,b)	drawr(a,b)
#define	rectangle(a,b,c,d)	drawb(a,b,c-a+1,d-b+1)
#define	bar(a,b,c,d)	drawb(a,b,c-a+1,d-b+1);fill(a+1,b+1);xorborder(a+1,b+1,c-a+3,d-b+3)
//#define	circle(a,b,c)	circle(a,b,c,1)
#define	circle(a,b,c)	ellipse(a,b,0,360,c,c)
//#define	ellipse(a,b,c,d,e,f)	plot((a-e),b);drawr(e,f);drawr(e,-f);drawr(-e,-f);drawr(-e,f)
#define	sector(a,b,c,d,e,f)	plot((a-e),b);drawr(e,f);drawr(e,-f);drawr(-e,-f);drawr(-e,f);fill((a-e/2),b)
//#define	fillellipse(a,b,c,d)	plot((a-c),b);drawr(c,d);drawr(c,-d);drawr(-c,-d);drawr(-c,d)
#define	fillellipse(a,b,c,d)	ellipse(a,b,0,360,c,d);fill(a,b)
//#define	circle(a,b,c)	ellipse(a,b,0,360,c,c)
#define	line(a,b,c,d)	draw(a,b,c,d)
//#define	arc(a,b,c,d,e)	draw(a*GFXSCALEX,b*GFXSCALEY,(a+e)*GFXSCALEX,(d+e)*GFXSCALEY)
//#define	pieslice(a,b,c,d,e)	draw(a*GFXSCALEX,b*GFXSCALEY,(a+e)*GFXSCALEX,(d+e)*GFXSCALEY)
#define	drawpoly(a,b)	for(bgi_x=0;bgi_x<(a-1);bgi_x++){draw(b[bgi_x*2],b[1+bgi_x*2],b[2+bgi_x*2],b[3+bgi_x*2]);}
#define floodfill(a,b,c)	fill(a,b)
#define	outtext(c) XDrawString(bgi_display,bgi_mywin,&bgi_gc,bgi_x,bgi_y,c,strlen(c));bgi_x+=XTextWidth(bgi_font_info->fid,c,strlen(c))
#define	outtextxy(a,b,c) XDrawString(bgi_display,bgi_mywin,&bgi_gc,a,b,c,strlen(c))
#define	settextstyle(a,b,c) itoa(c+a*2,bgi_font,10);bgi_font_info=XLoadQueryFont(0,bgi_font);XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define	setusercharsize(a,b,c,d) itoa(10*a/b,bgi_font,10);bgi_font_info=XLoadQueryFont(0,bgi_font);XSetFont(bgi_display,bgi_gc,bgi_font_info->fid);
#define textheight(a) 10

#endif


#define putimage(x,y,i,m) {}


#endif /* __BGI_H__ */
